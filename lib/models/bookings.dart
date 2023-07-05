import 'dart:convert';

import 'package:auth_ui/models/rooms.dart';

Bookings hotelsFromJson(String str) => Bookings.fromJson(json.decode(str));

String usersToJson(Bookings data) => json.encode(data.toJson());

class Bookings {
  String? startDate;
  String? endDate;
  String? username;
  String? mobileNo;
  String? email;

  Bookings(
      {required this.startDate,
      required this.endDate,
      required this.username,
      required this.mobileNo,
      required this.email});

  Bookings.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    username = json['username'];
    mobileNo = json['mobileNo'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['username'] = username;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    return data;
  }
}
