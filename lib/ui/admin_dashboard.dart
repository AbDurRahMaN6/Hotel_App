import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AdminDashboard extends StatelessWidget {
  static const routeName = '/admin_dashboard';
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('This is Admin page'),
    );
  }
}
