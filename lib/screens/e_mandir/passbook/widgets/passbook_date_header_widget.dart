import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

class PassbookDateHeaderWidget extends StatelessWidget {
  final String date;

  const PassbookDateHeaderWidget({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 14, bottom: 6),
      child: AutoTranslateText(
        date,
        style: AppTypography.body2.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
