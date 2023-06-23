import 'dart:convert';

import 'package:auth_ui/api/auth.dart';
import 'package:auth_ui/create_rooms/createRooms.dart';
import 'package:auth_ui/models/bookings.dart';
import 'package:auth_ui/models/hotels.dart';
import 'package:auth_ui/ui/main/updateHotel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'delete_hotel.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  Hotels? hotel;
  List<dynamic>? hotelList;

  Future<void> deleteHotel1(Hotels? hotel, String? id) async {
    String deleteUrl = 'http://172.18.9.11:8080/api/hotels/$id';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    var data = await http.delete(
      Uri.parse(deleteUrl),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "*/*",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "User-Agent": "PostmanRuntime/7.29.2",
        "Connection": "keep-alive",
      },
    );

    if (data.statusCode == 204) {
      setState(() {
        hotelList?.remove(hotel);
      });
      print('Hotel deleted successfully');
    } else {
      print('Failed to delete hotel. Status code: ${data.statusCode}');
      print('Response body: ${data.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<dynamic>?>(
          future: ApiManager().getHotels(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: const Center(child: Icon(Icons.error)));
            }
            hotelList = snapshot.data;
            return DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Images',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Hotel Name',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'District',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Address',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Phone Number',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Description',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Rooms',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Action',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(snapshot.data.length, (index) {
                  Hotels? newHotel = snapshot.data[index];
                  return DataRow(cells: <DataCell>[
                    DataCell(
                      CachedNetworkImage(
                        imageUrl: '${newHotel?.image}',
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    DataCell(Text('${newHotel?.hotelName}')),
                    DataCell(Text('${newHotel?.district}')),
                    DataCell(Text('${newHotel?.address}')),
                    DataCell(Text('${newHotel?.phoneNumber}')),
                    DataCell(Text('${newHotel?.desc}')),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Rooms'),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    newHotel?.rooms?.length ?? 0,
                                    (index) => ListTile(
                                      title: Text('Room ${index + 1}'),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                '${newHotel?.rooms?[index].roomImage}',
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                              'Room Number :  ${newHotel?.rooms?[index].roomNumber ?? ''}'),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Rs.',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                newHotel?.rooms?[index].price ??
                                                    '',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          (newHotel?.rooms?[index].available !=
                                                      null &&
                                                  newHotel?.rooms?[index]
                                                          .available ==
                                                      true)
                                              ? const Text(
                                                  "Available",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              : const Text(
                                                  "Not Available",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                          Column(
                                            children: List.generate(
                                              newHotel?.rooms?[index].bookings
                                                      ?.length ??
                                                  0,
                                              (ind) {
                                                final booking = newHotel
                                                    ?.rooms?[index]
                                                    .bookings?[ind];
                                                return ListTile(
                                                  title: Column(
                                                    children: [
                                                      Text(booking?.startDate ??
                                                          ""),
                                                      Text(booking?.endDate ??
                                                          ""),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddRooms(hotelId: ''),
                                      ),
                                    ).then((_) {
                                      setState(() {
                                        hotelList =
                                            ApiManager().getHotels() as List?;
                                      });
                                    });
                                    // => Navigator.pop(context));
                                  },
                                  icon: const Icon(
                                      color: Colors.green, Icons.add),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('View Rooms'),
                      ),
                    ),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateHotels(
                                  hotel: newHotel,
                                ),
                              ),
                            ).then((_) {
                              setState(() {
                                hotelList = ApiManager().getHotels() as List?;
                              });
                            });
                            // => Navigator.pop(context));
                          },
                          icon: const Icon(color: Colors.green, Icons.edit),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Confirm Deletation'),
                                        content: const Text(
                                            'Are you sure want to delete this hotel?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel')),
                                          TextButton(
                                            child: const Text('Ok'),
                                            onPressed: () {
                                              deleteHotel1(
                                                      newHotel, newHotel?.id)
                                                  .then((value) =>
                                                      Navigator.pop(context));
                                            },
                                          )
                                        ],
                                      ));
                            },
                            icon: const Icon(color: Colors.red, Icons.delete))
                      ],
                    ))
                  ]);
                }));
          }),
    );
  }
}
