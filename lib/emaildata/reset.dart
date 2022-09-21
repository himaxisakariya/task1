import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class rpassword extends StatefulWidget {
  const rpassword({Key? key}) : super(key: key);

  @override
  State<rpassword> createState() => _rpasswordState();
}

class _rpasswordState extends State<rpassword> {
  TextEditingController t = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password"),),
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
                      labelText: 'Email',
                      hintText: 'Enter your Email'),
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

