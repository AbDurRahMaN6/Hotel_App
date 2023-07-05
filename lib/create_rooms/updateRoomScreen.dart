import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UpdateRoomScreen extends StatefulWidget {
  final String? hotelId;
  final String? roomNumber;
  const UpdateRoomScreen(
      {required this.hotelId, required this.roomNumber, Key? key})
      : super(key: key);

  @override
  State<UpdateRoomScreen> createState() => _UpdateRoomScreenState();
}

class _UpdateRoomScreenState extends State<UpdateRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
