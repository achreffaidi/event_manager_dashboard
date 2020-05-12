// To parse this JSON data, do
//
//     final createdEvent = createdEventFromJson(jsonString);

import 'dart:convert';

import 'package:testing_app/Api/Events/ListEvents.dart';

CreatedEvent createdEventFromJson(String str) => CreatedEvent.fromJson(json.decode(str));

String createdEventToJson(CreatedEvent data) => json.encode(data.toJson());

class CreatedEvent {
  String message;
  Event data;

  CreatedEvent({
    this.message,
    this.data,
  });

  factory CreatedEvent.fromJson(Map<String, dynamic> json) => CreatedEvent(
    message: json["message"],
    data: Event.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}


