import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class rpassword extends StatefulWidget {
  const rpassword({Key? key}) : super(key: key);

  @override
  State<rpassword> createState() => _rpasswordState();
}

class _rpasswordState extends State<rpassword> {
  String? email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("reset password")),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'email',
                hintText: 'Enter Your email',
              ),
              onChanged: (value) {
                //print(value);
                setState(() {
                  email = value;
                });
              },
            ),
          ),
          ElevatedButton(onPressed: () {
            auth.sendPasswordResetEmail(email: email!);
            Navigator.pop(context);
          }, child: Text("confirm"))
        ]),
      ),
    );
  }
}


