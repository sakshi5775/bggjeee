import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dosh_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PitraDoshWidget extends StatelessWidget {
  final DoshController controller;

  const PitraDoshWidget({super.key, required this.controller});

  static const Color _orange = Color(0xFFed6f30);
  static const Color _orangeLight = Color(0xFFFF8A3D);
  static const Color _maroon = Color(0xFF6F221E);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPitraDosh.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.pitraDoshData.value;

      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final isDoshaPresent = response['is_dosha_present'] as bool? ?? false;
      final botResponse = response['bot_response'] as String? ?? '';
      final effects = response['effects'] as List<dynamic>? ?? [];
      final remedies = response['remedies'] as List<dynamic>? ?? [];

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (botResponse.isNotEmpty) _buildBotResponseCard(botResponse),

            Spacing.h(12),
            _buildStatusCard(isDoshaPresent),

            Spacing.h(12),
            if (effects.isNotEmpty) _buildEffectsCard(effects),

            Spacing.h(12),
            if (remedies.isNotEmpty) _buildRemediesCard(remedies),
          ],
        ),
      );
    });
  }

  Widget _buildBotResponseCard(String botResponse) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline, color: _orange, size: 20.w),
          Spacing.w(10),
          Expanded(
            child: AutoTranslateText(
              botResponse,
              style: MyTextTheme.smallBCN.copyWith(
                color: _maroon,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDoshaPresent) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            'Pitra Dosh Status',
            style: MyTextTheme.mediumBCB.copyWith(
              color: _maroon,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isDoshaPresent
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: AutoTranslateText(
              isDoshaPresent ? 'Present' : 'Not Present',
              style: MyTextTheme.smallBCB.copyWith(
                color: isDoshaPresent ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectsCard(List<dynamic> effects) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_orangeLight, _orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18.w),
              ),
              Spacing.w(10),
              AutoTranslateText(
                'Effects',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: _maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          Spacing.h(10),
          ...effects.map((effect) {
            final effectText = effect.toString();
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: _maroon.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: _orange.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline, color: _orange, size: 16.w),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      effectText,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: _maroon,
                        height: 1.5,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRemediesCard(List<dynamic> remedies) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _maroon.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_orangeLight, _orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.healing, color: Colors.white, size: 18.w),
              ),
              Spacing.w(10),
              AutoTranslateText(
                'Remedies',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: _maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          Spacing.h(10),
          ...remedies.asMap().entries.map((entry) {
            final index = entry.key;
            final remedy = entry.value.toString();
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: _maroon.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: _orange.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_orangeLight, _orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        '${index + 1}',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                  Spacing.w(10),
                  Expanded(
                    child: AutoTranslateText(
                      remedy,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: _maroon,
                        height: 1.5,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

