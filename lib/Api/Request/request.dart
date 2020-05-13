// To parse this JSON data, do
//
//     final requests = requestsFromJson(jsonString);

import 'dart:convert';

Requests requestsFromJson(String str) => Requests.fromJson(json.decode(str));

String requestsToJson(Requests data) => json.encode(data.toJson());

class Requests {
  List<RequestElement> requests;

  Requests({
    this.requests,
  });

  factory Requests.fromJson(Map<String, dynamic> json) => Requests(
    requests: List<RequestElement>.from(json["requests"].map((x) => RequestElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "requests": List<dynamic>.from(requests.map((x) => x.toJson())),
  };
}

class RequestElement {
  RequestRequest request;
  User user;
  Plan plan;

  RequestElement({
    this.request,
    this.user,
    this.plan,
  });

  factory RequestElement.fromJson(Map<String, dynamic> json) => RequestElement(
    request: RequestRequest.fromJson(json["request"]),
    user: User.fromJson(json["user"]),
    plan: Plan.fromJson(json["plan"]),
  );

  Map<String, dynamic> toJson() => {
    "request": request.toJson(),
    "user": user.toJson(),
    "plan": plan.toJson(),
  };
}

class Plan {
  String description;
  List<String> options;
  int cost;
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

class RequestRequest {
  int state;
  String id;
  String user;
  String event;
  String plan;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  RequestRequest({
    this.state,
    this.id,
    this.user,
    this.event,
    this.plan,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RequestRequest.fromJson(Map<String, dynamic> json) => RequestRequest(
    state: json["state"],
    id: json["_id"],
    user: json["user"],
    event: json["event"],
    plan: json["plan"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "state": state,
    "_id": id,
    "user": user,
    "event": event,
    "plan": plan,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class User {
  String id;
  String name;
  String password;
  String email;
  int v;

  User({
    this.id,
    this.name,
    this.password,
    this.email,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
