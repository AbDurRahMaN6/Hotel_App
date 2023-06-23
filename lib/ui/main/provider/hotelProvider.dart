import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/hotels.dart';

class HotelProvider with ChangeNotifier {
  List<Hotels> favoriteHotels = [];

  void addToFavorites(Hotels hotel) {
    favoriteHotels.add(hotel);
    notifyListeners();
  }

  void removeFromFavorites(Hotels hotel) {
    favoriteHotels.remove(hotel);
    notifyListeners();
  }

  void removeHotel(Hotels hotel) {
    // Implement the logic to remove the hotel from the list
    notifyListeners();
  }
}
