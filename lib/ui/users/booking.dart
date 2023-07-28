import 'dart:convert';

import 'package:auth_ui/ui/main/payment/cardPayment.dart';
import 'package:auth_ui/ui/users/user_booking_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/hotels.dart';
import '../../models/rooms.dart';
import 'bookmark.dart';

class BookingPage extends StatefulWidget {
  String hotelId;
  String roomNumber;
  BookingPage({
    required this.hotelId,
    required this.roomNumber,
    super.key,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now().add(const Duration(days: 1));
  int _selectIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    UserBookingDetails(
      hotelId: '',
      roomNumber: '',
    ),
    const CardPayment(),
    const Bookmark(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  Future<void> bookRoom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final String bookingUrl =
        "http://172.18.9.11:8080/api/hotels/${widget.hotelId}/rooms/${widget.roomNumber}/bookings";
    final Map<String, dynamic> bookingData = {
      "startDate": startDate!.toIso8601String(),
      "endDate": endDate!.toIso8601String(),
    };

    final response = await http.post(
      Uri.parse(bookingUrl),
      body: jsonEncode(bookingData),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "User-Agent": "PostmanRuntime/7.29.2",
        "Connection": "keep-alive",
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text("Room booked successfully."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error"),
          content: Text("Room is not available for the specified dates."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Booking")),
      ),
      body: Center(child: _widgetOptions[_selectIndex]),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectIndex,
          onTap: _onItemTapped,
          elevation: 10,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.yellow,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Person",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_online), label: "Booking"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), label: "Bookmark"),
          ]),
    );
  }
}
