// To parse this JSON data, do
//
//     final eventCounting = eventCountingFromJson(jsonString);

import 'dart:convert';

EventCounting eventCountingFromJson(String str) => EventCounting.fromJson(json.decode(str));

String eventCountingToJson(EventCounting data) => json.encode(data.toJson());

class EventCounting {
  String message;
  List<Counting> data;

  EventCounting({
    this.message,
    this.data,
  });

  factory EventCounting.fromJson(Map<String, dynamic> json) => EventCounting(
    message: json["message"],
    data: List<Counting>.from(json["data"].map((x) => Counting.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Counting {
  String id;
  String name;
  bool state;
  int countIn;
  int countOut;

  Counting({
    this.id,
    this.name,
    this.state,
    this.countIn,
    this.countOut,
  });

  factory Counting.fromJson(Map<String, dynamic> json) => Counting(
    id: json["id"],
    name: json["name"],
    state : json["state"],
    countIn: json["count_in"],
    countOut: json["count_out"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "count_in": countIn,
    "count_out": countOut,
  };
}
