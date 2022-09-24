import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../class/shared.dart';
import '../login/tabbar.dart';

class screen extends StatefulWidget {
  const screen({Key? key}) : super(key: key);

  @override
  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screen();
    tabController = new TabController(vsync: this, length: 3);
  }

  Future screen() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return login(tabController);
      },
    ));
    shared.prefs = await SharedPreferences.getInstance();
    if (shared.prefs!.containsKey("login")) {
      tabController.animateTo(2);
    } else {
      tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset("images/s1.gif",fit: BoxFit.fill,)
      ),
    );
  }
}
