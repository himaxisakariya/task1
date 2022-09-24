import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../class/classmodel.dart';
import '../service/auth_service.dart';

class sign_up extends StatefulWidget {
  TabController tabController;

  sign_up(this.tabController);

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TextEditingController t = TextEditingController();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController date = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool s = false;
  String? imageurl;
  final storageRef = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  UserModal? userModel;
  String path = FirebaseAuth.instance.currentUser!.uid;
  String person = "Admin";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Scaffold(
          appBar: AppBar(
            title: Text("sign-up"),
            backgroundColor: Colors.purple,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: new BoxDecoration(color: Colors.white),
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png',
                          fit: BoxFit.fill),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        //give the values according to your requirement
                        child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Image",
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                    content: Text("Upload Image"),
                                    actions: [
                                      IconButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final XFile? image =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);
                                            File file = File(image!.path);
                                            if (image != null) {
                                              var snapshot = await storageRef
                                                  .ref()
                                                  .child('images/${image.name}')
                                                  .putFile(file);
                                              var downloadUrl = await snapshot
                                                  .ref
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
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Color(0xFFCE93D8),
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final XFile? image =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            var file = File(image!.path);
                                            if (image != null) {
                                              var snapshot = await storageRef
                                                  .ref()
                                                  .child('images/${image.name}')
                                                  .putFile(file);
                                              print("ok");
                                              var downloadUrl = await snapshot
                                                  .ref
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
                                          icon: Icon(
                                            Icons
                                                .photo_size_select_actual_outlined,
                                            color: Color(0xFFCE93D8),
                                          ))
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.add_a_photo)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                    controller: t,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'username',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color(0xFFCE93D8),
                      ),
                      labelStyle: TextStyle(color: Colors.black87),
                      hintText: 'Enter Your name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone';
                      }
                      return null;
                    },
                    controller: t1,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'phone',
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Color(0xFFCE93D8),
                      ),
                      hintText: 'Enter Your phone number',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          date.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select your Birthday date';
                      }
                      return null;
                    },
                    controller: date,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.calendar_month_outlined,
                        color: Color(0xFFCE93D8),
                      ),
                      hintText: 'Select your birthday date',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                    controller: t2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Color(0xFFCE93D8),
                      ),
                      labelStyle: TextStyle(color: Colors.black87),
                      hintText: 'Enter Your Email Id',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Passsword must be required';
                      }
                      return null;
                    },
                    controller: t3,
                    obscureText: s,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: s
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Color(0xFFCE93D8),
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Color(0xFFCE93D8),
                                ),
                          onPressed: () {
                            setState(() {
                              s = !s;
                            });
                          },
                          color: Colors.black,
                        ),
                        // border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black87),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Enter your password'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Passsword must be required';
                      }
                      if (value != t3.text) {
                        return 'Password is not match';
                      }
                      return null;
                    },
                    controller: t4,
                    obscureText: s,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: s
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Color(0xFFCE93D8),
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Color(0xFFCE93D8),
                                ),
                          onPressed: () {
                            setState(() {
                              s = !s;
                            });
                          },
                          color: Colors.black,
                        ),
                        // border: OutlineInputBorder(),
                        labelText: 'Confirm password',
                        labelStyle: TextStyle(color: Colors.black87),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Enter your confirm password password'),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 80),
                    Radio(
                      value: "Admin",
                      groupValue: person,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Color(0xFFCE93D8)),
                      onChanged: (value) {
                        setState(() {
                          person = value.toString();
                        });
                      },
                    ),
                    Text("Admin"),
                    Radio(
                      value: "User",
                      groupValue: person,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => Color(0xFFCE93D8)),
                      onChanged: (value) {
                        setState(() {
                          person = value.toString();
                        });
                      },
                    ),
                    Text("User"),
                  ],
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Center(
                          child: CircularProgressIndicator(),
                        )));
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: t.text,
                            password: t1.text,
                          );
                          UserModal userModel = UserModal(
                              email: credential.user!.email,
                              userImage: imageurl,
                              uId: credential.user!.uid,
                              name: credential.user!.displayName,
                              person: person,
                              dob: date.text);
                          createemail(userModel);
                          widget.tabController.animateTo(0);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("login", "Yes");
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                        t.clear();
                        t1.clear();
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.purple)),
                    child: Text("sign-up"))
              ],
            ),
          ),
        ));
  }
}
