import 'dart:convert';

import 'bookings.dart';

Rooms hotelsFromJson(String str) => Rooms.fromJson(json.decode(str));

String usersToJson(Rooms data) => json.encode(data.toJson());

class Rooms {
  String? roomNumber;
  bool? available;
  String? roomImage;
  String? price;
  List<Bookings>? bookings;

  Rooms(
      {required this.roomNumber,
      required this.available,
      required this.roomImage,
      required this.price,
      required this.bookings});

  Rooms.fromJson(Map<String, dynamic> json) {
    roomNumber = json['roomNumber'];
    available = json['available'];
    price = json['price'];
    roomImage = json['roomImage'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Bookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomNumber'] = roomNumber;
    data['available'] = available;
    data['roomImage'] = roomImage;
    data['price'] = price;
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
