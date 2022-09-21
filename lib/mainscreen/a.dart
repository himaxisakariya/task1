import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/login/login.dart';
import '../class/shared.dart';

class screen extends StatefulWidget {
  const screen({Key? key}) : super(key: key);

  @override
  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> with SingleTickerProviderStateMixin{



  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    abc();
    tabController = new TabController(vsync: this, length: 2);
  }

  Future abc() async {
    await Future.delayed(Duration(seconds: 0));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return login(tabController);

    },));
    shared.prefs = await SharedPreferences.getInstance();
    if(shared.prefs!.containsKey("login")){
      tabController.animateTo(1);
    }
    else{
      tabController.animateTo(0);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Icon(Icons.timelapse_outlined)),
    );
  }
}