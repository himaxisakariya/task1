import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../class/classmodel.dart';
//sign in with google
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
//add google data to firestore firebase
Future createUser(UserModal userModal) async {
  final firestore =
  FirebaseFirestore.instance.collection("user").doc("${userModal.uId}");

  await firestore.set(userModal.toJson());
}
//add email data to firestore firebase
Future createemail(UserModal userModal) async {
  final firestore =
  FirebaseFirestore.instance.collection("user").doc("${userModal.uId}");

  await firestore.set(userModal.toJson());
}