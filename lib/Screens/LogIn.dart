import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post_feed/Screens/Home.dart';
import 'package:post_feed/Screens/Reset.dart';
import 'package:post_feed/Screens/SignUp.dart';

class LogInScreen extends StatefulWidget {
  // final User user;
  // final UserModel userModel;

  // const LogInScreen({super.key, required this.user, required this.userModel});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _checkedValue = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  checkValues() async {
    if (emailController.text.trim() == "" || passwordController.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("All Field Mendatory")));
    } else {
      logIn(emailController.text.trim(), passwordController.text);
    }
  }

  logIn(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => HomeScreen(
      //               user: widget.user,
      //               userModel: widget.userModel,
      //             )));
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("registerUsers")
          .doc(uid)
          .get();

      log("Successfully");
      print("Done");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen()),
              (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User Doesn't Exist")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 130,
                  ),
                  const Text("Post Feed App",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.teal,
                      )),
                  const SizedBox(
                    height: 110,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(offset: Offset(0, 3), blurRadius: 7)],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(hintText: "Email"),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _checkedValue,
                            decoration: InputDecoration(
                                hintText: "Password",
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _checkedValue = !_checkedValue;
                                      });
                                    },
                                    child: _checkedValue != false
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility))),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>  ResetScreen()));
                        },
                        child: const Text(
                          "forgot?",
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            checkValues();
                          },
                          child: const Text("LOGIN"))),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an Account ",
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => SignUp()));
                          },
                          child: const Text(
                            "SignUp",
                            style: TextStyle(color: Colors.teal, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          )),
                      SizedBox(height: 30,)
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
