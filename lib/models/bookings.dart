import 'dart:convert';

import 'package:auth_ui/models/rooms.dart';

Bookings hotelsFromJson(String str) => Bookings.fromJson(json.decode(str));

String usersToJson(Bookings data) => json.encode(data.toJson());

class Bookings {
  String? startDate;
  String? endDate;

  Bookings({required this.startDate, required this.endDate});

  Bookings.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
