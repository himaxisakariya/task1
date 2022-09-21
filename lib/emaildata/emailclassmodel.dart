// To parse this JSON data, do
//
//     final emailmodel = emailmodelFromJson(jsonString);

import 'dart:convert';

List<Emailmodel> emailmodelFromJson(String str) => List<Emailmodel>.from(json.decode(str).map((x) => Emailmodel.fromJson(x)));

String emailmodelToJson(List<Emailmodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Emailmodel {
  Emailmodel({
    this.uid,
    this.name,
    this.email,
    this.picture,
  });

  String? uid;
  String? name;
  String? email;
  String? picture;

  factory Emailmodel.fromJson(Map<String, dynamic> json) => Emailmodel(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "picture": picture,
  };
}
