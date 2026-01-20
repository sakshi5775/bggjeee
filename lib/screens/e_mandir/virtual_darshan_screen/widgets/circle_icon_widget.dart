import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';

class CircleIconWidget extends StatelessWidget {
  final IconData icon;

  const CircleIconWidget(this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26),
    );
  }
}
