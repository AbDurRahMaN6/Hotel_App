import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardPayment extends StatefulWidget {
  const CardPayment({super.key});

  @override
  State<CardPayment> createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  Future<void> processPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    // final url = Uri.parse('http://172.18.9.11:8080/api/payments');
    final response = await http.post(
      Uri.parse('http://172.18.9.11:8080/api/payments'),
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "User-Agent": "PostmanRuntime/7.29.2",
        "Connection": "keep-alive",
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode({
        'cardNumber': cardNumberController.text,
        'cardHolderName': cardHolderNameController.text,
        'expiryDate': expiryDateController.text,
        'cvv': cvvController.text,
      }),
    );
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Payment Method'),
              content: Text('Payment payed successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
      print('Payment processed successfully');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to payed hotel:'),
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
      print('Payment processing failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                TextField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                ),
                TextField(
                  controller: cardHolderNameController,
                  decoration:
                      const InputDecoration(labelText: 'Card Holder Name'),
                ),
                TextField(
                  controller: expiryDateController,
                  decoration: const InputDecoration(labelText: 'Expiry Date'),
                ),
                TextField(
                  controller: cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                ),
                ElevatedButton(
                  onPressed: processPayment,
                  child: const Text('Process Payment'),
                ),
              ]))),
    );
  }
}
