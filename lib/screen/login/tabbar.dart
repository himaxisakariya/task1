import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task1/api_screen/api.dart';
import '../admin/admindata.dart';
import '../readdata/userdata.dart';
import 'login.dart';

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
                    title: const Text('Exit'),
                    content: const Text("Are you sure You want to Exit?"),
                    actions: [
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.purple)),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes')),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.purple)),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('No'))
                    ],
                  ));
          return willLeave;
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return apiscreen();
                  },));
                }, icon: Icon(Icons.add,color: Colors.white,))
              ],
              backgroundColor: Colors.purple,
              centerTitle: true,
              title: Text("Authentication"),
              // title: Text("Authentications",textAlign: TextAlign.center,),
              bottom: TabBar(
                  controller: widget.tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      text: "Login",
                    ),
                    Tab(
                      text: "user's",
                    ),
                    Tab(
                      text: "Admin Profile",
                    )
                  ]),
            ),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: widget.tabController,
                children: [
                  firstpage(widget.tabController, "login"),
                  showdata(widget.tabController,),
                  admin(widget.tabController),]),
          ),
        ));
  }
}
