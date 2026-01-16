import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/face_reading_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceReadingResultsView extends StatelessWidget {
  const FaceReadingResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FaceReadingData? result = Get.arguments?['result'];

    if (result == null) {
      return Scaffold(
        backgroundColor: '#F7EFBD'.toColor(),
        appBar: AppBar(
          backgroundColor: '#8B4513'.toColor(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const AutoTranslateText(
            'Face Analysis',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: AutoTranslateText(
            'No results found',
            style: MyTextTheme.mediumBCB.copyWith(color: '#3E2723'.toColor()),
          ),
        ),
      );
    }

    final overview = result.detailedAnalysis?.overview;
    final categories = result.detailedAnalysis?.categories;
    final features = result.detailedAnalysis?.features;
    final score = overview?.score ?? 0;
    final tags = overview?.tags ?? [];

    return Scaffold(
      backgroundColor: '#F7EFBD'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            _buildTopBar(),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Analysis Score Section
                    _buildOverallScoreSection(result, score, tags),
                    Spacing.h(24),
                    // Detailed Analysis Section
                    _buildDetailedAnalysisSection(categories, result),
                    Spacing.h(24),
                    // Facial Features Section
                    _buildFacialFeaturesSection(features, result),
                    Spacing.h(24),
                    // Want Deeper Insights Section
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

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: '#68171E'.toColor(), // Dark red/maroon header
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.templeGold, size: 24.w),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Your Face Analysis',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: AppColors.templeGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoTranslateText(
                  'AI-Powered Physiognomy reading',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: AppColors.templeGold.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.history, color: AppColors.templeGold, size: 24.w),
            onPressed: () {
              Get.toNamed(AppRoutes.faceReadingHistory);
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: AppColors.templeGold, size: 24.w),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.download, color: AppColors.templeGold, size: 24.w),
            onPressed: () {
              // TODO: Implement download functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScoreSection(
      FaceReadingData result, int score, List<String> tags) {
    return Container(
      margin: EdgeInsets.all(16.w),
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
      child: Row(
        children: [
          // Profile Picture - Square shape
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.deepOrange, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: result.imageUrl != null
                  ? Image.network(
                      result.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: '#FFF2E8'.toColor(),
                        child: Icon(
                          Icons.person,
                          size: 50.w,
                          color: AppColors.deepOrange,
                        ),
                      ),
                    )
                  : Container(
                      color: '#FFF2E8'.toColor(),
                      child: Icon(
                        Icons.person,
                        size: 50.w,
                        color: AppColors.deepOrange,
                      ),
                    ),
            ),
          ),
          Spacing.w(20),
          // Score and Tags
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Overall Analysis Score',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#3E2723'.toColor(),
                  ),
                ),
                Spacing.h(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: AppColors.deepOrange, size: 32.w),
                    Spacing.w(4),
                    AutoTranslateText(
                      '$score/100',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: AppColors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: '#E8E8E8'.toColor(),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.deepOrange,
                    ),
                    minHeight: 10.h,
                  ),
                ),
                Spacing.h(12),
                // Tags
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: tags.take(3).map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: '#FFF2E8'.toColor(),
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(color: AppColors.deepOrange.withOpacity(0.2), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 16.w, color: AppColors.deepOrange),
                          Spacing.w(6),
                          AutoTranslateText(
                            tag,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: '#3E2723'.toColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysisSection(
      FaceReadingCategories? categories, FaceReadingData result) {
    if (categories == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: AppColors.deepOrange, size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Detailed Analysis',
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h2),
              ),
            ],
          ),
          Spacing.h(16),
          // Personality Traits Card
          if (categories.personality != null)
            _buildCategoryCard(
              title: 'Personality Traits',
              icon: Icons.person,
              category: categories.personality!,
              categoryType: 'personality',
              result: result,
            ),
          Spacing.h(12),
          // Career & Success Card
          if (categories.career != null)
            _buildCategoryCard(
              title: 'Career & Success',
              icon: Icons.business_center,
              category: categories.career!,
              categoryType: 'career',
              result: result,
            ),
          Spacing.h(12),
          // Love & Relationships Card
          if (categories.love != null)
            _buildCategoryCard(
              title: 'Love & Relationships',
              icon: Icons.favorite,
              category: categories.love!,
              categoryType: 'love',
              result: result,
            ),
          Spacing.h(12),
          // Wealth Indicators Card
          if (categories.wealth != null)
            _buildCategoryCard(
              title: 'Wealth Indicators',
              icon: Icons.trending_up,
              category: categories.wealth!,
              categoryType: 'wealth',
              result: result,
            ),
          Spacing.h(12),
          // Health & Vitality Card
          if (categories.health != null)
            _buildCategoryCard(
              title: 'Health & Vitality',
              icon: Icons.health_and_safety,
              category: categories.health!,
              categoryType: 'health',
              result: result,
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required FaceReadingCategoryDetail category,
    required String categoryType,
    required FaceReadingData result,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoutes.faceReadingCategoryDetail,
          arguments: {
            'categoryType': categoryType,
            'category': category,
            'result': result,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: '#FFF2E8'.toColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.deepOrange, size: 24.w),
            ),
            Spacing.w(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    category.description ?? '',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: '#666666'.toColor(),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(8),
                  // Keywords
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: (category.keywords ?? []).take(3).map((keyword) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: '#FFF2E8'.toColor(),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: AutoTranslateText(
                          keyword,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: '#3E2723'.toColor(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                AutoTranslateText(
                  '${category.score ?? 0}',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16.w, color: AppColors.deepOrange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacialFeaturesSection(FaceReadingFeatures? features, FaceReadingData result) {
    if (features == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.visibility, color: AppColors.deepOrange, size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Facial Features',
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h2),
              ),
            ],
          ),
          Spacing.h(16),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Forehead',
                  features.forehead?.rating ?? 'N/A',
                  features.forehead?.text ?? '',
                  'FOREHEAD',
                  result,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  'Eyes',
                  features.eyes?.rating ?? 'N/A',
                  features.eyes?.text ?? '',
                  'EYES',
                  result,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Nose',
                  features.nose?.rating ?? 'N/A',
                  features.nose?.text ?? '',
                  'NOSE',
                  result,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  'Mouth',
                  features.mouth?.rating ?? 'N/A',
                  features.mouth?.text ?? '',
                  'MOUTH_LIPS',
                  result,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Chin',
                  features.chin?.rating ?? 'N/A',
                  features.chin?.text ?? '',
                  'CHIN_JAW',
                  result,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  'Face Shape',
                  features.faceShape?.rating ?? 'N/A',
                  features.faceShape?.text ?? '',
                  'FACE_SHAPE',
                  result,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String rating,
    String text,
    String categoryKey,
    FaceReadingData result,
  ) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoutes.faceReadingFeatureDetail,
          arguments: {
            'title': title,
            'rating': rating,
            'text': text,
            'categoryKey': categoryKey,
            'result': result,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AutoTranslateText(
                    title,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14.w, color: AppColors.deepOrange),
              ],
            ),
            Spacing.h(4),
            Row(
              children: [
                Icon(Icons.star, size: 14.w, color: AppColors.deepOrange),
                Spacing.w(4),
                AutoTranslateText(
                  rating,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: AppColors.deepOrange,
                  ),
                ),
              ],
            ),
            Spacing.h(4),
            AutoTranslateText(
              text,
              style: MyTextTheme.smallBCN.copyWith(
                color: '#666666'.toColor(),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
            color: AppColors.deepOrange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.star, color: Colors.white, size: 32.w),
          Spacing.h(12),
          AutoTranslateText(
            'Want Deeper Insights',
            style: MyTextTheme.largeBCB.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
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
              foregroundColor: AppColors.deepOrange,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              elevation: 0,
            ),
            child: AutoTranslateText(
              'Chat With Expert',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

