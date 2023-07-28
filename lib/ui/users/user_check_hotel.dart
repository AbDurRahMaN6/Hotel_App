import 'dart:convert';
import 'package:auth_ui/models/hotels.dart';
import 'package:auth_ui/ui/users/chat_box.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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
  List<dynamic>? allHotels = [];
  List<dynamic>? filteredHotels = [];
  final TextEditingController _searchController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    fetchHotels();
    fetchSearchHotels();
    _getCurrentLocation();
    initializeLocalNotifications();
  }

  void initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future<void> showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'notification_payload',
    );
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

    setState(() {
      hotelList = hotels!;
      isFavoriteList = List.generate(hotels.length, (_) => false);
    });
  }

  void fetchSearchHotels() async {
    List? hotels =
        await ApiManager().getSearchHotels(hotelName: _searchController.text);

    setState(() {
      hotelList = hotels!;
      filteredHotels = hotels;
    });
  }

  void performSearch(String query) {
    setState(() {
      filteredHotels = hotelList
          ?.where((hotel) =>
              hotel['hotelName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void searchHotels(String query) {
    List<dynamic>? matchedHotels = [];
    for (var hotel in allHotels!) {
      String hotelName = hotel['hotelName'];
      if (hotelName.toLowerCase().contains(query.toLowerCase())) {
        matchedHotels.add(hotel);
      }
    }
    setState(() {
      filteredHotels = matchedHotels;
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

    return const LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
        future: ApiManager().getHotels(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: Icon(Icons.error),
            );
          }
          hotelList = snapshot.data;
          return Column(
            children: [
              SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  controller: _searchController,
                  onChanged: (text) {
                    fetchSearchHotels();
                    performSearch(text);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for hotels...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    itemCount: hotelList?.length,
                    itemBuilder: (context, index) {
                      Hotels hotel = hotelList?[index];
                      bool isFavorite = isFavoriteList[index];
                      bool isSelected = index == selectedHotelIndex;

                      return Column(
                        children: [
                          const Gap(20),
                          Card(
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
                                    color:
                                        isSelected ? Colors.grey : Colors.black,
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
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
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
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    newHotel?.rooms?[index]
                                                                            .price ??
                                                                        '',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  )
                                                                ]),
                                                            (newHotel?.rooms?[index].available !=
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
                                                                    ))
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
                                                                children: List
                                                                    .generate(
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
                                                            )),
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
                                                                              builder: (context) => BookingPage(hotelId: 'hotelId', roomNumber: 'roomNumber')));
                                                                      bool
                                                                          isAvailable =
                                                                          newHotel?.rooms?[index].available ==
                                                                              true;

                                                                      showLocalNotification(
                                                                        'Room Availability',
                                                                        isAvailable
                                                                            ? 'Room is available'
                                                                            : 'Room is not available',
                                                                      );
                                                                    }
                                                                  : null,
                                                              child: Text(newHotel
                                                                          ?.rooms?[
                                                                              index]
                                                                          .available ==
                                                                      true
                                                                  ? 'Booking'
                                                                  : 'Not Available'),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                            ),
                                          ),
                                          icon: Positioned(
                                              top: 50,
                                              bottom: 20,
                                              right: 20,
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatBox()));
                                                },
                                                icon: const Icon(Icons.message),
                                                color: Colors.red,
                                                iconSize: 100,
                                              )),
                                        ),
                                      );
                                    },
                                    child: const Text('View Rooms'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          );
        });
  }
}
