import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../models/hotels.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Hotels> favoriteHotels = [];

  void removeHotelFromFavorites(Hotels hotel) {
    setState(() {
      favoriteHotels.remove(hotel);
    });
  }

  void removeAllHotelsFromFavorites() {
    setState(() {
      favoriteHotels.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Page'),
      ),
      body: ListView.builder(
        itemCount: favoriteHotels.length,
        itemBuilder: (context, index) {
          Hotels hotel = favoriteHotels[index];
          return Card(
            child: ListTile(
              leading: Image.network(
                hotel.image ?? '',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              title: Text(hotel.hotelName ?? ''),
              subtitle: Text(hotel.district ?? ''),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removeHotelFromFavorites(hotel);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          removeAllHotelsFromFavorites();
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
