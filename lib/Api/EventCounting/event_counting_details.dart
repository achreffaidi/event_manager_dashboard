// To parse this JSON data, do
//
//     final eventCountingDetails = eventCountingDetailsFromJson(jsonString);

import 'dart:convert';

EventCountingDetails eventCountingDetailsFromJson(String str) => EventCountingDetails.fromJson(json.decode(str));

String eventCountingDetailsToJson(EventCountingDetails data) => json.encode(data.toJson());

class EventCountingDetails {
  String message;
  List<ListInElement> listIn;
  List<ListInElement> listOut;

  EventCountingDetails({
    this.message,
    this.listIn,
    this.listOut,
  });

  factory EventCountingDetails.fromJson(Map<String, dynamic> json) => EventCountingDetails(
    message: json["message"],
    listIn: List<ListInElement>.from(json["list_in"].map((x) => ListInElement.fromJson(x))),
    listOut: List<ListInElement>.from(json["list_out"].map((x) => ListInElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "list_in": List<dynamic>.from(listIn.map((x) => x.toJson())),
    "list_out": List<dynamic>.from(listOut.map((x) => x.toJson())),
  };
}

class ListInElement {
  String id;
  String name;
  String password;
  String email;
  int v;

  ListInElement({
    this.id,
    this.name,
    this.password,
    this.email,
    this.v,
  });

  factory ListInElement.fromJson(Map<String, dynamic> json) => ListInElement(
    id: json["_id"],
    name: json["name"],
    password: json["password"],
    email: json["email"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "password": password,
    "email": email,
    "__v": v,
  };
}
