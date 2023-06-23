import 'package:auth_ui/ui/main/hotel_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';

import 'main/drawers.dart';
import 'main/hotel_create.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 16) {
      return 'Good Afternoon';
    } else if (hour < 18) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      // ignore: unnecessary_new
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.draw_rounded),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Drawers()));
          },
        ),
      ),
      body: ListView(children: [
        Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreeting(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Gap(5),
                        const Text(
                          'Hotels Details',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://png.pngtree.com/png-vector/20190315/ourmid/pngtree-ar-notary-logo-amazing-design-for-your-company-or-brand-png-image_844288.jpg'))),
                    ),
                  ],
                ),
                const Gap(20),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHotel()));
                    },
                    child: const Text(
                      'Create Hotel',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                const Gap(20),
                const HotelScreen(),
                // const MyHotel()
              ],
            ))
      ]),
    );
  }
}
