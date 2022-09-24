import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../class/classmodel.dart';

class apiscreen extends StatefulWidget {
  const apiscreen({Key? key}) : super(key: key);

  @override
  State<apiscreen> createState() => _apiscreenState();
}

class _apiscreenState extends State<apiscreen> {
  List<Demo> list = [];
   getdata() async {
    Uri url = Uri.parse('https://audio-kumbh.herokuapp.com/api/v1/banner');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    List l = jsonDecode(response.body);
    l.forEach((element) {
      print(element);
      setState(() {
        list.add(element);
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: list.length>0?ListView.builder(itemBuilder: (context, index) {
        Demo d = list[index];
        return ListTile(
          title: Image.network("${d.photoUrl}"),
          subtitle: Text("${d.bannerFor}"),
        );
      },):CircularProgressIndicator(),
    );
  }
}
