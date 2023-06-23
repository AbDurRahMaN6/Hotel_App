import 'dart:html';

import 'package:auth_ui/ui/users/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../models/hotels.dart';
import '../main/payment/cardPayment.dart';
import '../main/provider/hotelProvider.dart';

class BookingPage extends StatefulWidget {
  final Hotels hotel;
  const BookingPage({required this.hotel, super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool isAccepted = false;

  void acceptHotel() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CardPayment()));
    });
  }

  void cancelHotel() {
    // Provider.of<HotelProvider>(context, listen: false)
    //     .cancelHotel(widget.hotel);
    // Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const UserDashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Page'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Image.network(
              widget.hotel.image ?? '',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            title: Text(widget.hotel.hotelName ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.hotel.district ?? ''),
                Text('Address: ${widget.hotel.address ?? ''}'),
                Text('Phone: ${widget.hotel.phoneNumber ?? ''}'),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: isAccepted ? null : acceptHotel,
                      child: const Text('Accept'),
                    ),
                    ElevatedButton(
                      onPressed: cancelHotel,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
