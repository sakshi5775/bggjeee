import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class KpHouseSignificatorsWidget extends StatelessWidget {
  final KpSystemController controller;

  const KpHouseSignificatorsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingKpHouseSignificators.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.kpHouseSignificatorsData.value;
      
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

      final response = data['data']?['response'] as Map<String, dynamic>?;
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
            ...response.entries.map((entry) {
              final house = entry.key;
              final planets = entry.value as List<dynamic>? ?? [];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildHouseCard(house, planets),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildHouseCard(String house, List<dynamic> planets) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#ed6f30".toColor().withOpacity(0.1),
            "#ed6f30".toColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // House Number
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  'House $house',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.body1),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          
          // Planets
          if (planets.isNotEmpty)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: planets.map((planet) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: "#ed6f30".toColor().withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: AutoTranslateText(
                    planet.toString(),
                    style: MyTextTheme.smallBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.w600,
                    ).merge(AppTypography.body2),
                  ),
                );
              }).toList(),
            )
          else
            AutoTranslateText(
              'No significators',
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.5),
              ).merge(AppTypography.body2),
            ),
        ],
      ),
    );
  }
}

