import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kp_system_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KpCuspsWidget extends StatelessWidget {
  final KpSystemController controller;

  const KpCuspsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingKpCuspsDetails.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.kpCuspsDetailsData.value;
      
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
            ...response.map((cusp) {
              final cuspData = cusp as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildCuspCard(cuspData),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildCuspCard(Map<String, dynamic> data) {
    final house = data['house'] as int? ?? 0;
    final degree = data['degree'] as double? ?? 0.0;
    final sign = data['sign'] as String? ?? '';
    final signLord = data['signLord'] as String? ?? '';
    final nakshatra = data['nakshatra'] as String? ?? '';
    final nakshatraLord = data['nakshatraLord'] as String? ?? '';
    final subLord = data['subLord'] as String? ?? '';
    final subSubLord = data['subSubLord'] as String? ?? '';

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
          _buildDetailRow('Degree', '${degree.toStringAsFixed(2)}°'),
          _buildDetailRow('Sign', sign),
          _buildDetailRow('Sign Lord', signLord),
          _buildDetailRow('Nakshatra', nakshatra),
          _buildDetailRow('Nakshatra Lord', nakshatraLord),
          _buildDetailRow('Sub Lord', subLord),
          _buildDetailRow('Sub Sub Lord', subSubLord),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
              ).merge(AppTypography.body2),
            ),
          ),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              textAlign: TextAlign.right,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
              ).merge(AppTypography.body2),
            ),
          ),
        ],
      ),
    );
  }
}

