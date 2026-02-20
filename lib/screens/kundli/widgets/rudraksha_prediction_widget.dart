import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/prediction_style.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RudrakshaPredictionWidget extends StatelessWidget {
  final PredictionsController controller;

  const RudrakshaPredictionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRudraksha.value) {
        return PredictionStyle.buildLoadingIndicator();
      }

      final data = controller.rudrakshaPredictionData.value;
      final response = data?['data']?['response'] as Map<String, dynamic>? ?? data?['response'] as Map<String, dynamic>?;

      if (response == null || response.isEmpty) {
        return PredictionStyle.buildEmptyState(
          message: 'No data available',
          submessage: 'Generate Kundli first to view Rudraksha suggestion',
        );
      }

      final rudraksh = (response['rudraksh'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final name = (response['name'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final qualities = (response['qualities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final howToWear = response['how_to_wear']?.toString() ?? '';
      final timeToWear = response['time_to_wear']?.toString() ?? '';
      final mantra = (response['mantra'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final personalizedResponse = response['personalized_response']?.toString() ?? '';
      final purification = response['purification']?.toString() ?? '';

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _compactCard(Icons.self_improvement_rounded, 'Recommended Rudraksh', rudraksh, name, qualities, mantra),
            if (howToWear.isNotEmpty || timeToWear.isNotEmpty) ...[
              Spacing.h(10),
              _compactInfoCard(Icons.access_time_rounded, 'Wearing', howToWear, timeToWear),
            ],
            if (personalizedResponse.isNotEmpty) ...[
              Spacing.h(10),
              _compactTextCard(Icons.person_outline_rounded, 'Personalized', personalizedResponse),
            ],
            if (purification.isNotEmpty) ...[
              Spacing.h(10),
              _compactTextCard(Icons.cleaning_services_rounded, 'Purification', purification),
            ],
          ],
        ),
      );
    });
  }

  Widget _compactCard(IconData icon, String title, List<String> rudraksh, List<String> name, List<String> qualities, List<String> mantra) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: PredictionStyle.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionStyle.iconBadge(icon, size: 18),
              Spacing.w(8),
              AutoTranslateText(title, style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12.sp)),
            ],
          ),
          Spacing.h(12),
          ...List.generate(rudraksh.length, (i) {
            return Container(
              margin: EdgeInsets.only(bottom: i < rudraksh.length - 1 ? 10.h : 0),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.deepOrange.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.deepOrange.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(rudraksh[i], style: MyTextTheme.smallBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  if (i < name.length) ...[Spacing.h(4), AutoTranslateText(name[i], style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp))],
                  if (i < qualities.length) ...[Spacing.h(4), AutoTranslateText(qualities[i], style: MyTextTheme.smallBCN.copyWith(color: AppColors.textSecondary, fontSize: 11.sp))],
                  if (i < mantra.length && mantra[i].isNotEmpty) ...[
                    Spacing.h(6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                      decoration: BoxDecoration(color: AppColors.deepOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                      child: AutoTranslateText(mantra[i], style: MyTextTheme.smallBCN.copyWith(color: AppColors.textPrimary, fontSize: 11.sp, fontStyle: FontStyle.italic)),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _compactInfoCard(IconData icon, String title, String howToWear, String timeToWear) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: PredictionStyle.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionStyle.iconBadge(icon, size: 18),
              Spacing.w(8),
              AutoTranslateText(title, style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12.sp)),
            ],
          ),
          Spacing.h(10),
          if (howToWear.isNotEmpty) _infoRow('How to Wear', howToWear),
          if (timeToWear.isNotEmpty) ...[if (howToWear.isNotEmpty) Spacing.h(8), _infoRow('Time to Wear', timeToWear)],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90.w, child: AutoTranslateText(label, style: MyTextTheme.smallBCB.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 11.sp))),
        Expanded(child: AutoTranslateText(value, style: MyTextTheme.smallBCN.copyWith(color: AppColors.textPrimary, fontSize: 11.sp))),
      ],
    );
  }

  Widget _compactTextCard(IconData icon, String title, String content) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: PredictionStyle.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PredictionStyle.iconBadge(icon, size: 18),
              Spacing.w(8),
              AutoTranslateText(title, style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12.sp)),
            ],
          ),
          Spacing.h(10),
          AutoTranslateText(content, style: MyTextTheme.smallBCN.copyWith(color: AppColors.textPrimary, fontSize: 11.sp, height: 1.5)),
        ],
      ),
    );
  }
}
