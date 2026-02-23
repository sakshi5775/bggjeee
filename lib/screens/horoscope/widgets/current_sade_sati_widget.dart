import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CurrentSadeSatiWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const CurrentSadeSatiWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSadeSati.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepOrange),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Sade Sati Status...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.sadeSatiData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No Sade Sati data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      final isActive =
          data['is_active'] == true ||
          data['is_under_sade_sati'] == true ||
          data['sade_sati_status'] == true;

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(16),
            _buildStatusCard(isActive),
            Spacing.h(16),
            _buildInfoCard(data),
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.warning_rounded,
              color: AppColors.golden,
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Sade Sati Status',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: AppColors.golden,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Saturn\'s transit effect',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.golden.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isActive) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.orangeGradient : null,
        color: isActive ? null : Colors.green.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isActive
              ? Colors.transparent
              : Colors.green.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppColors.deepOrange.withValues(alpha: 0.3)
                : Colors.green.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isActive ? 0.2 : 0.8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isActive ? Icons.warning_rounded : Icons.check_circle,
              color: isActive ? Colors.white : Colors.green,
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  isActive ? 'Sade Sati Active' : 'Sade Sati Not Active',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: isActive ? Colors.white : Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  isActive
                      ? 'You are under Sade Sati influence'
                      : 'You are not under Sade Sati influence',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.deepOrange.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.golden,
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Sade Sati Details',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          ...data.entries
              .where(
                (e) =>
                    e.key != 'is_active' &&
                    e.key != 'is_under_sade_sati' &&
                    e.key != 'sade_sati_status' &&
                    e.value != null &&
                    e.value.toString().isNotEmpty,
              )
              .map((entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _buildInfoRow(
                    _formatPropertyName(entry.key),
                    entry.value.toString(),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.deepOrange.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacing.w(12),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPropertyName(String key) {
    return key
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
