
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post_feed/Screens/LogIn.dart';

class SignUp extends StatefulWidget {
  // final User user;
  // final UserModel userModel;

  // SignUp(this.user, this.userModel);

  // SignUp({required this.imageFile,required this.imgUrl})
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _checkedValue = true;
  TextEditingController fullNamecontroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rpasswordController = TextEditingController();
  checkValues() {
    if (fullNamecontroller.text.trim() == "" ||
        emailController.text.trim() == "" ||
        passwordController.text == "" ||
        rpasswordController.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("All Field Mendatory")));
    } else if (passwordController.text != rpasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("password miss match")));
    } else {
      signUp(emailController.text.trim(), passwordController.text);
    }
  }

  signUp(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => LogInScreen(widget.user, widget.userModel)));
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
    //save data to firestore database
    if (userCredential != null) {
      // UserModel userFullName =
      // UserModel(fullname: fullNamecontroller.text.trim());
      String uid = userCredential.user!.uid;


      await FirebaseFirestore.instance
          .collection("registerUsers")
          .doc(uid)
          .set(
        {'username':fullNamecontroller.text,
        'email':emailController.text,
          'password':passwordController.text,
        }
      )
          .then((value) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LogInScreen()
            //  CompleteProfile(
            //     userModel: adduserModel, user: userCredential!.user!)
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Post Feed App",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.teal,
                        )),
                    // const Text(
                    //   "now come to close",
                    //   style: TextStyle(fontSize: 10),
                    // ),
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: fullNamecontroller,
                      decoration: const InputDecoration(hintText: "Full Name"),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: "Email"),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      obscureText: _checkedValue,
                      controller: passwordController,
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
                                : Icon(Icons.visibility)),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: rpasswordController,
                      obscureText: _checkedValue,
                      decoration:
                      const InputDecoration(hintText: "Repeat Password"),
                    ),
                    const SizedBox(
                      height: 24,
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
                            child: const Text("SignUp"))),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have Account",
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "LogIn",
                              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 15),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
