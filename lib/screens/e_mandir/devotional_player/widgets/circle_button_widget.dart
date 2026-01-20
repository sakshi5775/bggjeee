import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';

class CircleButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CircleButtonWidget({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.all(20),
      child: Container(
        padding: AppPaddings.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.deepOrange),
      ),
    );
  }
}
