// To parse this JSON data, do
//
//     final userModal = userModalFromJson(jsonString);

import 'dart:convert';

List<UserModal> userModalFromJson(String str) => List<UserModal>.from(json.decode(str).map((x) => UserModal.fromJson(x)));

String userModalToJson(List<UserModal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModal {
  UserModal({
    this.uId,
    this.name,
    this.phone,
    this.userImage,
    this.email,
    this.person,
    this.dob,
  });

  String? uId;
  String? name;
  String? phone;
  String? userImage;
  String? email;
  String? person;
  String? dob;

  factory UserModal.fromJson(Map  json) => UserModal(
    uId: json["uId"],
    name: json["name"],
    phone: json["phone"],
    userImage: json["userImage"],
    email: json["email"],
    person: json["person"],
    dob: json["dob"]
  );

  Map<String, dynamic> toJson() => {
    "uId": uId,
    "name": name,
    "phone": phone,
    "userImage": userImage,
    "email": email,
    "person": person,
    "dob": dob
  };
}



List<Demo> demoFromJson(String str) => List<Demo>.from(json.decode(str).map((x) => Demo.fromJson(x)));

String demoToJson(List<Demo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Demo {
  Demo({
    this.id,
    this.bannerFor,
    this.forId,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isLock,
    this.redirectTo,
    this.type,
    this.redirect,
  });

  String? id;
  String? bannerFor;
  String? forId;
  String? photoUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? isLock;
  String? redirectTo;
  String? type;
  String? redirect;

  factory Demo.fromJson(Map<String, dynamic> json) => Demo(
    id: json["_id"],
    bannerFor: json["bannerFor"],
    forId: json["forId"],
    photoUrl: json["photoUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isLock: json["isLock"],
    redirectTo: json["redirectTo"],
    type: json["type"],
    redirect: json["redirect"] == null ? null : json["redirect"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "bannerFor": bannerFor,
    "forId": forId,
    "photoUrl": photoUrl,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "isLock": isLock,
    "redirectTo": redirectTo,
    "type": type,
    "redirect": redirect == null ? null : redirect,
  };
}

//category
List<Cate> cateFromJson(String str) => List<Cate>.from(json.decode(str).map((x) => Cate.fromJson(x)));

String cateToJson(List<Cate> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cate {
  Cate({
    this.id,
    this.type,
    this.photoUrl,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.count,
  });

  String? id;
  String? type;
  String? photoUrl;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? count;

  factory Cate.fromJson(Map<String, dynamic> json) => Cate(
    id: json["_id"],
    type: json["type"],
    photoUrl: json["photoUrl"],
    name: json["name"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "photoUrl": photoUrl,
    "name": name,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "count": count,
  };
}




