// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  String? id;
  String? username;
  String? email;
  List<String?> roles;
  String? accessToken;
  String? tokenType;

  Users({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.accessToken,
    required this.tokenType,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        accessToken: json["accessToken"],
        tokenType: json["tokenType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "accessToken": accessToken,
        "tokenType": tokenType,
      };
}
