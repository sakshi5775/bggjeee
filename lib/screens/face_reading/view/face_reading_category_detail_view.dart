import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/face_reading_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceReadingCategoryDetailView extends StatelessWidget {
  const FaceReadingCategoryDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String categoryType = Get.arguments?['categoryType'] ?? '';
    final FaceReadingCategoryDetail? category = Get.arguments?['category'];
    final FaceReadingData? result = Get.arguments?['result'];

    if (category == null || result == null) {
      return Scaffold(
        backgroundColor: '#F7EFBD'.toColor(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: const CommonHeader(title: 'Category Detail'),
        ),
        body: Center(
          child: AutoTranslateText(
            'No data found',
            style: MyTextTheme.mediumBCB.copyWith(color: '#3E2723'.toColor()),
          ),
        ),
      );
    }

    final lists = result.detailedAnalysis?.lists;
    final categoryTitle = _getCategoryTitle(categoryType);
    final icon = _getCategoryIcon(categoryType);

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: categoryTitle,
              subtitle: AutoTranslateText(
                'AI-Powered Physiognomy reading',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0x666F221E),
                ),
              ),
              showSearch: false,
              showCart: false,
              showLanguage: false,
              showWallet: false,
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Score
                    _buildHeaderSection(categoryTitle, icon, category),
                    Spacing.h(24),
                    // Key Insight
                    _buildKeyInsightCard(category),
                    Spacing.h(16),
                    // Core Personality/Characteristics
                    _buildCoreCard(categoryTitle, category, lists),
                    Spacing.h(16),
                    // Strengths
                    if (lists?.strengths != null &&
                        lists!.strengths!.isNotEmpty) ...[
                      _buildStrengthsCard(lists.strengths!),
                      Spacing.h(16),
                    ],
                    // Areas For Growth
                    if (lists?.areasForGrowth != null &&
                        lists!.areasForGrowth!.isNotEmpty) ...[
                      _buildAreasForGrowthCard(lists.areasForGrowth!),
                      Spacing.h(16),
                    ],
                    // Social Traits
                    if (lists?.socialTraits != null &&
                        lists!.socialTraits!.isNotEmpty) ...[
                      _buildSocialTraitsCard(lists.socialTraits!),
                      Spacing.h(16),
                    ],
                    // Recommendations
                    if (lists?.recommendations != null &&
                        lists!.recommendations!.isNotEmpty) ...[
                      _buildRecommendationsCard(lists.recommendations!),
                      Spacing.h(16),
                    ],
                    // Want Deeper Insights
                    _buildDeeperInsightsSection(),
                    Spacing.h(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryTitle(String categoryType) {
    switch (categoryType.toLowerCase()) {
      case 'personality':
        return 'Personality Traits';
      case 'career':
        return 'Career & Success';
      case 'love':
        return 'Love & Relationships';
      case 'wealth':
        return 'Wealth Indicators';
      case 'health':
        return 'Health & Vitality';
      default:
        return 'Category';
    }
  }

  IconData _getCategoryIcon(String categoryType) {
    switch (categoryType.toLowerCase()) {
      case 'personality':
        return Icons.person;
      case 'career':
        return Icons.business_center;
      case 'love':
        return Icons.favorite;
      case 'wealth':
        return Icons.trending_up;
      case 'health':
        return Icons.health_and_safety;
      default:
        return Icons.info;
    }
  }

  Widget _buildHeaderSection(
    String title,
    IconData icon,
    FaceReadingCategoryDetail category,
  ) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: '#FFF2E8'.toColor(),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: "#F38B3B".toColor(), size: 32.w),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(8),
                Row(
                  children: [
                    Icon(Icons.star, color: "#F38B3B".toColor(), size: 24.w),
                    AutoTranslateText(
                      '${category.score ?? 0}/100',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: "#F38B3B".toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyInsightCard(FaceReadingCategoryDetail category) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: "#F38B3B".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Key Insight',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            category.description ?? '',
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#3E2723'.toColor(),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreCard(
    String title,
    FaceReadingCategoryDetail category,
    FaceReadingLists? lists,
  ) {
    final coreTitle = title == 'Personality Traits'
        ? 'Core Personality'
        : title == 'Career & Success'
        ? 'Career Characteristics'
        : title == 'Love & Relationships'
        ? 'Romantic Nature'
        : title == 'Wealth Indicators'
        ? 'Wealth Characteristics'
        : 'Health Characteristics';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: "#F38B3B".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                coreTitle,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          if (category.keywords != null)
            ...category.keywords!.map((keyword) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6.h, right: 12.w),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: "#F38B3B".toColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: AutoTranslateText(
                        keyword,
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: '#3E2723'.toColor(),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildStrengthsCard(List<String> strengths) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AutoTranslateText('💪', style: TextStyle(fontSize: 20.w)),
              Spacing.w(8),
              AutoTranslateText(
                'Strengths',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          ...strengths.map((strength) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6.h, right: 12.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: "#F38B3B".toColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      strength,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#3E2723'.toColor(),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAreasForGrowthCard(List<String> areas) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: "#F38B3B".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Areas For Growth',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          ...areas.map((area) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6.h, right: 12.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: "#F38B3B".toColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      area,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#3E2723'.toColor(),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSocialTraitsCard(List<String> traits) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.diamond, color: "#F38B3B".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Social Traits',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          ...traits.map((trait) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6.h, right: 12.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: "#F38B3B".toColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      trait,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#3E2723'.toColor(),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(List<String> recommendations) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: "#F38B3B".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Recommendations',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          ...recommendations.asMap().entries.map((entry) {
            final index = entry.key;
            final recommendation = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2.h, right: 12.w),
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: "#F38B3B".toColor(),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        '${index + 1}',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      recommendation,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#3E2723'.toColor(),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDeeperInsightsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: "#F38B3B".toColor().withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 32.w),
          Spacing.h(12),
          AutoTranslateText(
            'Want Deeper Insights',
            style: MyTextTheme.largeBCB
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                .merge(AppTypography.h2),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Chat with our expert face readers for personalized guidance and detailed analysis.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.h(16),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.astrologyServices);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: "#F38B3B".toColor(),
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              elevation: 0,
            ),
            child: AutoTranslateText(
              'Chat With Expert',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#F38B3B".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
