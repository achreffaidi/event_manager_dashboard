// To parse this JSON data, do
//
//     final staffs = staffsFromJson(jsonString);

import 'dart:convert';

Staffs staffsFromJson(String str) => Staffs.fromJson(json.decode(str));

String staffsToJson(Staffs data) => json.encode(data.toJson());

class Staffs {
  List<Staff> staffs;

  Staffs({
    this.staffs,
  });

  factory Staffs.fromJson(Map<String, dynamic> json) => Staffs(
    staffs: List<Staff>.from(json["staffs"].map((x) => Staff.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "staffs": List<dynamic>.from(staffs.map((x) => x.toJson())),
  };
}

class Staff {
  String id;
  List<int> permissions;
  User user;

  Staff({
    this.id,
    this.permissions,
    this.user,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
    id: json["id"],
    permissions: List<int>.from(json["permissions"].map((x) => x)),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "permissions": List<dynamic>.from(permissions.map((x) => x)),
    "user": user.toJson(),
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
