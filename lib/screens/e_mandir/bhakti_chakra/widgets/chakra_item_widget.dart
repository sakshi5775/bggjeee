import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/chakra_status_enum.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/chakra_day_badge_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/chakra_left_icon_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

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
          margin: AppMargin.only(left: 6, bottom: 12),
          padding: AppPaddings.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.all(14),
            border: Border.all(
              color: status == ChakraStatus.current
                  ? Colors.deepOrange
                  : Colors.blue,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT ICON
              ChakraLeftIconWidget(status: status),
              Spacing.w(10),
              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      title,
                      style: MyTextTheme.mediumBCB,
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      subtitle,
                      style: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              /// DAY BADGE
              ChakraDayBadgeWidget(day: day, status: status),
            ],
          ),
        ),
      ],
    );
  }
}
