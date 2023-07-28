import 'dart:convert';

import 'package:auth_ui/models/hotels.dart';
import 'package:auth_ui/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bookings.dart';
import '../models/rooms.dart';

class ApiManager {
  String url1 = 'http://172.18.9.11:8080/api/auth/signin';
  String url2 = 'http://172.18.9.11:8080/api/auth/signup';
  String url3 = 'http://172.18.9.11:8080/api/hotels';

  Future<List<dynamic>?> getSearchHotels({String? hotelName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    var searchUrl = Uri.parse(url3);
    if (hotelName != null) {
      searchUrl =
          Uri.parse('http://172.18.9.11:8080/api/hotels?hotelName=$hotelName');
    }

    var data = await http.get(searchUrl, headers: {
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "User-Agent": "PostmanRuntime/7.29.2",
      "Connection": "keep-alive",
      'Authorization': 'Bearer $accessToken'
    });

    var jsonData = json.decode(data.body);

    List<Hotels> hotelsList = [];
    for (var e in jsonData) {
      List<Rooms>? roomsList;
      if (e['rooms'] != null) {
        roomsList = <Rooms>[];
        for (var room in e['rooms']) {
          List<Bookings>? bookingsList;
          if (room['bookings'] != null) {
            bookingsList = <Bookings>[];
            for (var booking in room['bookings']) {
              Bookings bookingObj = Bookings(
                startDate: booking['startDate'],
                endDate: booking['endDate'],
                username: booking['username'],
                mobileNo: booking['mobileNo'],
                email: booking['email'],
              );
              bookingsList.add(bookingObj);
            }
          }
          Rooms roomObj = Rooms(
            roomNumber: room['roomNumber'],
            available: room['available'],
            roomImage: room['roomImage'],
            price: room['price'],
            bookings: bookingsList,
          );
          roomsList.add(roomObj);
        }
      }
      Hotels hotel = Hotels(
        id: e['id'],
        hotelName: e['hotelName'],
        district: e['district'],
        address: e['address'],
        phoneNumber: e['phoneNumber'],
        desc: e['desc'],
        image: e['image'],
        rooms: roomsList,
      );
      hotelsList.add(hotel);
    }
    return hotelsList;
  }

  Future<List<dynamic>?> getHotels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    var data = await http.get(Uri.parse(url3), headers: {
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "User-Agent": "PostmanRuntime/7.29.2",
      "Connection": "keep-alive",
      'Authorization': 'Bearer $accessToken'
    });

    var jsonData = json.decode(data.body);

    List<Hotels> hotelsList = [];
    for (var e in jsonData) {
      List<Rooms>? roomsList;
      if (e['rooms'] != null) {
        roomsList = <Rooms>[];
        for (var room in e['rooms']) {
          List<Bookings>? bookingsList;
          if (room['bookings'] != null) {
            bookingsList = <Bookings>[];
            for (var booking in room['bookings']) {
              Bookings bookingObj = Bookings(
                startDate: booking['startDate'],
                endDate: booking['endDate'],
                username: booking['username'],
                mobileNo: booking['mobileNo'],
                email: booking['email'],
              );
              bookingsList.add(bookingObj);
            }
          }
          Rooms roomObj = Rooms(
            roomNumber: room['roomNumber'],
            available: room['available'],
            roomImage: room['roomImage'],
            price: room['price'],
            bookings: bookingsList,
          );
          roomsList.add(roomObj);
        }
      }
      Hotels hotel = Hotels(
        id: e['id'],
        hotelName: e['hotelName'],
        district: e['district'],
        address: e['address'],
        phoneNumber: e['phoneNumber'],
        desc: e['desc'],
        image: e['image'],
        rooms: roomsList,
      );
      hotelsList.add(hotel);
    }
    return hotelsList;
  }

  Future<Hotels> createHotel(BuildContext context, Hotels? hotel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final response = await http.post(
      Uri.parse(url3),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "User-Agent": "PostmanRuntime/7.29.2",
        "Connection": "keep-alive",
      },
      body: jsonEncode(hotel),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Hotel saved successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      return Hotels.fromJson(jsonData);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to save hotel:'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      throw Exception('Create hotel');
    }
  }

  Future<void> deleteHotel(String id) async {
    String url4 = 'http:// 172.18.9.11:8080/api/hotels/$id';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final response = await http.delete(Uri.parse(url4), headers: {
      "Authorization": "Bearer $accessToken",
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "User-Agent": "PostmanRuntime/7.29.2",
      "Connection": "keep-alive"
    });

    if (response.statusCode != 204) {
      throw Exception('Failed to delete hotel');
    }
  }

  Future<Hotels> updateHotel(Hotels hotel, String id) async {
    String url4 = 'http:// 172.18.9.11:8080/api/hotels/${hotel.id}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final response = await http.put(
      Uri.parse(url4),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "User-Agent": "PostmanRuntime/7.29.2",
        "Connection": "keep-alive",
      },
      body: jsonEncode(hotel),
    );

    if (response.statusCode == 200) {
      return Hotels.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update hotel');
    }
  }

  Future<Users?> signInUsers(
      BuildContext context, String? username, String? password) async {
    Users? userModel;
    http.Response response;
    final prefs = await SharedPreferences.getInstance();
    String body = json.encode({'username': username, 'password': password});
    try {
      response = await http.post(
        Uri.parse(url1),
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "Accept-Encoding": "gzip, deflate, br",
          "User-Agent": "PostmanRuntime/7.29.2",
          "Connection": "keep-alive",
        },
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        userModel = Users.fromJson(jsonResponse);

        final accessToken = userModel.accessToken;

        await prefs.setString('accessToken', accessToken ?? "");
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unauthorized Access'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unexpected error occurred'),
        ));
      }
      return userModel;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<String?> signUpUsers(
    BuildContext context,
    String? username,
    String? email,
    String? password,
    String? roles,
  ) async {
    http.Response response;
    String? message;
    String body = json.encode({
      "username": username,
      "email": email,
      "password": password,
      "roles": roles
    });

    try {
      response = await http.post(
        Uri.parse(url2),
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "Accept-Encoding": "gzip, deflate, br",
          "User-Agent": "PostmanRuntime/7.29.2",
          "Connection": "keep-alive",
        },
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 200) {
        var jsonSring = response.body;
        var jsonMap = json.decode(jsonSring);
        message = jsonMap;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('message'),
        ));
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Unauthorized Access')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return message;
  }
}
