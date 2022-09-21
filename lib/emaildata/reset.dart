import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class rpassword extends StatefulWidget {
  const rpassword({Key? key}) : super(key: key);

  @override
  State<rpassword> createState() => _rpasswordState();
}

class _rpasswordState extends State<rpassword> {
  TextEditingController t = TextEditingController();TextEditingController t1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: t,
              //obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'New Password',
                  hintText: 'Enter your new password'),
            ),
          ),
          Padding(padding: EdgeInsets.all(10),
            child: TextField(
              controller: t1,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'confirm password',
                  hintText: 'Enter your confirm password'),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: t.text)
                    .then((value) => Navigator.pop(context));
              },
              child: Text("Reset Your Password"))
        ],
      )),
    );
  }
}
