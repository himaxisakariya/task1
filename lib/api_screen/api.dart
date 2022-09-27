import 'dart:convert';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../audiobookclass/audiobookmodel.dart';
import '../class/classmodel.dart';

class apiscrren extends StatefulWidget {
  const apiscrren({Key? key}) : super(key: key);

  @override
  State<apiscrren> createState() => _apiscrrenState();
}

class _apiscrrenState extends State<apiscrren> {
  List list = [];
  List<Cate> cate = <Cate>[];
  List plist = [];
  bool image = false;
  int p = 0;
  List<IdList> idList = <IdList>[];
  List<IdList> idList2 = <IdList>[];
  String id = "";
  String id2 = "";

  @override
  void initState() {
    super.initState();
    getdata();
    getdata1();
    getCategoryData();
  }

  getdata() async {
    var url = Uri.parse('https://audio-kumbh.herokuapp.com/api/v1/banner');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    setState(() {
      image = true;
    });
    list = jsonDecode(response.body);
  }

  getdata1() async {
    Response response = await http.get(
        Uri.parse(
            'https://audio-kumbh.herokuapp.com/api/v2/category/audiobook'),
        headers: {
          "x-guest-token":
              "U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM="
        });
    if (response.statusCode == 404) {
      print('Please, authorized yourself first');
    } else if (response.statusCode == 400) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      print('Found exception : ${responseMap['error']['sectionfor']}');
    } else if (response.statusCode == 200) {
      if (response.body != null && response.body.isNotEmpty) {
        cate = cateFromJson(response.body);
        print(cate);
      }
    }
  }

  Future<void> getCategoryData() async {
    Response response = await http.post(
      Uri.parse('https://audio-kumbh.herokuapp.com/api/v2/homepage/category'),
      headers: {
        "x-guest-token":
            "U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM="
      },
      body: {"sectionfor": "audiobook"},
    );
    if (response.statusCode == 404) {
      print('Please, authorized yourself first');
    } else if (response.statusCode == 400) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      print('Found exception : ${responseMap['error']['sectionfor']}');
    } else if (response.statusCode == 200) {
      AudioBookModel audioBookModel = audioBookModelFromJson(response.body);
      if (audioBookModel.audioBookData != null &&
          audioBookModel.audioBookData!.homeCategoryList != null &&
          audioBookModel.audioBookData!.homeCategoryList!.isNotEmpty) {
        idList = audioBookModel.audioBookData!.homeCategoryList!.first.idList!;
        idList2 = audioBookModel.audioBookData!.homeCategoryList!.last.idList!;
        id = audioBookModel.audioBookData!.homeCategoryList!.first.id!;
        id2 = audioBookModel.audioBookData!.homeCategoryList!.last.id!;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Books"),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: image
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index, realIndex) {
                        Demo d = Demo.fromJson(list[index]);
                        return Container(
                          margin: EdgeInsets.fromLTRB(00, 10, 00, 00),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: NetworkImage("${d.photoUrl}"),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(10)),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: false,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            p = index;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                      child: CarouselIndicator(
                        count: list.length,
                        index: p,
                        color: Colors.black,
                        activeColor: Colors.grey,
                        cornerRadius: 10,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      height: 30,
                      width: double.infinity,
                      child: Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 150,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cate.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Cate c = cate[index];
                          return Stack(children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 20, bottom: 0),
                              child: Container(
                                height: 150,
                                width: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage("${c.photoUrl}")),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35, top: 35),
                              child: Text("${c.name}",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white)),
                            ), Padding(
                              padding: const EdgeInsets.only(left: 35, top: 45),
                              child: Text("_____",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 35, top: 100),
                              child: Text("${c.count}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 55, top: 100),
                              child: Text("${c.type}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 175, top: 90),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.white,
                                    ))),
                          ]);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      height: 30,
                      width: double.infinity,
                      child: Text(
                        "Audio Books",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      height: 30,
                      width: double.infinity,
                      child: Text(
                        "${id}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, bottom: 10, right: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: idList.length,
                          itemBuilder: (context, index) {
                            IdList idListModel = idList[index];
                            return Column(children: [
                              Container(
                                height: 200,
                                width: 130,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${idListModel.audioBookDpUrl}"),
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              SizedBox(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${idListModel.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 7,
                                    ),
                                  )),
                              SizedBox(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${idListModel.author}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 7,
                                    ),
                                  )),
                            ]);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 10,
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6),
                      height: 30,
                      width: double.infinity,
                      child: Text(
                        "${id2}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, bottom: 10, right: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: idList2.length,
                          itemBuilder: (context, index) {
                            IdList idListModel2 = idList2[index];
                            return Column(children: [
                              Container(
                                height: 200,
                                width: 130,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${idListModel2.audioBookDpUrl}"),
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              SizedBox(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${idListModel2.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 7,
                                    ),
                                  )),
                              SizedBox(
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${idListModel2.author}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 7,
                                    ),
                                  )),
                            ]);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 10,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
