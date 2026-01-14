import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LalKitabKundliWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabKundliWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabHoroscope.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.lalKitabHoroscopeData.value;
      
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as List<dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...response.map((signData) {
              final sign = signData as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildSignCard(sign),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildSignCard(Map<String, dynamic> sign) {
    final signNumber = sign['sign'] as int? ?? 0;
    final signName = sign['sign_name'] as String? ?? '';
    final planets = sign['planet'] as List<dynamic>? ?? [];
    final planetSmall = sign['planet_small'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#FFFFFF".toColor(),
            "#FFFFFF".toColor(),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sign Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  // color: "#ed6f30".toColor(),
                  gradient: LinearGradient(colors: 
                  [
                     "#FF8C42".toColor(),
                     "#E63946".toColor(),
                  ]),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  'Sign $signNumber: $signName',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h3),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          
          // Planets
          if (planets.isNotEmpty)
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: planets.asMap().entries.map((entry) {
                final index = entry.key;
                final planet = entry.value.toString();
                final planetShort = index < planetSmall.length 
                    ? planetSmall[index].toString() 
                    : planet.substring(0, 2);
                
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: "#ed6f30".toColor().withOpacity(0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: "#ed6f30".toColor().withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        planetShort,
                        style: MyTextTheme.smallBCB.copyWith(
                          color: "#ed6f30".toColor(),
                          fontWeight: FontWeight.bold,
                        ).merge(AppTypography.body1),
                      ),
                      Spacing.h(2),
                      AutoTranslateText(
                        planet,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor(),
                        ).merge(AppTypography.label),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          else
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                border: Border.all(color: Colors.deepOrange, width: 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: "#6F221E".toColor().withOpacity(0.5),
                    size: 16.w,
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'No planets',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor().withOpacity(0.5),
                    ).merge(AppTypography.body2),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

