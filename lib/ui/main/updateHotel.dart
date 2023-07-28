import 'dart:convert';

import 'package:auth_ui/models/hotels.dart';
import 'package:auth_ui/ui/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateHotels extends StatefulWidget {
  final Hotels? hotel;
  const UpdateHotels({required this.hotel, super.key});

  @override
  State<UpdateHotels> createState() => _UpdateHotelsState();
}

class _UpdateHotelsState extends State<UpdateHotels> {
  final _formKey = GlobalKey<FormState>();

  var _hotelNameController = TextEditingController();
  var _addressController = TextEditingController();
  var _districtController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var _descController = TextEditingController();

  Future<void> _updateHotels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final hotel = Hotels(
        id: widget.hotel?.id,
        hotelName: _hotelNameController.text,
        image: widget.hotel?.image,
        address: _addressController.text,
        district: _districtController.text,
        phoneNumber: _phoneNumberController.text,
        desc: _descController.text,
        rooms: []);

    final response = await http.put(
      Uri.parse(
        'http://172.18.9.11:8080/api/hotels/${widget.hotel?.id}',
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "User-Agent": "PostmanRuntime/7.29.2",
        "Connection": "keep-alive",
      },
      body: json.encode(hotel.toJson()),
    );

    if (response.statusCode == 200) {
      final updatedHotel = Hotels.fromJson(json.decode(response.body));
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Hotel updated successfully'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, updatedHotel);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
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
            content: Text('Failed to update the hotel'),
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
  void initState() {
    super.initState();
    _hotelNameController = TextEditingController(text: widget.hotel?.hotelName);
    _addressController = TextEditingController(text: widget.hotel?.address);
    _districtController = TextEditingController(text: widget.hotel?.district);
    _descController = TextEditingController(text: widget.hotel?.desc);
    _phoneNumberController =
        TextEditingController(text: widget.hotel?.phoneNumber);
  }

  @override
  void dispose() {
    _hotelNameController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _phoneNumberController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Hotel'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _hotelNameController,
                    decoration: const InputDecoration(labelText: 'Hotel Name'),
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return 'Please enter the hotel name';
                      } else if ((value ?? "").length <= 2) {
                        return "Hotel Name must be include 2 more letters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return 'Please enter the address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _districtController,
                    decoration: const InputDecoration(labelText: 'District'),
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return 'Please enter the district';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return 'Please enter the phone number';
                      } else if ((value ?? "").length != 10) {
                        return "Phone Number must be include 10 digits";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if ((value ?? "").isEmpty) {
                        return 'Please enter the description';
                      } else if ((value ?? "").length <= 20) {
                        return "Description must be want to grater than 20 letters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateHotels();
                      }
                    },
                    child: const Text('Update Hotel'),
                  ),
                ]))));
  }
}
