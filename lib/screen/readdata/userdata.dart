import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/class/shared.dart';
import '../../class/classmodel.dart';


class showdata extends StatefulWidget {
  TabController tabController;
  showdata(this.tabController);

  @override
  State<showdata> createState() => _showdataState();
}

class _showdataState extends State<showdata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFCE93D8),
          onPressed: () async {
            await GoogleSignIn().signOut();
            print("Logut");
            widget.tabController.animateTo(0);
            shared.prefs = await SharedPreferences.getInstance();
            shared.prefs!.clear();
          },
          child: Icon(Icons.logout)),
      body: StreamBuilder<List<UserModal>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Somthing is wrong');
          } else if (snapshot.hasData) {
            return ListView.builder(
            // shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => buildUser(snapshot.data![index]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildUser(UserModal userModal) => ListTile(
        subtitle: userModal.name!=null?Text("${userModal.uId}"):Text("Empty"),
        title: Text(userModal.email!),
        leading: userModal.userImage!=null?CachedNetworkImage(
          imageUrl: "${userModal.userImage}",
          placeholder: (context, url) => CircularProgressIndicator(),
          //errorWidget: (context, url, error) => Icon(Icons.error),
        ):CachedNetworkImage(
          imageUrl: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
          placeholder: (context, url) => CircularProgressIndicator(),
        ),
        trailing: IconButton(onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete",style: TextStyle(color: Colors.purple),),
                content: Text("Are You sure You Want to Delete??"),
                actions: [
                  TextButton(
                      onPressed: () {
                        final docUser = FirebaseFirestore.instance
                            .collection('user')
                            .doc(userModal.uId);
                        docUser.delete();
                        Navigator.pop(context);
                      },
                      child: Text("Yes",style: TextStyle(color: Colors.purple),)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No",style: TextStyle(color: Colors.purple),))
                ],
              );
            },
          );}, icon: Icon(Icons.delete)),
      );
  Stream<List<UserModal>> readUser() =>
      FirebaseFirestore.instance.collection('user').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => UserModal.fromJson(doc.data()))
                .toList(),
          );
}