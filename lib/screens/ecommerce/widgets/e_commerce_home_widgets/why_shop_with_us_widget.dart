import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhyShopWithUsWidget extends StatelessWidget {
  const WhyShopWithUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': Icons.verified,
        'title': '100%\nAuthentic',
        'subtitle': 'Certified Gems',
      },
      {
        'icon': Icons.temple_hindu,
        'emoji': 'ðŸ•‰ï¸',
        'title': 'Temple\nBlessed',
        'subtitle': 'Vedic Rituals',
      },
      {
        'icon': Icons.local_shipping,
        'title': 'Fast\nDelivery',
        'subtitle': 'Within 48hrs',
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(22.04.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              '#820B17'.toColor(),
              '#68171E'.toColor(),
              '#5D1C21'.toColor(),
            ],
          ),
          borderRadius: BorderRadius.circular(22.04.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 45.91,
              offset: Offset(0, -11.02),
            ),
          ],
        ),
        child: Column(
          children: [
            AutoTranslateText(
              'Why Shop With Us?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 22.04.sp,
                color: '#DFB343'.toColor(),
                height: 1.33,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.h(22.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: features.map((feature) {
                return _buildFeatureItem(feature);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> feature) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 51.42.w,
            height: 51.42.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ['#E3B341'.toColor(), '#C9A033'.toColor()],
              ),
              borderRadius: BorderRadius.circular(14.69.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5.51,
                  offset: Offset(0, -2.75),
                ),
              ],
            ),
            child: feature['emoji'] != null
                ? Center(
                    child: AutoTranslateText(
                      feature['emoji']!,
                      style: TextStyle(fontSize: 22.04.sp, height: 1.33),
                    ),
                  )
                : Icon(
                    feature['icon'] as IconData,
                    color: '#3D0C11'.toColor(),
                    size: 25.71.sp,
                  ),
          ),
          Spacing.h(10.94),
          AutoTranslateText(
            feature['title']!,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 12.86.sp,
              color: Colors.white,
              height: 1.43,
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.h(2.3),
          AutoTranslateText(
            feature['subtitle']!,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 11.02.sp,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.33,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

