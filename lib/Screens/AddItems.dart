import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:post_feed/Screens/Home.dart';
import 'package:post_feed/main.dart';



class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({Key? key}) : super(key: key);

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {

  String? imagUrl;


  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();


  PickedFile? imageFile;
  final imagePicker = ImagePicker();
  bool onChanged = true;

  final _formkey=GlobalKey<FormState>();





  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    uploadImage();
    // updateDataToFireStore();
    // upload();
  }
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Items"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
               CupertinoButton(
                onPressed: (){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      title: Text("Choose File", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10,),
                          ListTile(
                            onTap: (){
                              pickedImage(ImageSource.camera);
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemsScreen()));
                              Navigator.pop(context);

                            },
                            leading: Icon(Icons.camera_alt),
                            title: Text("Pick From Camera"),
                          ),
                          Divider(),
                          ListTile(
                            onTap: (){
                              pickedImage(ImageSource.gallery);
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemsScreen()));
                              Navigator.pop(context);
                            },
                            leading: Icon(Icons.image_outlined),
                            title: Text("Pick From Gallery"),
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    );
                  });
                },
                padding: EdgeInsets.zero,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(image:  FileImage(File(imageFile != null ?imageFile!.path:"")), fit: BoxFit.cover),
                      color: Colors.teal.shade200, border: Border.all(width: 2, color: Colors.teal.shade400), borderRadius: BorderRadius.circular(10)),

                  child: imageFile == null ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, color: Colors.white, size: 50,),
                      SizedBox(height: 10,),
                      Text("Upload Image", style: TextStyle(color: Colors.white, fontSize: 15),)
                    ],
                  ): null,
                ),
              ),
              SizedBox(height: 20,),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "Type Your Title", hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        border: OutlineInputBorder()
                      ),
                    ),
                    SizedBox(height: 20,),
                    Scrollbar(
                      child: TextField(
                        controller: descController,
                        maxLines: 8,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Type Your Description", hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70,),
              ///Bottom Row (Add Item)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                      onPressed: (){
                        // print(uploadImage());
                        setState(() {
                          onChanged =! onChanged;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child:onChanged != false
                          ? Icon(
                         Icons.favorite_border_outlined, size: 35,):Icon( Icons.favorite, size: 35,),

                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.75, 40))
                    ),
                      child: Text("Add Items"),
                      onPressed: () async {
                        if(_formkey.currentState!.validate()) {
                          // try {
                          // print(emailcontroller!.text);
                          // print(passwordcontroller!.text);
                          // await _auth
                          //     .createUserWithEmailAndPassword(
                          //     email: emailcontroller!.text, password: passwordcontroller!.text).then((uid) => sendDataToFireStore()).catchError((e){
                          //   print(e);
                          // });
                          uploadImage();
                          // upload();
                          // print(imagUrl);
                         await updateDataToFireStore();

                        }
                      // Navigator.pop(context);
                      }
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  pickedImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);

    setState(() {
      imageFile = pickedFile;
    });
  }
  updateDataToFireStore() async{
    FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
    User? user=_auth.currentUser;
    await firebaseFirestore.collection("registerUsers").doc(user!.uid).collection("feedsCollection").doc(uuid.v1()).set({
      "title":titleController.text,
      "description":descController.text,
      "image_url":imagUrl,

    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item Added")));
  }
  uploadImage() async {
    var file = File(imageFile!.path); //file*result
    print(file);
    var ref = FirebaseStorage.instance.ref().child("imgs").child(uuid.v1());
    UploadTask uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();
    setState(() {
      imagUrl = downloadurl;
    });



    // final _firebaseStorage = FirebaseStorage.instance;
    // // final _imagePicker = ImagePicker();
    // // PickedFile image;
    // //Check Permissions
    // await Permission.photos.request();
    //
    // var permissionStatus = await Permission.photos.status;
    //
    // if (permissionStatus.isGranted){
    //   //Select Image
    //   // image = await _imagePicker.getImage(source: ImageSource.gallery);
    //   var file = File(imageFile!.path);
    //
    //   if (imageFile != null){
    //     //Upload to Firebase
    //     var snapshot = await _firebaseStorage.ref().child("images")
    //         .child(uuid.v1())
    //         .putFile(file);
    //     await snapshot.ref.getDownloadURL().then((value) {
    //       print(value+"-=-=-=-=-=-==");
    //       setState(() {
    //       imagUrl = value;
    //     });});
    //     // print(downloadUrl+"------------");
    //
    //   } else {
    //     print('No Image Path Received');
    //   }
    // } else {
    //   print('Permission not granted. Try Again with permission access');
    // }
  }
  // upload() async {
  //   final _firebaseStorage = FirebaseStorage.instance;
  //
  //   var file = File(imageFile!.path);
  //   if (imageFile != null) {
  //     var snapshot = await _firebaseStorage.ref()
  //         .child('images/')
  //         .putFile(file);
  //     var downloadUrl = await snapshot.ref.getDownloadURL();
  //     setState(() {
  //       imagUrl = downloadUrl;
  //     });
  //     print(imagUrl);
  //
  //   } else {
  //     print('Not Found');
  //   }
  // }

}
