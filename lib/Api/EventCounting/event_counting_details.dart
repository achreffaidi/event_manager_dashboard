// To parse this JSON data, do
//
//     final eventCountingDetails = eventCountingDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:testing_app/Api/staff/staff.dart';

EventCountingDetails eventCountingDetailsFromJson(String str) => EventCountingDetails.fromJson(json.decode(str));

String eventCountingDetailsToJson(EventCountingDetails data) => json.encode(data.toJson());

class EventCountingDetails {
  String message;
  List<User> listIn;
  List<User> listOut;

  EventCountingDetails({
    this.message,
    this.listIn,
    this.listOut,
  });

  factory EventCountingDetails.fromJson(Map<String, dynamic> json) => EventCountingDetails(
    message: json["message"],
    listIn: List<User>.from(json["list_in"].map((x) => User.fromJson(x))),
    listOut: List<User>.from(json["list_out"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "list_in": List<dynamic>.from(listIn.map((x) => x.toJson())),
    "list_out": List<dynamic>.from(listOut.map((x) => x.toJson())),
  };
}

