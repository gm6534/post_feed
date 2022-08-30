// import 'dart:io';
// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:post_feed/main.dart';
//
//
// class Test extends StatefulWidget {
//   Test({Key? key}) : super(key: key);
//
//   @override
//   State<Test> createState() => _TestState();
// }
//
// class _TestState extends State<Test> {
//   User? user = FirebaseAuth.instance.currentUser;
//   String? img;
//   String? title;
//   String? desc;
//   List nList = [];
//
//   getCurrentUserImg() async {
//     DocumentSnapshot snapshot = await FirebaseFirestore.instance
//         .collection("registerUsers")
//         .doc(user!.uid)
//         .collection("feedsCollection")
//         .doc(uuid.v1())
//         .get();
//     Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
//     setState(() {
//       img = map['imgUrl'];
//       title = map['title'];
//       desc = map['desc'];
//     });
//   }
//
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   showBox();
//   // }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCurrentUserImg();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//           child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("registerUsers")
//                 .doc(user!.uid)
//                 .collection("feedsCollection")
//                 .snapshots(),
//             builder: (context, snapshots) {
//               if (snapshots.connectionState == ConnectionState.active) {
//                 if (snapshots.hasData) {
//                   QuerySnapshot dataSnapshot = snapshots.data as QuerySnapshot;
//
//                   return ReorderableListView.builder(
//                     // reverse: true,
//                       itemCount: dataSnapshot.docs.length,
//                       onReorder: (oldIndex, newIndex) => setState(() {
//                         final index =
//                         newIndex > oldIndex ? newIndex -= 1 : newIndex;
//                         //  > oldIndex ? newIndex - 1 : newIndex;
//                         final user = dataSnapshot.docs.removeAt(oldIndex);
//                         dataSnapshot.docs.insert(index, user);
//                       }),
//                       itemBuilder: (context, index) {
//                         Map<String, dynamic> newdata = dataSnapshot.docs[index]
//                             .data() as Map<String, dynamic>;
//
//                         return Container(
//                           key: ValueKey(dataSnapshot.docs),
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                       newdata['image_url'].toString()),
//                                 ),
//                                 const SizedBox(
//                                   width: 8,
//                                 ),
//                                 Text(newdata['title'].toString()),
//                                 const SizedBox(
//                                   width: 8,
//                                 ),
//                                 Text(newdata['description'].toString())
//                               ],
//                             ),
//                           ),
//                         );
//                       });
//                 } else if (snapshots.hasError) {
//                   return const Center(child: Text("Some Error Occured"));
//                 } else {
//                   return const Center(
//                     child: Text("Say SomeThing"),
//                   );
//                 }
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//
//           //  Center(
//
//           //   child: Padding(
//           //     padding: const EdgeInsets.all(8.0),
//           //     child: Column(
//           //       children: [
//           //         // section to show user information
//           //         Container(
//           //             height: 120,
//           //             decoration: const BoxDecoration(
//           //                 color: Color.fromARGB(255, 112, 128, 141),
//           //                 borderRadius: BorderRadius.all(Radius.circular(10))),
//           //             child: Row(
//           //               children: [
//           //                 const SizedBox(
//           //                   width: 8,
//           //                 ),
//           //                 const CircleAvatar(
//           //                   backgroundColor: Colors.white,
//           //                   radius: 36,
//           //                   child: CircleAvatar(
//           //                     backgroundColor: Colors.grey,
//           //                     radius: 34,
//           //                   ),
//           //                 ),
//           //                 const SizedBox(
//           //                   width: 6,
//           //                 ),
//           //                 Column(
//           //                   mainAxisAlignment: MainAxisAlignment.center,
//           //                   crossAxisAlignment: CrossAxisAlignment.start,
//           //                   children: [Text("userName"), Text("user ")],
//           //                 )
//           //               ],
//           //             )),
//           //         SizedBox(
//           //           width: MediaQuery.of(context).size.width,
//           //           child: ElevatedButton(
//           //             // color: Color.fromARGB(255, 9, 31, 49),
//           //             onPressed: () {
//           //               Navigator.push(context,
//           //                   MaterialPageRoute(builder: (_) => AddFeed()));
//           //             },
//           //             child: const Icon(
//           //               Icons.add,
//           //               color: Colors.white,
//           //               size: 24,
//           //             ),
//           //           ),
//           //         ),
//
//           //         // Color(
//           //         //                           (Random().nextDouble() * 0xFFFFFF)
//           //         //                                   .toInt() <<
//           //         //                               0)
//           //         Expanded(
//           //           child: ListTile(
//           //             leading: CircleAvatar(
//           //               backgroundImage: NetworkImage(img.toString()),
//           //             ),
//           //             title: Text(title.toString()),
//           //             subtitle: Text(desc.toString()),
//           //           ),
//           //           // child: ListView.builder(
//           //           //     itemCount: myFeed.length,
//           //           //     itemBuilder: (context, index) {
//           //           //       return Container(
//           //           //         color: Color(
//           //           //             (Random().nextDouble() * 0xFFFFFF).toInt() << 0),
//           //           //         child: const ListTile(
//           //           //           // Color(
//           //           //           //               (Random().nextDouble() * 0xFFFFFF)
//           //           //           //                       .toInt() <<
//           //           //           //                   0)
//
//           //           //           leading: CircleAvatar(),
//           //           //           title: Text("abc"),
//           //           //           subtitle: Text("subTitle"),
//           //           //         ),
//           //           //       );
//           //           //     }),
//           //         )
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           child: Icon(
//             Icons.shuffle_on,
//           ),
//         ));
//   }
// }
// for (int index = 0; index < dataSnapshot.docs.length; index++)
