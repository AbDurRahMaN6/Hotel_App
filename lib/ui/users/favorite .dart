// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/src/widgets/framework.dart';
// // import 'package:flutter/src/widgets/placeholder.dart';
// // import 'package:gap/gap.dart';

// // import '../../models/hotels.dart';

// // class FavoritePage extends StatefulWidget {
// //   final Hotels? selectedHotel;

// //   const FavoritePage({Key? key, required this.selectedHotel}) : super(key: key);

// //   @override
// //   State<FavoritePage> createState() => _FavoritePageState();
// // }

// // class _FavoritePageState extends State<FavoritePage> {
// //   bool isFavorite = true;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Favorite Page for Users',
// //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
// //         ),
// //       ),
// //       body: Center(
// //         child: Card(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               ListTile(
// //                 leading: CachedNetworkImage(
// //                   height: 100,
// //                   width: 100,
// //                   imageUrl: '${widget.selectedHotel?.image}',
// //                   placeholder: (context, url) =>
// //                       const CircularProgressIndicator(),
// //                   errorWidget: (context, url, error) => const Icon(Icons.error),
// //                   fit: BoxFit.cover,
// //                 ),
// //                 title:
// //                     Text('Hotelname: ${widget.selectedHotel?.hotelName ?? ''}'),
// //                 subtitle:
// //                     Text('District: ${widget.selectedHotel?.district ?? ''}'),
// //               ),
// //               ButtonBar(
// //                 children: [
// //                   GestureDetector(
// //                     onTap: () {
// //                       setState(() {
// //                         isFavorite = !isFavorite;
// //                       });
// //                     },
// //                     child: Icon(
// //                       isFavorite ? Icons.favorite : Icons.favorite_border,
// //                       color: isFavorite ? Colors.red : null,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:js';

// import 'package:auth_ui/ui/users/user_check_hotel.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// import '../../models/hotels.dart';

// class FavoritePage extends StatefulWidget {
//   const FavoritePage({super.key});

//   @override
//   State<FavoritePage> createState() => _FavoritePageState();
// }

// class _FavoritePageState extends State<FavoritePage> {
//   List<Hotels> favoriteHotels = [];

//   void removeFromFavorites(int index) {
//     setState(() {
//       favoriteHotels.removeAt(index);
//     });
//   }

//   void removeAllFavorites() {
//     setState(() {
//       favoriteHotels.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (favoriteHotels.isEmpty) {
//       return const Center(
//           child: Text(
//         'No hotels in List',
//         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
//       ));
//     }

//     return ListView.builder(
//       itemCount: favoriteHotels.length,
//       itemBuilder: (context, index) {
//         Hotels hotel = favoriteHotels[index];

//         return Card(
//           child: ListTile(
//             leading: CachedNetworkImage(
//               height: 100,
//               width: 100,
//               imageUrl: hotel.image!,
//               placeholder: (context, url) => const CircularProgressIndicator(),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//               fit: BoxFit.cover,
//             ),
//             title: Text(hotel.hotelName!),
//             subtitle: Text(hotel.district!),
//             trailing: IconButton(
//               icon: const Icon(Icons.remove),
//               onPressed: () => removeFromFavorites(index),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: const Text('User Hotels'),
//       ),
//       body: UserHotels(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context as BuildContext,
//             MaterialPageRoute(builder: (context) => const FavoritePage()),
//           );
//         },
//         child: const Icon(Icons.favorite),
//       ),
//     ),
//   ));
// }

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
