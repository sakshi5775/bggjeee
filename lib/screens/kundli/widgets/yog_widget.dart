import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/yog_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YogWidget extends StatelessWidget {
  final YogController controller;

  const YogWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYog.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.yogData.value;

      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No yog data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No yog data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final panchang = response['panchang'] as Map<String, dynamic>?;
      final yoga = panchang?['yoga']?.toString() ?? '';

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildYogaCard(context, yoga),
            Spacing.h(12),
            if (panchang != null && panchang.isNotEmpty) _buildPanchangCard(context, panchang),
          ],
        ),
      );
    });
  }

  Widget _buildYogaCard(BuildContext context, String yoga) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF8C42), Color(0xFFE63946)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: "#FFFFFF".toColor(),
              size: 24.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoTranslateText(
                  'Yoga',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  yoga.isEmpty ? '--' : yoga,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanchangCard(BuildContext context, Map<String, dynamic> panchang) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
              Icon(Icons.calendar_today, size: 18.w, color: "#6F221E".toColor()),
              Spacing.w(8),
              AutoTranslateText(
                'Panchang Details',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          _buildInfoRow('Tithi', panchang['tithi']?.toString() ?? '--'),
          Spacing.h(8),
          _buildInfoRow('Karana', panchang['karana']?.toString() ?? '--'),
          Spacing.h(8),
          _buildInfoRow('Day of Birth', panchang['day_of_birth']?.toString() ?? '--'),
          Spacing.h(8),
          _buildInfoRow('Day Lord', panchang['day_lord']?.toString() ?? '--'),
          if (panchang['hora_lord'] != null) ...[
            Spacing.h(8),
            _buildInfoRow('Hora Lord', panchang['hora_lord']?.toString() ?? '--'),
          ],
          if (panchang['sunrise_at_birth'] != null) ...[
            Spacing.h(8),
            _buildInfoRow('Sunrise', panchang['sunrise_at_birth']?.toString() ?? '--'),
          ],
          if (panchang['sunset_at_birth'] != null) ...[
            Spacing.h(8),
            _buildInfoRow('Sunset', panchang['sunset_at_birth']?.toString() ?? '--'),
          ],
          if (panchang['ayanamsa_name'] != null) ...[
            Spacing.h(8),
            _buildInfoRow('Ayanamsa', panchang['ayanamsa_name']?.toString() ?? '--'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ),
        Spacing.w(12),
        Expanded(
          flex: 3,
          child: AutoTranslateText(
            value,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor(),
              fontSize: 11.sp,
            ),
          ),
        ),
      ],
    );
  }
}

