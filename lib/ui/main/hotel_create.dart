import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/hotels.dart';

class MyHotel extends StatefulWidget {
  const MyHotel({super.key});

  @override
  State<MyHotel> createState() => _MyHotelState();
}

class _MyHotelState extends State<MyHotel> {
  final _formKey = GlobalKey<FormState>();
  final _hotelNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _districtController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _descController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _createHotel() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final hotel = Hotels(
        hotelName: _hotelNameController.text,
        image: '',
        address: _addressController.text,
        district: _districtController.text,
        phoneNumber: _phoneNumberController.text,
        desc: _descController.text,
        rooms: []);

    final response = await http.post(
      Uri.parse('http://172.18.9.11:8080/api/hotels'),
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

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final createdHotel = Hotels.fromJson(json.decode(response.body));
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Hotel created successfully'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, createdHotel);
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
            content: Text('Failed to create the hotel'),
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
  void dispose() {
    _hotelNameController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Hotel'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _hotelNameController,
                    decoration: const InputDecoration(labelText: 'Hotel Name'),
                    validator: (String? value) {
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
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Camera'),
                                onTap: () {
                                  _pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo),
                                title: const Text('Gallery'),
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Add Image'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _createHotel();
                      }
                    },
                    child: const Text('Create Hotel'),
                  ),
                ]))));
  }
}
