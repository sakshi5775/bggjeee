
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../core/value/dimension.dart'; 


class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.inActiveColor,
    this.activeColor = AppColors.saffron,
  });

  final bool isActive;

  final Color? inActiveColor, activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor
            : inActiveColor ?? AppColors.saffron.withValues(alpha: 0.2),
        borderRadius: AppRadius.all(50),
      ),
    );
  }
}
