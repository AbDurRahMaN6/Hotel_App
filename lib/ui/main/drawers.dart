import 'package:auth_ui/ui/login.dart';
import 'package:auth_ui/ui/main/hotel_details.dart';
import 'package:auth_ui/ui/register.dart';
import 'package:flutter/material.dart';

import 'create_user.dart';

class Drawers extends StatefulWidget {
  const Drawers({super.key});

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  final minimumPadding = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Management'),
      ),
      body: Center(child: Text('Hi')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Create Employee'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateUser()));
              },
            ),
            ListTile(
              title: Text('All Employees List'),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => HotelScreen()));
              },
            )
          ],
        ),
      ),
    );
  }
}
