import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/chakra_status_enum.dart';
import 'package:flutter/material.dart';

class ChakraLeftIconWidget extends StatelessWidget {
  final ChakraStatus status;

  const ChakraLeftIconWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == ChakraStatus.completed) {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.green,
        child: Icon(Icons.check, size: 14, color: Colors.white),
      );
    } else if (status == ChakraStatus.current) {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.local_fire_department,
            size: 14, color: Colors.white),
      );
    } else {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.grey,
        child: Icon(Icons.lock, size: 14, color: Colors.white),
      );
    }
  }
}
