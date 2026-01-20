import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class DayRewardCardWidget extends StatelessWidget {
  final String dayText;

  const DayRewardCardWidget({super.key, required this.dayText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: AppMargin.only(top: 10),
          width: 45,
          height: 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFECE2),
            borderRadius: AppRadius.all(10),
            border: Border.all(color: Colors.deepOrange),
          ),
          child: AutoTranslateText(dayText),
        ),
        const CircleAvatar(
          radius: 13,
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.check, size: 16, color: Colors.white),
        ),
      ],
    );
  }
}
