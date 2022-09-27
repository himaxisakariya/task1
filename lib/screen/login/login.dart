import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/class/shared.dart';
import '../../class/classmodel.dart';
import '../../service/auth_service.dart';

class firstpage extends StatefulWidget {
  TabController tabController;
  String? method;

  firstpage(this.tabController, this.method);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  TextEditingController temail = TextEditingController();
  TextEditingController tpass = TextEditingController();
  TextEditingController t = TextEditingController();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();

  final storageRef = FirebaseStorage.instance;
  String? imageurl;
  String a = "User";
  final ImagePicker _picker = ImagePicker();
  bool password = false;
  bool cpassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    t5.text = "";
  }

  final formkey = GlobalKey<FormState>();
  bool s = true;
  bool pos = false;
  String person = "User";
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return pos
        ? Form(
            key: _formkey,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Image",
                                style: TextStyle(color: Colors.purple),
                              ),
                              content: Text("Select Image"),
                              actions: [
                                IconButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      final XFile? image =
                                          await _picker.pickImage(
                                              source: ImageSource.camera);
                                      File file = File(image!.path);
                                      if (image!= null) {
                                        var snapshot = await storageRef
                                            .ref()
                                            .child('images/${image.name}')
                                            .putFile(file);
                                        var downloadUrl =
                                            await snapshot.ref.getDownloadURL();
                                        setState(() {
                                          imageurl = downloadUrl;
                                        });
                                        if (downloadUrl == null) {
                                          CircularProgressIndicator();
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Color(0xFFbc589e),
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      final XFile? image =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      var file = File(image!.path);
                                      if (image != null) {
                                        var snapshot = await storageRef
                                            .ref()
                                            .child('images/${image.name}')
                                            .putFile(file);
                                        var downloadUrl =
                                            await snapshot.ref.getDownloadURL();
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
                                      Icons.photo_size_select_actual_outlined,
                                      color: Color(0xFFbc589e),
                                    ))
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png'),
                              fit: BoxFit.fill),
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
                        controller: t,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFFbc589e),
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
                        controller: t2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'phone',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color(0xFFbc589e),
                          ),
                          hintText: 'Enter Your phone number',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 10,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        onTap: () async {
                          DateTime? pickdate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));
                          if (pickdate != null) {
                            String format =
                                DateFormat('yyyy-mm-dd').format(pickdate);
                            setState(() {
                              t5.text = format;
                            });
                          } else {
                            print("date not selected");
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter date';
                          }
                          return null;
                        },
                        controller: t5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date-of-birth',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: Color(0xFFbc589e),
                          ),
                          hintText: 'Enter Your Date of birth',
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
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        controller: t1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Color(0xFFbc589e),
                          ),
                          hintText: 'Enter Your email',
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
                        obscureText: password,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: password
                                  ? Icon(
                                      Icons.visibility,
                                      color: Color(0xFFbc589e),
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: Color(0xFFbc589e),
                                    ),
                              onPressed: () {
                                setState(() {
                                  password = !password;
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
                            return 'password does not match';
                          }
                          return null;
                        },
                        controller: t4,
                        obscureText: cpassword,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: cpassword
                                  ? Icon(
                                      Icons.visibility,
                                      color: Color(0xFFbc589e),
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: Color(0xFFbc589e),
                                    ),
                              onPressed: () {
                                setState(() {
                                  cpassword = !cpassword;
                                });
                              },
                              color: Colors.black,
                            ),
                            // border: OutlineInputBorder(),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black87),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Confirm password'),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 80),
                        Radio(
                          value: "Admin",
                          groupValue: a,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Color(0xFFbc589e)),
                          onChanged: (value) {
                            setState(() {
                              a = value.toString();
                            });
                          },
                        ),
                        Text("Admin"),
                        Radio(
                          value: "User",
                          groupValue: a,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Color(0xFFbc589e)),
                          onChanged: (value) {
                            setState(() {
                              a = value.toString();
                            });
                          },
                        ),
                        Text("User"),
                      ],
                    ),
                    Container(
                      height: 45,
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Center(
                                child: CircularProgressIndicator(),
                              )));
                            }
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: t1.text,
                                password: t3.text,
                              );
                              print(credential);

                              UserModal userModel = UserModal(
                                dob: t5.text,
                                person: a,
                                name: t.text,
                                phone: t2.text,
                                email: credential.user!.email,
                                userImage: imageurl,
                                uId: credential.user!.uid,
                              );
                              createemail(userModel);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return firstpage(
                                      widget.tabController, "login");
                                },
                              ));
                              setState(() {
                                pos = !pos;
                              });
                              widget.tabController.animateTo(0);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString("login", "Yes");
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                                Fluttertoast.showToast(
                                    msg: "Password is too weak",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (e.code == 'email-already-in-use') {
                                print('The account already exists for that email.');
                                Fluttertoast.showToast(
                                    msg: "email already exist",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } catch (e) {
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFbc589e))),
                          child: Text("Login")),
                    ),
                    SignInButton(
                      Buttons.Google,
                      text: "Sign up with Google",
                      onPressed: () async {
                        UserCredential? login = await signInWithGoogle();
                        if (login.user != null) {
                          UserModal userModal = UserModal(
                            person: person,
                            email: login.user!.email,
                            name: login.user!.displayName,
                            phone: login.user!.phoneNumber,
                            uId: login.user!.uid,
                            userImage: login.user!.photoURL,
                          );
                          createUser(userModal);
                          widget.tabController.animateTo(2);
                          shared.prefs = await SharedPreferences.getInstance();
                          await shared.prefs!.setString("login", "yes");
                        }
                      },
                    ),
                    Container(
                      child: ElevatedButton(
                          onPressed: () {
                            widget.tabController.animateTo(0);
                            setState(() {
                              pos = !pos;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFbc589e))),
                          child: Text("Go back to login page")),
                    )
                  ],
                ),
              ),
            ))
        : Form(
            key: formkey,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(10, 40, 10, 20),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            color: Colors.grey, wordSpacing: 0.5, fontSize: 30),
                      ),
                    ),
                    // email
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                      child: TextFormField(
                        controller: temail,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '*Email is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black87),
                          hintText: 'Enter Your email',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //password
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: tpass,
                        obscureText: s,
                        textInputAction: TextInputAction.done,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password must not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.purple,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: s
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Color(0xFFbc589e),
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: Color(0xFFbc589e),
                                    ),
                              onPressed: () {
                                setState(() {
                                  s = !s;
                                });
                              },
                              color: Colors.black,
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black87),
                            hintText: 'Enter your password'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: SizedBox(
                        height: 45,
                        width: 200,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFbc589e))),
                          onPressed: () async {
                            bool validation = RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(t.text);
                            if (formkey.currentState!.validate()) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Center(
                                child: CircularProgressIndicator(),
                              )));
                            }

                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: temail.text, password: tpass.text);
                              print(credential);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                                Fluttertoast.showToast(
                                    msg: "user not found",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                                Fluttertoast.showToast(
                                    msg: "Wrong password",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            }
                            t.clear();
                            t1.clear();
                            widget.tabController.animateTo(2);
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Text(
                            '${widget.method}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("Don't have an account?"),
                        ),
                        Container(
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    pos = !pos;
                                  });
                                },
                                child: Text("Sign up")))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
