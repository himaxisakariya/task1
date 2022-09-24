import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/class/shared.dart';
import '../../class/classmodel.dart';

class admin extends StatefulWidget {
  TabController tabController;

  admin(this.tabController);

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
  bool pos = false;
  UserModal? userModel;
  String path = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController t = TextEditingController();
  TextEditingController t1 = TextEditingController();
  String? imageurl;
  final storageRef = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
            floatingActionButton: pos
                ? null
                : Container(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          backgroundColor: Color(0xFFbc589e),
                          onPressed: () {
                            setState(() {
                              pos = true;
                            });
                          },
                          child: Icon(
                            Icons.edit,
                          ),
                          heroTag: 'btn1',
                        ),
                        SizedBox(height: 20),
                        FloatingActionButton(
                          backgroundColor: Color(0xFFbc589e),
                          onPressed: () async {
                            await GoogleSignIn().signOut();
                            widget.tabController.animateTo(0);
                            shared.prefs =
                                await SharedPreferences.getInstance();
                            shared.prefs!.clear();
                          },
                          child: Icon(Icons.logout),
                          heroTag: 'btn2',
                        ),
                      ],
                    ),
                  ),
            body: pos
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .doc(path)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        final user = snapshot.data!;
                        UserModal userModel = UserModal.fromJson(
                            user.data() as Map<String, dynamic>);
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Image"),
                                          content: Text("Select Image"),
                                          actions: [
                                            IconButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final XFile? image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera);
                                                  File file = File(image!.path);
                                                  if (image != null) {
                                                    var snapshot = await storageRef
                                                        .ref()
                                                        .child(
                                                            'images/${image.name}')
                                                        .putFile(file);
                                                    var downloadUrl =
                                                        await snapshot.ref
                                                            .getDownloadURL();
                                                    setState(() {
                                                      imageurl = downloadUrl;
                                                    });
                                                    print(imageurl);
                                                    if (downloadUrl == null) {
                                                      CircularProgressIndicator();
                                                    }
                                                  }
                                                },
                                                icon: Icon(Icons.camera_alt)),
                                            IconButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final XFile? image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  var file = File(image!.path);
                                                  if (image != null) {
                                                    var snapshot = await storageRef
                                                        .ref()
                                                        .child(
                                                            'images/${image.name}')
                                                        .putFile(file);
                                                    var downloadUrl =
                                                        await snapshot.ref
                                                            .getDownloadURL();
                                                    setState(() {
                                                      imageurl = downloadUrl;
                                                    });
                                                    print(imageurl);
                                                    if (downloadUrl == null) {
                                                      CircularProgressIndicator();
                                                    }
                                                  }
                                                },
                                                icon: Icon(Icons
                                                    .photo_size_select_actual_outlined))
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      margin: EdgeInsets.all(5),
                                      child: userModel.userImage != null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  "${userModel.userImage}",
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )
                                          : Image.asset("images/blank.jpeg")),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: TextFormField(
                                  //controller: t,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Color(0xFFbc589e)),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  enabled: false,
                                  initialValue: userModel.email,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: t,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: Color(0xFFbc589e)),
                                      ),
                                      border: OutlineInputBorder(),
                                      hintText: "Name",
                                      labelText: "Name"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: TextFormField(
                                  controller: t1,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Color(0xFFbc589e)),
                                    ),
                                    border: OutlineInputBorder(),
                                    hintText: "Phone Number",
                                    labelText: "phone number",
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  maxLength: 10,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(path)
                                        .update({
                                      'name': t.text,
                                      'phone': t1.text,
                                      'userImage': imageurl
                                    });
                                    widget.tabController.animateTo(2);
                                    setState(() {
                                      pos = false;
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color(0xFFbc589e))),
                                  child: imageurl != null
                                      ? Text("update")
                                      : Text("update"))
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .doc(path)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text(''));
                      } else if (snapshot.hasData) {
                        final user = snapshot.data!;
                        UserModal userModel = UserModal.fromJson(
                            user.data() as Map<String, dynamic>);
                        return ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
                              height: 60,
                              width: 60,
                              child: (userModel.userImage != null)
                                  ? CachedNetworkImage(
                                      imageUrl: "${userModel.userImage},",
                                      placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ))
                                  : Icon(Icons.error_outline_outlined,
                                      size: 50),
                            ),
                            ListTile(
                              title: Center(
                                  child: Text(
                                "${userModel.email}",
                              )),
                              subtitle: Center(
                                child: Text("${userModel.name}"),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 100,
                              child: (userModel.person == "Admin")
                                  ? Align(
                                      heightFactor: 50,
                                      widthFactor: 50,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color(0xFFbc589e))),
                                          onPressed: () {
                                            if (userModel.person == "Admin") {
                                              widget.tabController.animateTo(1);
                                            }
                                          },
                                          child: Text("User Detail")),
                                    )
                                  : Center(child: Text("You Are User")),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )));
  }
}
