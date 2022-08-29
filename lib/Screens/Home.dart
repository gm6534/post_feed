import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_feed/Constant/constants.dart';
import 'package:post_feed/Screens/AddItems.dart';
import 'package:post_feed/Screens/LogIn.dart';
import 'package:post_feed/main.dart';

class HomeScreen extends StatefulWidget {
  List<String> item = ["Clients","Designer","Developer","Director",
    "Employee", "Manager", "Worker","Owner",
    "Cliesnts","Desisgner","Develosper","Direcstor",
    "Emplosyee", "Masnager", "Workser","Ownser"
  ];
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  String? imagUrl;
  String? title;
  String? desc;

  void reorderData(int oldindex, int newindex){
    setState(() {
      if(newindex>oldindex){
        newindex-=1;
      }
      final items =widget.item.removeAt(oldindex);
      widget.item.insert(newindex, items);
    });
  }

  void sorting(){
    setState(() {
      widget.item.sort();
    });
  }


  ///User Image

  getCurrentUserImg() async {
    DocumentSnapshot snapshot = (await FirebaseFirestore.instance
        .collection("registerUsers")
        .doc(user!.uid)
        .collection("feedsCollection")
        .doc(uuid.v1())
        .get()) as DocumentSnapshot<Object?>;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    print(map['title']);


    setState(() {
      imagUrl = map['image_url'];
      title = map['title'];
      desc = map['description'];



    });
    // print(uName);
  }


  ///


  void initState() {
    super.initState();
    Constants.prefs?.setBool("loggedIn", true);
    getCurrentUserImg();


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Post Feed",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.sort_by_alpha),
              tooltip:"Sort",
              onPressed: sorting
          ),
          CupertinoButton(
              onPressed: (){
                Constants.prefs?.setBool("loggedIn", false);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LogInScreen()), (route) => false);
              },
              child: Icon(Icons.exit_to_app_outlined, color: Colors.white,))
        ],
      ),
      body: ReorderableListView(
        children: <Widget>[
          for(final items in widget.item)
            Card(
              color: Colors.white,
              key: ValueKey(items),
              elevation: 2,
              child: ListTile(
                title: Text("$title"),
                subtitle: Text("$desc"),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("$imagUrl"),
                    child: Icon(Icons.work,color: Colors.black,)),
              ),
            ),
        ],
        onReorder: reorderData,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemsScreen()));

        },
        child: Icon(Icons.add, size: 20,),

      ),
    );
  }
}