import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart'; 

class GradientCardWidget extends StatelessWidget {
  final List<Color>? colors;
  final Widget child;
  const GradientCardWidget({super.key, this.colors, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors ?? [AppColors.saffron, AppColors.saffron],
          ),
        ),
        child: child,
      ),
    );
  }
}
