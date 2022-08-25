import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_feed/Screens/Home.dart';



class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({Key? key}) : super(key: key);

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  PickedFile? imageFile;
  final imagePicker = ImagePicker();
  bool onChanged = true;


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
              SizedBox(height: 70,),
              ///Bottom Row (Add Item)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CupertinoButton(
                      onPressed: (){
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
                      onPressed: (){
                      titleController.text;
                      descController.text;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          HomeScreen()));
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


}
