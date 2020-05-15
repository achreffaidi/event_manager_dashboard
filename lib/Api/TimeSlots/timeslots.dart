// To parse this JSON data, do
//
//     final timeSlots = timeSlotsFromJson(jsonString);

import 'dart:convert';

TimeSlots timeSlotsFromJson(String str) => TimeSlots.fromJson(json.decode(str));

String timeSlotsToJson(TimeSlots data) => json.encode(data.toJson());

class TimeSlots {
  List<Timeslot> timeslots;

  TimeSlots({
    this.timeslots,
  });

  factory TimeSlots.fromJson(Map<String, dynamic> json) => TimeSlots(
    timeslots: List<Timeslot>.from(json["timeslots"].map((x) => Timeslot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "timeslots": List<dynamic>.from(timeslots.map((x) => x.toJson())),
  };
}

class Timeslot {
  String id;
  String event;
  DateTime startDate;
  DateTime endDate;
  String title;
  String location;
  int v;

  Timeslot({
    this.id,
    this.event,
    this.startDate,
    this.endDate,
    this.title,
    this.location,
    this.v,
  });

  factory Timeslot.fromJson(Map<String, dynamic> json) => Timeslot(
    id: json["_id"],
    event: json["event"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    title: json["title"],
    location: json["location"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "event": event,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "title": title,
    "location": location,
    "__v": v,
  };
}
