// To parse this JSON data, do
//
//     final plans = plansFromJson(jsonString);

import 'dart:convert';

Plans plansFromJson(String str) => Plans.fromJson(json.decode(str));

String plansToJson(Plans data) => json.encode(data.toJson());

class Plans {
  List<Plan> plans;

  Plans({
    this.plans,
  });

  factory Plans.fromJson(Map<String, dynamic> json) => Plans(
    plans: List<Plan>.from(json["plans"].map((x) => Plan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "plans": List<dynamic>.from(plans.map((x) => x.toJson())),
  };
}

class Plan {
  String description;
  List<String> options;
  double cost;
  int color;
  String id;
  String name;
  String event;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Plan({
    this.description,
    this.options,
    this.cost,
    this.color,
    this.id,
    this.name,
    this.event,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    description: json["description"],
    options: List<String>.from(json["options"].map((x) => x)),
    cost: json["cost"],
    color: json["color"],
    id: json["_id"],
    name: json["name"],
    event: json["event"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "options": List<dynamic>.from(options.map((x) => x)),
    "cost": cost,
    "color": color,
    "_id": id,
    "name": name,
    "event": event,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
