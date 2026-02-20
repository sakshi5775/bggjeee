import 'package:flutter/material.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/data_model/chakra_item.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class ChakraItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String day;
  final ChakraStatus status;

  const ChakraItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.day,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// DOTTED LINE
        Positioned(
          left: 18,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.blue,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 6, bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: status == ChakraStatus.current
                  ? AppColors.deepOrange
                  : Colors.blue,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT ICON
              _leftIcon(status),
              const SizedBox(width: 10),
              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      title,
                      style: AppTypography.h3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AutoTranslateText(
                      subtitle,
                      style: AppTypography.body2.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              /// DAY BADGE
              _dayBadge(day, status),
            ],
          ),
        ),
      ],
    );
  }

  Widget _leftIcon(ChakraStatus status) {
    if (status == ChakraStatus.completed) {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.green,
        child: Icon(Icons.check, size: 14, color: Colors.white),
      );
    } else if (status == ChakraStatus.current) {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: AppColors.deepOrange,
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

  Widget _dayBadge(String day, ChakraStatus status) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status == ChakraStatus.locked
            ? Colors.grey.shade300
            : AppColors.deepOrange,
      ),
      alignment: Alignment.center,
      child: Text(
        day,
        style: AppTypography.body2.copyWith(
          color: status == ChakraStatus.locked
              ? Colors.grey
              : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
