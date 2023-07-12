import 'dart:convert';

import 'package:auth_ui/models/hotels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../api/auth.dart';
import 'booking.dart';
import 'hotelLocationScreen.dart';

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
  Position? _currentPosition;

  // GoogleMapController? mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  void initState() {
    super.initState();
    fetchHotels();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  void fetchHotels() async {
    List? hotels = await ApiManager().getHotels();
    // List<Hotels?> updatedHotelList = [];
    // for (var hotel in hotels!) {
    // LatLng location = await getHotelLocation(hotel.address);
    // updatedHotelList.add(Hotels(
    //   hotelName: '',
    //   address: '',
    //   desc: '',
    //   district: '',
    //   image: '',
    //   phoneNumber: '',
    //   rooms: [],
    //   location: location,
    // ));
    // }
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

  // void bookHotel(int index) {
  //   Hotels hotel = hotelList?[index];
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => BookingPage(
  //           // hotel: hotel
  //           ),
  //     ),
  //   );
  // }

  Future<LatLng> getHotelLocation(String address) async {
    String apiKey = 'AIzaSyDs4GlnwUm0ysqTORiCN93KQcHIRH2qUaA';
    String encodedAddress = Uri.encodeComponent(address);
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'];
        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          double latitude = location['lat'];
          double longitude = location['lng'];
          return LatLng(latitude, longitude);
        }
      }
    }

    return const LatLng(0, 0); // Default location if unable to retrieve
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<dynamic>?>(
            future: ApiManager().getHotels(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: const Center(
                    child: Icon(Icons.error),
                  ),
                );
              }
              hotelList = snapshot.data;
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
                                      color: isSelected
                                          ? Colors.grey
                                          : Colors.black,
                                      fontWeight:
                                          isSelected ? FontWeight.w700 : null,
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          hotel.district ?? '',
                                          style: const TextStyle(
                                              color: Colors.lightBlue),
                                        ),
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HotelLocationScreen(
                                                    hotelAddress:
                                                        hotel.address ?? '',
                                                  ),
                                                ),
                                              );
                                              // LatLng location =
                                              //     await getHotelLocation(
                                              //         hotel.address ?? '');
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => HotelLocationScreen(
                                              //       hotelName: hotel.hotelName ?? '',
                                              //       address: hotel.address ?? '',
                                              //       location: location,
                                              //     ),
                                              //   ),
                                              // );
                                              // GoogleMap(
                                              //   onMapCreated: _onMapCreated,
                                              //   initialCameraPosition:
                                              //       CameraPosition(
                                              //           target: _center,
                                              //           zoom: 11),
                                              // );
                                            },
                                            child: const Text('Maps'))
                                      ],
                                    ),
                                    Text(
                                      hotel.address ?? '',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    Text(
                                      hotel.phoneNumber ?? '',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
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
                                        var newHotel = snapshot.data[index];
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Rooms'),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: List.generate(
                                                  newHotel?.rooms?.length ?? 0,
                                                  (index) => ListTile(
                                                    title: Text(
                                                        'Room ${index + 1}'),
                                                    subtitle: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl:
                                                              '${newHotel?.rooms?[index].roomImage}',
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Text(
                                                            'Room Number :  ${newHotel?.rooms?[index].roomNumber ?? ''}'),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Rs.',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              newHotel
                                                                      ?.rooms?[
                                                                          index]
                                                                      .price ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        (newHotel?.rooms?[index]
                                                                        .available !=
                                                                    null &&
                                                                newHotel
                                                                        ?.rooms?[
                                                                            index]
                                                                        .available ==
                                                                    true)
                                                            ? const Text(
                                                                "Available",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )
                                                            : const Text(
                                                                "Not Available",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              ),
                                                        Column(
                                                          children:
                                                              List.generate(
                                                            newHotel
                                                                    ?.rooms?[
                                                                        index]
                                                                    .bookings
                                                                    ?.length ??
                                                                0,
                                                            (ind) {
                                                              final booking =
                                                                  newHotel
                                                                      ?.rooms?[
                                                                          index]
                                                                      .bookings?[ind];
                                                              return ListTile(
                                                                title: Column(
                                                                  children: [
                                                                    Text(booking
                                                                            ?.startDate ??
                                                                        ""),
                                                                    Text(booking
                                                                            ?.endDate ??
                                                                        ""),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        const Gap(10),
                                                        ElevatedButton(
                                                          onPressed: newHotel
                                                                      ?.rooms?[
                                                                          index]
                                                                      .available ==
                                                                  true
                                                              ? () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => BookingPage(
                                                                              hotelId: 'hotelId',
                                                                              roomNumber: 'roomNumber')));
                                                                }
                                                              : null,
                                                          child: Text(newHotel
                                                                      ?.rooms?[
                                                                          index]
                                                                      .available ==
                                                                  true
                                                              ? 'Booking'
                                                              : 'Not Available'),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('View Rooms'),
                                    ),
                                  ],
                                )));
                      }));
            }));
  }
}
