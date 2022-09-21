import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/emaildata/emailclassmodel.dart';
import 'package:task1/emaildata/reset.dart';
import '../class/classmodel.dart';
import '../class/shared.dart';

class firstpage extends StatefulWidget {
  TabController tabController;
  String? method;
//jiii
  firstpage(this.tabController,this.method);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  TextEditingController t = TextEditingController();
  TextEditingController t1 = TextEditingController();
  bool chack = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',
                    hintText: 'Enter Your password',
                  ),
                ),
              ),
              ElevatedButton(onPressed: () async {

                if(widget.method=="login"){
                  try {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: t.text,
                      password: t1.text,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {

                      print('The password provided is too weak.');
                      Fluttertoast.showToast(
                          msg: "The password provided is too weak.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );

                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      Fluttertoast.showToast(
                          msg: "The account already exists for that email.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  } catch (e) {
                    print(e);
                  }
                }
                else if(widget.method=="Singin"){
                  try {
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: t.text,
                      password: t1.text,);
                    print(credential);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      Fluttertoast.showToast(
                          msg: "No user found for that email.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      Fluttertoast.showToast(
                          msg: "Wrong password provided for that user.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );

                    }
                  }
                }

              }, child: Text("${widget.method}")),
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
                  child: Text("Signin with google",)),
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return rpassword();
                },));
              }, child: Text("Forgot Password???")),
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
  Future createMail(Emailmodel emailmodel) async {
    final firestore =
    FirebaseFirestore.instance.collection("email").doc("${emailmodel..uid}");

    await firestore.set(emailmodel.toJson());

  }
}
