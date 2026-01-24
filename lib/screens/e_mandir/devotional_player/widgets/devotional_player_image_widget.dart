import 'package:flutter/material.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

class DevotionalPlayerImageWidget extends StatelessWidget {
  const DevotionalPlayerImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage(AppConstant.eMandirGanesha),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
