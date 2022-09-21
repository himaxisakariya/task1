import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../mainscreen/firstpage.dart';
import '../readdata/show.dart';

class login extends StatefulWidget {
  TabController tabController;

  login(this.tabController);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  Future<QuerySnapshot> getdata() async {
    return await FirebaseFirestore.instance.collection('user').get();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Are you sure want to Exit?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('No'))
                    ],
                  ));
          return willLeave;
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Authentications"),
              bottom: TabBar(tabs: [
                Tab(
                  text: "Login",
                ),
                Tab(
                  text: "user's",
                ),
              ]),
            ),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: widget.tabController,
                children: [
                  firstpage(widget.tabController, "signin"),
                  showdata(
                    widget.tabController,
                  ),
                ]),
          ),
        ));
  }
}
