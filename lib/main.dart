import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:post_feed/Constant/constants.dart';
import 'package:post_feed/Screens/LogIn.dart';
import 'package:post_feed/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'Screens/Home.dart';
var uuid = Uuid();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // User? cUser = FirebaseAuth.instance.currentUser;
  Constants.prefs = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    runApp(MyApp());
  }


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Feed',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home:
      // Test()
      Constants.prefs?.getBool('loggedIn') == true ? HomeScreen(): LogInScreen(),
    );
  }
}