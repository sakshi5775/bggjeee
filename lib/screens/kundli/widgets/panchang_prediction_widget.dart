import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class PanchangPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const PanchangPredictionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPanchang.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.panchangPredictionData.value;
      
      if (data == null || data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 48.w,
                color: "#6F221E".toColor().withOpacity(0.5),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'No data available',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.6),
                ),
              ),
              Spacing.h(8),
              AutoTranslateText(
                'Please select Panchang from the table',
                textAlign: TextAlign.center,
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
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

      final explantion = response['explantion'] as String? ?? '';
      final tithi = response['tithi'] as Map<String, dynamic>?;
      final weekday = response['weekday'] as Map<String, dynamic>?;
      final yoga = response['yoga'] as Map<String, dynamic>?;
      final karan = response['karan'] as Map<String, dynamic>?;
      final nakshatra = response['nakshatra'] as Map<String, dynamic>?;

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explanation
            if (explantion.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: "#ed6f30".toColor(),
                          size: 20.w,
                        ),
                        Spacing.w(8),
                        AutoTranslateText(
                          'About Panchang Phala',
                          style: AppTypography.h2.copyWith(
                            color: "#6F221E".toColor(),
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(12),
                    AutoTranslateText(
                      explantion,
                      style: AppTypography.body1.copyWith(
                        color: "#6F221E".toColor(),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h(16),
            ],
            
            // Tithi
            if (tithi != null) _buildPanchangItem('Tithi', tithi, Icons.calendar_today),
            Spacing.h(16),
            
            // Weekday
            if (weekday != null) _buildPanchangItem('Weekday', weekday, Icons.today),
            Spacing.h(16),
            
            // Yoga
            if (yoga != null) _buildPanchangItem('Yoga', yoga, Icons.auto_awesome),
            Spacing.h(16),
            
            // Karan
            if (karan != null) _buildPanchangItem('Karan', karan, Icons.star),
            Spacing.h(16),
            
            // Nakshatra
            if (nakshatra != null) _buildPanchangItem('Nakshatra', nakshatra, Icons.stars),
          ],
        ),
      );
    });
  }

  Widget _buildPanchangItem(String title, Map<String, dynamic> data, IconData icon) {
    final name = data['name'] as String? ?? '';
    final prediction = data['prediction'] as String? ?? '';

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
          Row(
            children: [
              Icon(
                icon,
                color: "#ed6f30".toColor(),
                size: 20.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: AppTypography.h2.copyWith(
                  color: "#6F221E".toColor(),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          
          // Name
          if (name.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: "#ed6f30".toColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                name,
                style: AppTypography.h3.copyWith(
                  color: "#ed6f30".toColor(),
                ),
              ),
            ),
            Spacing.h(12),
          ],
          
          // Prediction
          if (prediction.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                prediction,
                style: AppTypography.body1.copyWith(
                  color: "#6F221E".toColor(),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

