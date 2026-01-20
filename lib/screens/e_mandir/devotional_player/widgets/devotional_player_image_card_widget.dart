import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';

class DevotionalPlayerImageCardWidget extends StatelessWidget {
  const DevotionalPlayerImageCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.all(26),
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
