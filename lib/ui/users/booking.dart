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

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
      });
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
            // BottomNavigationBarItem(
            //     icon: Icon(Flue), activeIcon: Icon(), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_online), label: "Booking"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), label: "Bookmark"),
          ]),
    );
  }
}




// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class BookingPage extends StatefulWidget {
//   const BookingPage({super.key});

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   final TextEditingController hotelIdController = TextEditingController();
//   final TextEditingController roomNumberController = TextEditingController();
//   DateTime startDate = DateTime.now();
//   DateTime endDate = DateTime.now().add(Duration(days: 1));

//   Future<void> bookRoom(String? hotelId, String? roomNumber) async {
//     final bookingUrl = Uri.parse(
//         'http://172.18.9.11:8080/api/hotels/$hotelId/rooms/$roomNumber/bookings');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final accessToken = prefs.getString('accessToken');
//     // String hotelId = hotelIdController.text;
//     // String roomNumber = roomNumberController.text;
//     Booking booking = Booking(
//       startDate: startDate,
//       endDate: endDate,
//       // Other necessary properties for the Booking object
//     );

//     try {
//       final response = await http.post(
//         bookingUrl,
//         // Uri.parse(
//         //     'http://172.18.9.11:8080/api/hotels/{hotelId}/rooms/{roomNumber}/bookings'),
//         body: booking.toJson(), // Convert Booking object to JSON
//         headers: {
//           "Authorization": "Bearer $accessToken",
//           "Accept": "*/*",
//           "Content-Type": "application/json",
//           "Accept-Encoding": "gzip, deflate, br",
//           "User-Agent": "PostmanRuntime/7.29.2",
//           "Connection": "keep-alive",
//         },
//       );

//       if (response.statusCode == 200) {
//         // Room booked successfully
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Room booked successfully.'),
//         ));
//       } else if (response.statusCode == 400) {
//         // Room is not available for the specified dates
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Room is not available for the specified dates.'),
//         ));
//       } else {
//         // Handle other error cases
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Error booking room. Please try again.'),
//         ));
//       }
//     } catch (e) {
//       // Handle network or other errors
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: $e'),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Book Room')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextFormField(
//               controller: hotelIdController,
//               decoration: const InputDecoration(labelText: 'Hotel ID'),
//             ),
//             TextFormField(
//               controller: roomNumberController,
//               decoration: const InputDecoration(labelText: 'Room Number'),
//             ),
//             const SizedBox(height: 16),
//             const Text('Start Date:'),
//             ElevatedButton(
//               onPressed: () async {
//                 final selectedDate = await showDatePicker(
//                   context: context,
//                   initialDate: startDate,
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime.now().add(Duration(days: 365)),
//                 );
//                 if (selectedDate != null) {
//                   setState(() {
//                     startDate = selectedDate;
//                   });
//                 }
//               },
//               child: Text('Select Start Date'),
//             ),
//             const SizedBox(height: 16),
//             const Text('End Date:'),
//             ElevatedButton(
//               onPressed: () async {
//                 final selectedDate = await showDatePicker(
//                   context: context,
//                   initialDate: endDate,
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime.now().add(const Duration(days: 365)),
//                 );
//                 if (selectedDate != null) {
//                   setState(() {
//                     endDate = selectedDate;
//                   });
//                 }
//               },
//               child: const Text('Select End Date'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {},
//               // bookRoom(id, roomNumber),
//               child: Text('Book Room'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Booking {
//   final DateTime startDate;
//   final DateTime endDate;
//   // Other necessary properties for the Booking object

//   Booking({
//     required this.startDate,
//     required this.endDate,
//     // Other necessary properties for the Booking object
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'startDate': startDate.toIso8601String(),
//       'endDate': endDate.toIso8601String(),
//       // Map other properties to JSON
//     };
//   }
// }
