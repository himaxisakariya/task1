import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: screen(),
    debugShowCheckedModeBanner: false,
  ));
}
