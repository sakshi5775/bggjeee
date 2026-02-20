import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/prediction_style.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
        return PredictionStyle.buildLoadingIndicator();
      }

      final data = controller.panchangPredictionData.value;
      if (data == null || data.isEmpty) {
        return PredictionStyle.buildEmptyState(
          message: 'No data available',
          submessage: 'Please select Panchang from the table',
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
              fontSize: 12.sp,
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
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: "#ed6f30".toColor().withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (explantion.isNotEmpty) ...[
                      _buildAboutSection(explantion),
                      Spacing.h(6),
                    ],
                    if (tithi != null) _buildItem('Tithi', tithi, Icons.calendar_today),
                    if (tithi != null) Spacing.h(5),
                    if (weekday != null) _buildItem('Weekday', weekday, Icons.today),
                    if (weekday != null) Spacing.h(5),
                    if (yoga != null) _buildItem('Yoga', yoga, Icons.auto_awesome),
                    if (yoga != null) Spacing.h(5),
                    if (karan != null) _buildItem('Karan', karan, Icons.star),
                    if (karan != null) Spacing.h(5),
                    if (nakshatra != null) _buildItem('Nakshatra', nakshatra, Icons.stars),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
      ),
      child: Row(
        children: [
          Icon(Icons.nightlight_round, size: 14.w, color: Colors.white),
          Spacing.w(6),
          AutoTranslateText(
            'Panchang Phala',
            style: MyTextTheme.mediumBCB.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String text) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.orangeGradient.colors.first.withValues(alpha: 0.08),
            AppColors.orangeGradient.colors.last.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.orangeGradient.colors.first,
                size: 14.w,
              ),
              Spacing.w(5),
              AutoTranslateText(
                'About Panchang Phala',
                style: MyTextTheme.smallBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          Spacing.h(5),
          AutoTranslateText(
            text,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor(),
              height: 1.45,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, Map<String, dynamic> data, IconData icon) {
    final name = data['name'] as String? ?? '';
    final prediction = data['prediction'] as String? ?? '';

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Icon(icon, color: Colors.white, size: 12.w),
              ),
              Spacing.w(6),
              AutoTranslateText(
                title,
                style: MyTextTheme.smallBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          if (name.isNotEmpty) ...[
            Spacing.h(4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: AutoTranslateText(
                name,
                style: MyTextTheme.smallBCB.copyWith(
                  color: AppColors.orangeGradient.colors.first,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
          if (prediction.isNotEmpty) ...[
            Spacing.h(4),
            AutoTranslateText(
              prediction,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor(),
                height: 1.45,
                fontSize: 10.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

