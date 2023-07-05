import 'package:auth_ui/ui/users/favorite%20.dart';
import 'package:auth_ui/ui/users/user_check_hotel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

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
      appBar: AppBar(
        title: const Text('Hello Everyone'),
      ),
      backgroundColor: Colors.blueGrey,
      body: ListView(children: [
        Container(
          padding: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  alignment: Alignment.topRight,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: NetworkImage(
                              'https://img.freepik.com/premium-vector/ar-letter-logo-design_579179-1039.jpg'),
                          fit: BoxFit.cover)),
                ),
                const Gap(30),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoritePage()));
                    },
                    child: const Text(
                      'Favourites',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    )),
                const Gap(30),
                Text(
                  getGreeting(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(30),
                const Text(
                  'You can see the All Hotels',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                )
              ],
            )
          ]),
        ),
        const Gap(20),
        const UserHotels(),
      ]),
    );
  }
}
