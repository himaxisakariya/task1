import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class getuser extends StatelessWidget {
final String documentsid;
getuser({required this.documentsid});
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    return  FutureBuilder<QuerySnapshot>(
      future: users.get(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
        {
          Map<String, dynamic> d = snapshot.data!.docs[0].data() as Map<String,dynamic>;
          return ListTile(
            title: Text('name: ${d['name']}'),
            subtitle: Text('email: ${d['email']}'),

          );
        }
        return Text('loading....');
      },);

  }
}
