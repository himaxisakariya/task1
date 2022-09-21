import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../class/classmodel.dart';
import '../class/shared.dart';

class showdata extends StatefulWidget {
  TabController tabController;

  showdata(this.tabController);

  @override
  State<showdata> createState() => _showdataState();
}

class _showdataState extends State<showdata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await GoogleSignIn().signOut();
            print("Logut");
            widget.tabController.animateTo(0);
            shared.prefs = await SharedPreferences.getInstance();
            shared.prefs!.clear();
          },
          child: Icon(Icons.logout)),
      body: StreamBuilder<List<UserModal>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Somthing is wrong');
          } else if (snapshot.hasData) {
            final user = snapshot.data!;

            return ListView(
              children: user.map(buildUser).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildUser(UserModal userModal) => ListTile(
        title: Text(userModal.name!),
        subtitle: Text(userModal.email!),
        leading: userModal.userImage!=null?Image.network("${userModal.userImage}"):Text("Empty"),
        trailing: IconButton(onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete"),
                content: Text("Are You sure You Want to Delete??"),
                actions: [
                  TextButton(
                      onPressed: () {
                        final docUser = FirebaseFirestore.instance
                            .collection('user')
                            .doc(userModal.uId);
                        docUser.delete();
                        Navigator.pop(context);
                      },
                      child: Text("Yes")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"))
                ],
              );
            },
          );


        }, icon: Icon(Icons.delete)),
      );
  Stream<List<UserModal>> readUser() =>
      FirebaseFirestore.instance.collection('user').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => UserModal.fromJson(doc.data()))
                .toList(),
          );

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
}