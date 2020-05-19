// To parse this JSON data, do
//
//     final tagsList = tagsListFromJson(jsonString);

import 'dart:convert';

TagsList tagsListFromJson(String str) => TagsList.fromJson(json.decode(str));

String tagsListToJson(TagsList data) => json.encode(data.toJson());

class TagsList {
  String message;
  List<TagItem> data;

  TagsList({
    this.message,
    this.data,
  });

  factory TagsList.fromJson(Map<String, dynamic> json) => TagsList(
    message: json["message"],
    data: List<TagItem>.from(json["data"].map((x) => TagItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TagItem {
  int count;
  String id;
  String name;
  int v;

  TagItem({
    this.count,
    this.id,
    this.name,
    this.v,
  });

  factory TagItem.fromJson(Map<String, dynamic> json) => TagItem(
    count: json["count"],
    id: json["_id"],
    name: json["name"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "_id": id,
    "name": name,
    "__v": v,
  };
}
