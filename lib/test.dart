import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  User? user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return       Scaffold(
      body: Container(
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

                return ListView.builder(
                    reverse: true,
                    itemCount: dataSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      Map<String,dynamic> newdata=    dataSnapshot.docs[index].data() as Map<String,dynamic>;
                      // MessageModel currentMessage =
                      // MessageModel.fromMap(dataSnapshot.docs[index]
                      //     .data() as Map<String, dynamic>);
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(

                          children: [
                           CircleAvatar(backgroundImage: NetworkImage(newdata['image_url'].toString()),),
                            Text(newdata['title'].toString()),
                            Text(newdata['description'].toString())

                          ],
                        ),
                      );


                    });
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
    );
  }
}
