import 'dart:convert';

import 'package:auth_ui/models/hotels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HotelLocationScreen extends StatefulWidget {
  final String hotelAddress;
  const HotelLocationScreen({required this.hotelAddress, super.key});

  @override
  State<HotelLocationScreen> createState() => _HotelLocationScreenState();
}

class _HotelLocationScreenState extends State<HotelLocationScreen> {
  LatLng? hotelLocation;

  @override
  void initState() {
    super.initState();
    fetchHotelLocation();
  }

  void fetchHotelLocation() async {
    LatLng? location = await _getHotelLocation(widget.hotelAddress);
    setState(() {
      hotelLocation = location;
    });
  }

  Future<LatLng?> _getHotelLocation(String address) async {
    String apiKey = 'AIzaSyCz1dgK7O6iTYOIoP4dPmwezmKRmQsFHEA';
    String encodedAddress = Uri.encodeComponent(address);
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?address=$encodedAddress&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'];
        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          double latitude = location['-33.8670'];
          double longitude = location['151.1957'];
          return LatLng(latitude, longitude);
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Location'),
      ),
      body: Center(
        child: hotelLocation != null
            ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: hotelLocation!,
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('hotelMarker'),
                    position: hotelLocation!,
                    infoWindow: InfoWindow(
                      title: 'Hotel Location',
                      snippet: widget.hotelAddress,
                    ),
                  ),
                },
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
