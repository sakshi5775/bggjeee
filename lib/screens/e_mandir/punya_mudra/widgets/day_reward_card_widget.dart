import 'package:flutter/material.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DayRewardCardWidget extends StatelessWidget {
  final String dayText;

  const DayRewardCardWidget({
    super.key,
    required this.dayText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECE2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.deepOrange),
            ),
            child: Text(
              dayText,
              style: const TextStyle(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const CircleAvatar(
            radius: 11,
            backgroundColor: AppColors.deepOrange,
            child: Icon(Icons.check, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
