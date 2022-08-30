import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_feed/Constant/constants.dart';
import 'package:post_feed/Screens/AddItems.dart';
import 'package:post_feed/Screens/LogIn.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user=FirebaseAuth.instance.currentUser;
  List nList = [];





  void initState() {
    super.initState();
    Constants.prefs?.setBool("loggedIn", true);

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
          CupertinoButton(
              onPressed: (){
                Constants.prefs?.setBool("loggedIn", false);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LogInScreen()), (route) => false);
              },
              child: Icon(Icons.exit_to_app_outlined, color: Colors.white,))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _HomeScreenState();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0,
            content: Text("Refreshed", textAlign: TextAlign.center,),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            width: 100,
            // margin: EdgeInsets.only(bottom: 10.0),
          ));
        },
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("registerUsers")
              .doc(user!.uid)
              .collection("feedsCollection")
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.active) {
              if (snapshots.hasData) {
                QuerySnapshot dataSnapshot =
                snapshots.data as QuerySnapshot;

                return ReorderableListView.builder(
                    reverse: false,
                    itemCount: dataSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      Map<String,dynamic> newdata=    dataSnapshot.docs[index].data() as Map<String,dynamic>;
                        return Card(
                        key: ValueKey(dataSnapshot.docs),
                        margin: EdgeInsets.only(bottom: 2),
                        child: ListTile(
                          onTap: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                title: Text("Details", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 15,),
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            newdata['image_url'].toString()
                                        ),
                                      ),
                                      title: Text(
                                        newdata['title'].toString(),
                                        style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    ListTile(
                                      leading: SizedBox(height: MediaQuery.of(context).size.height,
                                      width: 61,
                                      ),
                                        title: Text(newdata['description'].toString()),

                                    )
                                  ],
                                ),
                              );
                            });
                          },
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  newdata['image_url'].toString()
                              ),
                            ),
                            title: Text(
                              newdata['title'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(newdata['description'].toString()),
                          // trailing: ReorderableDragStartListener(
                          //   // key: ValueKey(dataSnapshot.docs),
                          //     index: index,
                          //     child: Icon(Icons.drag_handle),
                          //     enabled: true,
                          // ),
                        ),
                      );


                    }, onReorder: reorderData);
              } else if (snapshots.hasError) {
                return const Center(child: Text("Some Error Occured"));
              } else {
                return const Center(
                  child: Text("Say SomeThing"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemsScreen()));

        },
        child: Icon(Icons.add, size: 20,),

      ),
    );
  }
  // void reorderData(int oldindex, int newindex){
  //   setState(() {
  //     if(newindex>oldindex){
  //       newindex-=1;
  //     }
  //   });
  // }
void reorderData(oldIndex, newIndex) => setState(() {
  final index =
  newIndex > oldIndex ? newIndex -= 1 : newIndex;
  //  > oldIndex ? newIndex - 1 : newIndex;
  var dataSnapshot;
  final user = dataSnapshot.docs.removeAt(oldIndex);
  dataSnapshot.docs.insert(index, user);
});
}