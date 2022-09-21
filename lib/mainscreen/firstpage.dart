import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/emaildata/reset.dart';
import '../class/classmodel.dart';
import '../class/shared.dart';

class firstpage extends StatefulWidget {
  TabController tabController;
  String? method;

//jiii
  firstpage(this.tabController, this.method);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  TextEditingController t = TextEditingController();
  TextEditingController t1 = TextEditingController();
  bool s = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // email
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: t,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                  hintText: 'Enter Your email',
                ),
              ),
            ),
            //password
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: t1,
                obscureText: s,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        s ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          s = !s;
                        });
                      },
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'password',
                    hintText: 'Enter your secure password'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool validation = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    .hasMatch(t.text);

                if (validation == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: const Text(
                        'Please enter valid email',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }

                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: t.text,
                    password: t1.text,
                  );
                  print(credential);

                  UserModal userModel = UserModal(
                    email: t.text,
                    userImage: t1.text,
                    uId: credential.user!.uid,
                  );
                  createemail(userModel);
                  widget.tabController.animateTo(1);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString("login", "Yes");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');

                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: t.text, password: t1.text);
                      widget.tabController.animateTo(1);

                      UserModal userModel = UserModal(
                        email: t.text,
                        phone: t1.text,
                        uId: credential.user!.uid,
                      );

                      if (userModel.uId == credential.user!.uid) {
                        createemail(userModel);
                      }

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString("login", "Yes");

                      print(credential);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: const Text(
                              'wrong-password',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }
                    }
                  }
                } catch (e) {
                  print(e);
                }
                t.clear();
                t1.clear();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Text(
                "Login",
                style: TextStyle(fontSize: 15),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  UserCredential? login = await signInWithGoogle();

                  if (login.user != null) {
                    UserModal userModal = UserModal(
                      email: login.user!.email,
                      name: login.user!.displayName,
                      phone: login.user!.phoneNumber,
                      uId: login.user!.uid,
                      userImage: login.user!.photoURL,
                    );
                    createUser(userModal);
                    widget.tabController.animateTo(1);
                    shared.prefs = await SharedPreferences.getInstance();
                    await shared.prefs!.setString("login", "yes");
                  }
                  print("Login");
                },
                child: Text(
                  "Signin with google",
                )),
            TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return rpassword();
                    },
                  ));
                },
                child: Text("Forgot Password???")),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future createUser(UserModal userModal) async {
    final firestore =
        FirebaseFirestore.instance.collection("user").doc("${userModal.uId}");

    await firestore.set(userModal.toJson());
  }

  Future createemail(UserModal userModal) async {
    final firestore =
        FirebaseFirestore.instance.collection("user").doc("${userModal.uId}");

    await firestore.set(userModal.toJson());
  }
}
