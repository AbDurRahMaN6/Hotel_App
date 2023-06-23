import 'dart:convert';

import 'package:auth_ui/models/rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddRooms extends StatefulWidget {
  final String hotelId;

  const AddRooms({Key? key, required this.hotelId}) : super(key: key);

  @override
  State<AddRooms> createState() => _AddRoomsState();
}

class _AddRoomsState extends State<AddRooms> {
  final _roomNumberController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final roomData = Rooms(
        roomNumber: _roomNumberController.text,
        available: true,
        roomImage: '',
        price: _priceController.text,
        bookings: []);

    final response = await http.post(
      Uri.parse('http://172.18.9.11:8080/api/hotels/${widget.hotelId}/rooms'),
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "User-Agent": "PostmanRuntime/7.29.2",
        "Connection": "keep-alive",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(roomData.toJson()),
    );
    print('======$roomData==============');
    print({widget.hotelId});

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final createdRoom = Rooms.fromJson(json.decode(response.body));
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Rooms created successfully'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, createdRoom);
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create the room'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _roomNumberController,
              decoration: const InputDecoration(labelText: 'Room Number'),
            ),
            // TextField(
            //   controller: _roomImageController,
            //   decoration: const InputDecoration(labelText: 'Room Image URL'),
            // ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Room'),
            ),
          ],
        ),
      ),
    );
  }
}
