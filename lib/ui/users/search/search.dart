import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../api/auth.dart';
import '../../../models/hotels.dart';

class SearchHotels extends StatefulWidget {
  const SearchHotels({super.key});

  @override
  State<SearchHotels> createState() => _SearchHotelsState();
}

class _SearchHotelsState extends State<SearchHotels> {
  Hotels? hotel;
  List<dynamic>? hotelList = [];
  List<bool> isFavoriteList = [];
  int? selectedHotelIndex;
  List<dynamic>? allHotels = [];
  List<dynamic>? filteredHotels = [];
  final TextEditingController _searchController = TextEditingController();

  void fetchSearchHotels() async {
    List? hotels =
        await ApiManager().getSearchHotels(hotelName: _searchController.text);

    setState(() {
      hotelList = hotels!;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiManager().getSearchHotels(hotelName: _searchController.text),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
            ],
          );
        });
  }
}
