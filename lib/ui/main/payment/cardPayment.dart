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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Payment Details',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name on Card',
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Expiry Date',
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                labelText: 'CVV',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// // import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';

// class CardPayment extends StatefulWidget {
//   const CardPayment({Key? key}) : super(key: key);

//   @override
//   State<CardPayment> createState() => _CardPaymentState();
// }

// class _CardPaymentState extends State<CardPayment> {

  /* ---------------------------- First Example Strating Don't used this one---------------------- */
  // Map<String, dynamic>? paymentIntent;

  // Future<void> makePayment() async {
  //   try {
  //     // Step 1: Create Payment Intent
  //     paymentIntent = await createPaymentIntent('100', 'USD');

  //     // Step 2: Set Stripe Publishable Key
  //     StripePayment.setStripeSettings(
  //       StripeSettings(
  //         publishableKey:
  //             'pk_test_51K5a6EAIipcVImU5tlit6IpBLRocq0cBNk1gpM3IGvjvHgFFQN8VV7nwQWKXgZslmEmzy0dctX0SZCt7ZHWTxEnZ009ZaF1Cag',
  //       ),
  //     );

  //     // Step 3: Open Card Form
  //     final paymentMethod = await StripePayment.paymentRequestWithCardForm(
  //       CardFormPaymentRequest(),
  //     );

  //     // Step 4: Confirm Payment Intent
  //     final confirmResult = await confirmPaymentIntent(paymentMethod);
  //     if (confirmResult['error'] != null) {
  //       throw Exception(confirmResult['error']);
  //     }

  //     // Step 5: Payment Successful
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: const [
  //             Icon(
  //               Icons.check_circle,
  //               color: Colors.green,
  //               size: 100.0,
  //             ),
  //             SizedBox(height: 10.0),
  //             Text("Payment Successful!"),
  //           ],
  //         ),
  //       ),
  //     );

  //     paymentIntent = null;
  //   } catch (err) {
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               children: const [
  //                 Icon(
  //                   Icons.cancel,
  //                   color: Colors.red,
  //                 ),
  //                 Text("Payment Failed"),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Future<Map<String, dynamic>> createPaymentIntent(
  //     String amount, String currency) async {
  //   try {
  //     final body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //     };

  //     final response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer ${DotEnv().env['STRIPE_SECRET']}',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: body,
  //     );
  //     return json.decode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }

  // Future<Map<String, dynamic>> confirmPaymentIntent(
  //     PaymentMethod paymentMethod) async {
  //   try {
  //     final confirmResponse = await http.post(
  //       Uri.parse(
  //         'https://api.stripe.com/v1/payment_intents/${paymentIntent!['id']}/confirm',
  //       ),
  //       headers: {
  //         'Authorization': 'Bearer ${DotEnv().env['STRIPE_SECRET']}',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: {'payment_method': paymentMethod.id},
  //     );
  //     return json.decode(confirmResponse.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }

  // String calculateAmount(String amount) {
  //   final calculatedAmount = (int.parse(amount)) * 100;
  //   return calculatedAmount.toString();
  // }
  /* ---------------------------- First Example Ending Don't used this one---------------------- */


  /* ---------------------------- Second Example used this one---------------------- */

  // Map<String, dynamic>? paymentIntent;
  // Future<void> makePayment() async {
  //   try {
  //     //STEP 1: Create Payment Intent
  //     paymentIntent = await createPaymentIntent('100', 'USD');

  //     //STEP 2: Initialize Payment Sheet
  //     await Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: SetupPaymentSheetParameters(
  //                 paymentIntentClientSecret: paymentIntent![
  //                     'client_secret'], //Gotten from payment intent
  //                 style: ThemeMode.light,
  //                 merchantDisplayName: 'Abd'))
  //         .then((value) {});

  //     //STEP 3: Display Payment sheet
  //     displayPaymentSheet();
  //   } catch (err) {
  //     throw Exception(err);
  //   }
  // }

  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     //Request body
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //     };

  //     //Make post request to Stripe
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //       body: body,
  //     );
  //     return json.decode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }

  // calculateAmount(String amount) {
  //   final calculatedAmout = (int.parse(amount)) * 100;
  //   return calculatedAmout.toString();
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: const [
  //                     Icon(
  //                       Icons.check_circle,
  //                       color: Colors.green,
  //                       size: 100.0,
  //                     ),
  //                     SizedBox(height: 10.0),
  //                     Text("Payment Successful!"),
  //                   ],
  //                 ),
  //               ));

  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on StripeException catch (e) {
  //     print('Error is:---> $e');
  //     AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: const [
  //               Icon(
  //                 Icons.cancel,
  //                 color: Colors.red,
  //               ),
  //               Text("Payment Failed"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  /* ---------------------------- Second Example Ending this one---------------------- */

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ElevatedButton(
//         onPressed: () async {
//           await makePayment();
//         },
//         child: const Text('Pay'),
//       ),
//     );
//   }
// }
