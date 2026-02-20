import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FriendshipTableWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const FriendshipTableWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingFriendshipTable.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepOrange),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Friendship Table...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.friendshipTableData.value;
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No Friendship Table data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(16),
            if (data['permanent_table'] != null)
              _buildTable(
                'Permanent Friendship',
                Icons.handshake_rounded,
                data['permanent_table'] as Map<String, dynamic>,
              ),
            Spacing.h(16),
            if (data['temporary_friendship'] != null)
              _buildTable(
                'Temporary Friendship',
                Icons.swap_horiz_rounded,
                data['temporary_friendship'] as Map<String, dynamic>,
              ),
            Spacing.h(16),
            if (data['five_fold_friendship'] != null)
              _buildTable(
                'Five Fold Friendship',
                Icons.star_rounded,
                data['five_fold_friendship'] as Map<String, dynamic>,
              ),
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
            color: AppColors.deepOrange.withOpacity(0.3),
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.people_rounded,
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
                  'Friendship Table',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: AppColors.golden,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Planetary relationships',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.golden.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
    String title,
    IconData icon,
    Map<String, dynamic> tableData,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.deepOrange.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18.w),
                ),
                Spacing.w(10),
                Expanded(
                  child: AutoTranslateText(
                    title,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ...tableData.entries.toList().asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final entry = mapEntry.value;
            final value = entry.value;
            String displayValue = '';

            if (value is List) {
              displayValue = value.join(', ');
            } else if (value is Map) {
              displayValue = value.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join(', ');
            } else {
              displayValue = value?.toString() ?? '';
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.white
                    : AppColors.deepOrange.withOpacity(0.03),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.deepOrange.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AutoTranslateText(
                      _formatPropertyName(entry.key),
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AutoTranslateText(
                      displayValue,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.end,
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
