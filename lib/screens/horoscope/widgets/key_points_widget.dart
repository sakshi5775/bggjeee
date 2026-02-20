import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KeyPointsWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const KeyPointsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingExtendedKundali.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.deepOrange),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Key Points...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.extendedKundaliData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Key Points data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      // Group all data dynamically
      final groupedData = _groupDataByCategory(data);

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            _buildTitleSection(),
            Spacing.h(20),

            // Display tables for each category
            if (groupedData['basic'] != null &&
                groupedData['basic']!.isNotEmpty) ...[
              _buildInfoTable(
                'Basic Information',
                Icons.info_outline_rounded,
                groupedData['basic']!,
              ),
              Spacing.h(20),
            ],

            if (groupedData['astrological'] != null &&
                groupedData['astrological']!.isNotEmpty) ...[
              _buildInfoTable(
                'Astrological Details',
                Icons.auto_awesome_rounded,
                groupedData['astrological']!,
              ),
              Spacing.h(20),
            ],

            if (groupedData['stones'] != null &&
                groupedData['stones']!.isNotEmpty) ...[
              _buildInfoTable(
                'Stones & Lucky Elements',
                Icons.diamond_rounded,
                groupedData['stones']!,
                useOrangeGradient: true,
              ),
              Spacing.h(20),
            ],

            // Display any remaining ungrouped data
            if (groupedData['other'] != null &&
                groupedData['other']!.isNotEmpty) ...[
              _buildInfoTable(
                'Other Information',
                Icons.info_outline_rounded,
                groupedData['other']!,
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
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
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.star_rounded,
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
                  'Key Points',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: AppColors.golden,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Extended Kundali Information',
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

  Map<String, Map<String, String>> _groupDataByCategory(
    Map<String, dynamic> data,
  ) {
    final grouped = <String, Map<String, String>>{
      'basic': {},
      'astrological': {},
      'stones': {},
      'other': {},
    };

    // Astrological keywords
    final astrologicalKeywords = [
      'sign',
      'nakshatra',
      'rasi',
      'rasi_lord',
      'tithi',
      'karana',
      'yoga',
      'ascendant',
      'sun',
      'moon',
      'planet',
      'house',
      'lord',
      'pada',
    ];

    // Stones keywords
    final stonesKeywords = ['stone', 'gem', 'rudraksh'];

    // Basic info keywords
    final basicKeywords = [
      'gana',
      'yoni',
      'vasya',
      'nadi',
      'varna',
      'paya',
      'tatva',
      'name',
    ];

    data.forEach((key, value) {
      // Skip nested objects and lists
      if (value is Map || value is List) return;
      if (value == null) return;

      final lowerKey = key.toLowerCase();
      final formattedKey = _formatPropertyName(key);

      // Categorize based on key name
      bool categorized = false;

      // Check for astrological
      for (final keyword in astrologicalKeywords) {
        if (lowerKey.contains(keyword)) {
          grouped['astrological']![formattedKey] = value.toString();
          categorized = true;
          break;
        }
      }

      // Check for stones
      if (!categorized) {
        for (final keyword in stonesKeywords) {
          if (lowerKey.contains(keyword)) {
            grouped['stones']![formattedKey] = value.toString();
            categorized = true;
            break;
          }
        }
      }

      // Check for basic info
      if (!categorized) {
        for (final keyword in basicKeywords) {
          if (lowerKey.contains(keyword)) {
            grouped['basic']![formattedKey] = value.toString();
            categorized = true;
            break;
          }
        }
      }

      // If not categorized, add to other
      if (!categorized) {
        grouped['other']![formattedKey] = value.toString();
      }
    });

    return grouped;
  }

  Widget _buildInfoTable(
    String title,
    IconData icon,
    Map<String, String> data, {
    bool useOrangeGradient = false,
  }) {
    if (data.isEmpty) return const SizedBox.shrink();

    final gradient = AppColors.orangeGradient;
    final headerColor = useOrangeGradient ? Colors.white : AppColors.golden;

    return Container(
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
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: gradient,
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
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20.w),
                ),
                Spacing.w(12),
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
          ...data.entries.toList().asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final entry = mapEntry.value;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.white
                    : AppColors.deepOrange.withValues(alpha: 0.03),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.deepOrange.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AutoTranslateText(
                      entry.key,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AutoTranslateText(
                      entry.value,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.8),
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
    // Convert snake_case to Title Case
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

