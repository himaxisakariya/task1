import 'package:flutter/material.dart';
import 'package:task1/login/login.dart';
import 'package:firebase_core/firebase_core.dart';

import 'a.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: screen(),

    debugShowCheckedModeBanner: false,
  ));
}
