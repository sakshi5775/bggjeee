import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZodiacSignSelectionGrid extends StatelessWidget {
  final Function(String name) onSignSelected;
  final Color? cardBorderColor;
  final Color? textColor;
  final double? fontSize;

  const ZodiacSignSelectionGrid({
    super.key,
    required this.onSignSelected,
    this.cardBorderColor,
    this.textColor,
    this.fontSize,
  });

  // Zodiac signs with their image paths
  static const List<Map<String, String>> zodiacSigns = [
    {'name': 'Aries', 'image': AppConstant.zodiacAries},
    {'name': 'Taurus', 'image': AppConstant.zodiacTaurus},
    {'name': 'Gemini', 'image': AppConstant.zodiacGemini},
    {'name': 'Cancer', 'image': AppConstant.zodiacCancer},
    {'name': 'Leo', 'image': AppConstant.zodiacLeo},
    {'name': 'Virgo', 'image': AppConstant.zodiacVirgo},
    {'name': 'Libra', 'image': AppConstant.zodiacLibra},
    {'name': 'Scorpio', 'image': AppConstant.zodiacScorpio},
    {'name': 'Sagittarius', 'image': AppConstant.zodiacSagittarius},
    {'name': 'Capricorn', 'image': AppConstant.zodiacCapricorn},
    {'name': 'Aquarius', 'image': AppConstant.zodiacAquarius},
    {'name': 'Pisces', 'image': AppConstant.zodiacPisces},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.75,
      ),
      itemCount: zodiacSigns.length,
      itemBuilder: (context, index) {
        final sign = zodiacSigns[index];
        return _buildZodiacCard(context, sign['name']!, sign['image']!);
      },
    );
  }

  Widget _buildZodiacCard(BuildContext context, String name, String imagePath) {
    final borderColor =
        cardBorderColor ?? AppColors.deepOrange.withValues(alpha: 0.2);
    final shadowColor =
        cardBorderColor?.withValues(alpha: 0.15) ??
        AppColors.deepOrange.withValues(alpha: 0.15);
    final labelColor = textColor ?? AppColors.textPrimary;

    return GestureDetector(
      onTap: () => onSignSelected(name),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Card with Image
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: name.toLowerCase() == 'pisces'
                    ? EdgeInsets.zero
                    : EdgeInsets.all(12.w),
                child: Transform.scale(
                  scale: name.toLowerCase() == 'pisces' ? 1.45 : 1.0,
                  child: NetworkImageWithLoader(
                    url: imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          // Zodiac Name below the card
          AutoTranslateText(
            name,
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCB
                .copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize ?? 11.sp,
                )
                .merge(AppTypography.body2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
