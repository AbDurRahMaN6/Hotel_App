import 'package:auth_ui/models/hotels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';

import '../../api/auth.dart';
import 'booking.dart';

class UserHotels extends StatefulWidget {
  const UserHotels({super.key});

  @override
  State<UserHotels> createState() => _UserHotelsState();
}

class _UserHotelsState extends State<UserHotels> {
  Hotels? hotel;
  List<dynamic>? hotelList = [];
  List<bool> isFavoriteList = [];
  int? selectedHotelIndex;
  List<Hotels?> favoriteHotels = [];

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  void fetchHotels() async {
    List? hotels = await ApiManager().getHotels();
    setState(() {
      hotelList = hotels!;
      isFavoriteList = List.generate(hotels.length, (_) => false);
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      isFavoriteList[index] = !isFavoriteList[index];
    });

    Hotels hotel = hotelList?[index];
    if (isFavoriteList[index]) {
      favoriteHotels.add(hotel);
    } else {
      favoriteHotels.remove(hotel);
    }
  }

  void bookHotel(int index) {
    Hotels hotel = hotelList?[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPage(hotel: hotel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: hotelList?.length,
            itemBuilder: (context, index) {
              Hotels hotel = hotelList?[index];
              bool isFavorite = isFavoriteList[index];
              bool isSelected = index == selectedHotelIndex;

              return Card(
                  child: ListTile(
                      leading: Image.network(
                        hotel.image ?? '',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      title: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedHotelIndex = null;
                            } else {
                              selectedHotelIndex = index;
                            }
                          });
                        },
                        child: Text(
                          hotel.hotelName ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            color: isSelected ? Colors.grey : Colors.black,
                            fontWeight: isSelected ? FontWeight.w700 : null,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.district ?? '',
                            style: const TextStyle(color: Colors.lightBlue),
                          ),
                          Text(
                            hotel.address ?? '',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                          Text(
                            hotel.phoneNumber ?? '',
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            hotel.desc ?? '',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleFavorite(index);
                            },
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                          ),
                          const Gap(10),
                          ElevatedButton(
                              onPressed: () {
                                bookHotel(index);
                              },
                              child: const Text(
                                'Booking',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              )),
                        ],
                      )));
            }));
  }
}
