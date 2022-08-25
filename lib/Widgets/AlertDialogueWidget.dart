// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:post_feed/Screens/AddItems.dart';
//
// class AlertDialogueWidget extends StatefulWidget {
// final Function callback;
// AlertDialogueWidget({required this.callback});
//
//   @override
//   State<AlertDialogueWidget> createState() => _AlertDialogueWidgetState();
// }
//
// class _AlertDialogueWidgetState extends State<AlertDialogueWidget> {
//   PickedFile? imageFile;
//   final imagePicker = ImagePicker();
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       contentPadding: EdgeInsets.zero,
//       title: Text("Choose File", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: 10,),
//           ListTile(
//             onTap: (){
//               pickedImage(ImageSource.camera);
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemsScreen()));
//               Navigator.pop(context);
//
//             },
//             leading: Icon(Icons.camera_alt),
//             title: Text("Pick From Camera"),
//           ),
//           Divider(),
//           ListTile(
//             onTap: (){
//               pickedImage(ImageSource.gallery);
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemsScreen()));
//               Navigator.pop(context);
//             },
//             leading: Icon(Icons.image_outlined),
//             title: Text("Pick From Gallery"),
//           ),
//           SizedBox(height: 10,),
//         ],
//       ),
//     );
//   }
//   pickedImage(ImageSource source) async {
//     var pickedFile = await imagePicker.getImage(source: source);
//
//     setState(() {
//       imageFile = pickedFile;
//       widget.callback(imageFile!.path);
//     });
//
//   }
//
// }
