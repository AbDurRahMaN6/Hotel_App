import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ManagerDashboard extends StatelessWidget {
  static const routeName = '/manager_dashboard';
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('This is Manager page'),
    );
  }
}
