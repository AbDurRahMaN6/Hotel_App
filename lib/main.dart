import 'package:auth_ui/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
// Stripe.publishableKey =
//     "pk_test_51K5a6EAIipcVImU5tlit6IpBLRocq0cBNk1gpM3IGvjvHgFFQN8VV7nwQWKXgZslmEmzy0dctX0SZCt7ZHWTxEnZ009ZaF1Cag";

//     await dotenv.load(fileName: "assets/.env");

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();


//   Stripe.publishableKey =
//       "pk_test_51K5a6EAIipcVImU5tlit6IpBLRocq0cBNk1gpM3IGvjvHgFFQN8VV7nwQWKXgZslmEmzy0dctX0SZCt7ZHWTxEnZ009ZaF1Cag";

//   await dotenv.load(fileName: "assets/.env");

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       //initial route
//       home: Login(),
//     );
//   }
// }
