import 'dart:convert';

import 'package:auth_ui/models/hotels.dart';
import 'package:auth_ui/ui/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteHotel extends StatefulWidget {
  const DeleteHotel({super.key});

  @override
  State<DeleteHotel> createState() => _DeleteHotelState();
}

Future<Hotels> deleteHotels(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  var deleteUrl = 'http://172.18.9.11:8080/api/hotels/$id';
  var response = await http.delete(
    Uri.parse(deleteUrl),
    headers: {
      "Authorization": "Bearer $accessToken",
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "User-Agent": "PostmanRuntime/7.29.2",
      "Connection": "keep-alive",
    },
  );
  return Hotels.fromJson(jsonDecode(response.body));
}

class _DeleteHotelState extends State<DeleteHotel> {
  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}
