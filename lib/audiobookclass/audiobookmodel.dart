// To parse this JSON data, do
//
//     final audioBookModel = audioBookModelFromJson(jsonString);

import 'dart:convert';

AudioBookModel audioBookModelFromJson(String str) => AudioBookModel.fromJson(json.decode(str));

String audioBookModelToJson(AudioBookModel data) => json.encode(data.toJson());

class AudioBookModel {
  AudioBookModel({
    this.audioBookData,
  });

  AudioBookData? audioBookData;

  factory AudioBookModel.fromJson(Map<String, dynamic> json) => AudioBookModel(
    audioBookData: AudioBookData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": audioBookData!.toJson(),
  };
}

class AudioBookData {
  AudioBookData({
    this.homeCategoryList,
  });

  List<HomeCategoryList>? homeCategoryList;

  factory AudioBookData.fromJson(Map<String, dynamic> json) => AudioBookData(
    homeCategoryList: List<HomeCategoryList>.from(json["home_category_list"].map((x) => HomeCategoryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "home_category_list": List<dynamic>.from(homeCategoryList!.map((x) => x.toJson())),
  };
}

class HomeCategoryList {
  HomeCategoryList({
    this.id,
    this.idList,
  });

  String? id;
  List<IdList>? idList;

  factory HomeCategoryList.fromJson(Map<String, dynamic> json) => HomeCategoryList(
    id: json["_id"],
    idList: List<IdList>.from(json["idList"].map((x) => IdList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "idList": List<dynamic>.from(idList!.map((x) => x.toJson())),
  };
}

class IdList {
  IdList({
    this.id,
    this.audioBookDpUrl,
    this.name,
    this.tags,
    this.category,
    this.author,
    this.publisher,
    this.description,
    this.reader,
    this.files,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isLock,
    this.isNewAudiobook,
    this.authorDpUrl,
    this.language,
    this.publisherDpUrl,
  });

  String? id;
  String? audioBookDpUrl;
  String? name;
  String? tags;
  Category? category;
  String? author;
  String? publisher;
  String? description;
  String? reader;
  List<FileElement>? files;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? isLock;
  bool? isNewAudiobook;
  String? authorDpUrl;
  String? language;
  String? publisherDpUrl;

  factory IdList.fromJson(Map<String, dynamic> json) => IdList(
    id: json["_id"],
    audioBookDpUrl: json["audioBookDpUrl"],
    name: json["name"],
    tags: json["tags"],
    category: Category.fromJson(json["category"]),
    author: json["author"],
    publisher: json["publisher"],
    description: json["description"],
    reader: json["reader"],
    files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isLock: json["isLock"],
    isNewAudiobook: json["isNewAudiobook"],
    authorDpUrl: json["authorDpUrl"],
    language: json["language"] == null ? null : json["language"],
    publisherDpUrl: json["publisherDpUrl"] == null ? null : json["publisherDpUrl"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "audioBookDpUrl": audioBookDpUrl,
    "name": name,
    "tags": tags,
    "category": category!.toJson(),
    "author": author,
    "publisher": publisher,
    "description": description,
    "reader": reader,
    "files": List<dynamic>.from(files!.map((x) => x.toJson())),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "isLock": isLock,
    "isNewAudiobook": isNewAudiobook,
    "authorDpUrl": authorDpUrl,
    "language": language == null ? null : language,
    "publisherDpUrl": publisherDpUrl == null ? null : publisherDpUrl,
  };
}

class Category {
  Category({
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

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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

class FileElement {
  FileElement({
    this.fileType,
    this.id,
    this.title,
    this.playCount,
    this.seconds,
    this.fileUrl,
  });

  String? fileType;
  String? id;
  String? title;
  int? playCount;
  int? seconds;
  String? fileUrl;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    fileType: json["fileType"],
    id: json["_id"],
    title: json["title"],
    playCount: json["playCount"],
    seconds: json["seconds"],
    fileUrl: json["fileUrl"],
  );

  Map<String, dynamic> toJson() => {
    "fileType": fileType,
    "_id": id,
    "title": title,
    "playCount": playCount,
    "seconds": seconds,
    "fileUrl": fileUrl,
  };
}
