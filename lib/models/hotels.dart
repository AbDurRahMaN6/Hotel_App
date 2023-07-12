import 'dart:convert';

import 'package:auth_ui/models/rooms.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Hotels hotelsFromJson(String str) => Hotels.fromJson(json.decode(str));

String usersToJson(Hotels data) => json.encode(data.toJson());

class Hotels {
  String? id;
  String? hotelName;
  String? district;
  String? address;
  String? phoneNumber;
  String? image;
  String? desc;
  List<Rooms>? rooms;
  LatLng? location;

  Hotels({
    required this.hotelName,
    required this.district,
    required this.address,
    required this.phoneNumber,
    required this.image,
    required this.desc,
    required this.rooms,
    this.location,
    this.id,
  });

  Hotels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['hotelName'];
    district = json['district'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    image = json['image'];
    desc = json['desc'];
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['hotelName'] = hotelName;
    data['district'] = district;
    data['address'] = address;
    data['phoneNumber'] = phoneNumber;
    data['image'] = image;
    data['desc'] = desc;
    if (rooms != null) {
      data['rooms'] = rooms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
