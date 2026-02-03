import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/numerology/controller/numerology_form_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumerologyFeaturesView extends BasePage<NumerologyFormController> {
  const NumerologyFeaturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FEF6C3'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: 'Select Feature'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.h(20),
                    _buildInfoCard(),
                    Spacing.h(24),
                    _buildFeaturesGrid(),
                    Spacing.h(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: "#FFFFFF".toColor(), size: 24.w),
            Spacing.w(12),
            Expanded(
              child: AutoTranslateText(
                'Select any numerology feature to get detailed insights',
                style: MyTextTheme.mediumBCN
                    .copyWith(color: "#FFFFFF".toColor(), height: 1.4)
                    .merge(AppTypography.body2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          final childAspectRatio = constraints.maxWidth > 600 ? 0.85 : 0.95;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: controller.tabs.length,
            itemBuilder: (context, index) {
              final tab = controller.tabs[index];
              return _buildFeatureCard(tab, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> tab, int index) {
    // Get description for the feature
    final description = _getFeatureDescription(tab['key'] as String);
    // Get number for display (using index + 1, or specific numbers for certain features)
    // final number = _getFeatureNumber(tab['key'] as String, index);

    return GestureDetector(
      onTap: () => controller.onTabSelected(index),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Number box with gradient at top-left
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                tab['icon'] as IconData,
                color: Colors.white,
                size: 18.w,
              ),
            ),
            Spacing.h(12),
            // Title
            AutoTranslateText(
              tab['title'] as String,
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: const Color(0xFF6F221E),
                    fontWeight: FontWeight.w600,
                  )
                  .merge(AppTypography.body1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacing.h(8),
            // Description
            Expanded(
              child: AutoTranslateText(
                description,
                style: MyTextTheme.smallBCN
                    .copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                      height: 1.4,
                    )
                    .merge(AppTypography.body2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacing.h(8),
            // View Details link
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AutoTranslateText(
                  'View Details',
                  style: MyTextTheme.smallBCB
                      .copyWith(
                        color: "#DD2914".toColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      )
                      .merge(AppTypography.body2),
                ),
                Spacing.w(4),
                Icon(
                  Icons.arrow_forward,
                  color: "#DD2914".toColor(),
                  size: 14.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFeatureNumber(String key, int index) {
    // Map specific features to their numbers, or use index + 1 as fallback
    final numberMap = {
      'key_points': '11',
      'number_analysis': '6',
      'missing_numbers': '8',
      'available_numbers': '4',
      'mobile_analysis': '13',
      'numerology_suggestion': '2,7',
      'name_analysis': '9',
      'vehicle_analysis': '5',
      'lucky_things': '3',
      'personal_year': '1',
      'karmic_number': '12',
      'master_numbers': '10',
      'loshu_grid': '14',
      'reports': '15',
    };
    return numberMap[key] ?? '${index + 1}';
  }

  String _getFeatureDescription(String key) {
    // Map features to their descriptions
    final descriptionMap = {
      'key_points': 'Your potential in later life',
      'number_analysis': 'Your approach to harmony',
      'missing_numbers': 'Your secret driving force',
      'available_numbers': 'Obstacles to overcome',
      'mobile_analysis': 'Lessons from past lives',
      'numerology_suggestion': 'Areas needing development',
      'name_analysis': 'Insights about your name',
      'vehicle_analysis': 'Analysis of your vehicle number',
      'lucky_things': 'Your lucky elements and numbers',
      'personal_year': 'Your current year analysis',
      'karmic_number': 'Karmic lessons and debts',
      'master_numbers': 'Master number insights',
      'loshu_grid': 'Your Lo Shu grid analysis',
      'reports': 'Complete numerology reports',
    };
    return descriptionMap[key] ?? 'Get detailed insights';
  }
}
