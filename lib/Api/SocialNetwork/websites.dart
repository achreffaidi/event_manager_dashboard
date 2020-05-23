// To parse this JSON data, do
//
//     final websites = websitesFromJson(jsonString);

import 'dart:convert';

Websites websitesFromJson(String str) => Websites.fromJson(json.decode(str));

String websitesToJson(Websites data) => json.encode(data.toJson());

class Websites {
  String message;
  List<String> data;

  Websites({
    this.message,
    this.data,
  });

  factory Websites.fromJson(Map<String, dynamic> json) => Websites(
    message: json["message"],
    data: List<String>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
