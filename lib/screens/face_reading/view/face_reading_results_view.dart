import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/face_reading_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/core/services/pdf_generator_service.dart';
import 'package:astrobharataiuser/data_model/pdf_metadata.dart';
import 'package:astrobharataiuser/data_model/pdf_section.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceReadingResultsView extends StatelessWidget {
  const FaceReadingResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FaceReadingData? result = Get.arguments?['result'];

    if (result == null) {
      return Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.h),
            child: const CommonHeader(
              title: 'Face Analysis',
              showSearch: false,
              showCart: false,
              showLanguage: false,
              showWallet: false,
            ),
          ),
          body: Center(
            child: AutoTranslateText(
              'No results found',
              style: MyTextTheme.mediumBCB.copyWith(color: '#3E2723'.toColor()),
            ),
          ),
        ),
      );
    }

    final overview = result.detailedAnalysis?.overview;
    final categories = result.detailedAnalysis?.categories;
    final features = result.detailedAnalysis?.features;
    final score = overview?.score ?? 0;
    final tags = overview?.tags ?? [];

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              CommonHeader(
                title: 'Your Face Analysis',
                subtitle: AutoTranslateText(
                  'AI-Powered Physiognomy reading',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF5F2221).withValues(alpha: 0.7),
                  ),
                ),
                customActions: [
                  IconButton(
                    icon: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: '#6F221E'.toColor(),
                      size: 22.w,
                    ),
                    onPressed: () => _exportToPdf(result),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.history,
                      color: '#6F221E'.toColor(),
                      size: 22.w,
                    ),
                    onPressed: () => Get.toNamed(AppRoutes.faceReadingHistory),
                  ),
                ],
              ),
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
      ),
    );
  }

  Widget _buildOverallScoreSection(
    FaceReadingData result,
    int score,
    List<String> tags,
  ) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              border: Border.all(color: "#F38B3B".toColor(), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                          color: "#F38B3B".toColor(),
                        ),
                      ),
                    )
                  : Container(
                      color: '#FFF2E8'.toColor(),
                      child: Icon(
                        Icons.person,
                        size: 50.w,
                        color: "#F38B3B".toColor(),
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
                    Icon(Icons.star, color: "#F38B3B".toColor(), size: 32.w),
                    Spacing.w(4),
                    AutoTranslateText(
                      '$score/100',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: "#F38B3B".toColor(),
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
                      "#F38B3B".toColor(),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: '#FFF2E8'.toColor(),
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color: "#F38B3B".toColor().withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16.w,
                            color: "#F38B3B".toColor(),
                          ),
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
    FaceReadingCategories? categories,
    FaceReadingData result,
  ) {
    if (categories == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: "#F38B3B".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Detailed Analysis',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
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
              color: Colors.black.withValues(alpha: 0.04),
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
              child: Icon(icon, color: "#F38B3B".toColor(), size: 24.w),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
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
                    color: "#F38B3B".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.w,
                  color: "#F38B3B".toColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacialFeaturesSection(
    FaceReadingFeatures? features,
    FaceReadingData result,
  ) {
    if (features == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.visibility, color: "#F38B3B".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Facial Features',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
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
              color: Colors.black.withValues(alpha: 0.04),
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
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                  color: "#F38B3B".toColor(),
                ),
              ],
            ),
            Spacing.h(4),
            Row(
              children: [
                Icon(Icons.star, size: 14.w, color: "#F38B3B".toColor()),
                Spacing.w(4),
                AutoTranslateText(
                  rating,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#F38B3B".toColor(),
                  ),
                ),
              ],
            ),
            Spacing.h(4),
            AutoTranslateText(
              text,
              style: MyTextTheme.smallBCN.copyWith(color: '#666666'.toColor()),
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
            color: "#F38B3B".toColor().withValues(alpha: 0.3),
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
            style: MyTextTheme.largeBCB
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                .merge(AppTypography.h2),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Chat with our expert face readers for personalized guidance and detailed analysis.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
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

  Future<void> _exportToPdf(FaceReadingData result) async {
    final overview = result.detailedAnalysis?.overview;
    final categories = result.detailedAnalysis?.categories;
    final features = result.detailedAnalysis?.features;
    final lists = result.detailedAnalysis?.lists;

    final List<PdfSection> sections = [];

    // 1. Summary Section
    if (result.summary != null && result.summary!.isNotEmpty) {
      sections.add(PdfSection(title: 'Summary', content: result.summary!));
    }

    // 2. Overall Analysis Section
    if (overview != null) {
      sections.add(
        PdfSection(
          title: 'Overall Analysis Score',
          content: 'Your overall face analysis score is ${overview.score}/100.',
          score: overview.score?.toDouble(),
          bulletPoints: overview.tags,
          type: PdfSectionType.bullet,
        ),
      );
    }

    if (result.overallReading != null && result.overallReading!.isNotEmpty) {
      sections.add(
        PdfSection(title: 'Direct Reading', content: result.overallReading!),
      );
    }

    // 3-7. Categories (Personality, Career, Love, Wealth, Health)
    final categoryItems = [
      {
        'title': 'Personality Traits',
        'type': 'Personality',
        'detail': categories?.personality,
      },
      {
        'title': 'Career & Success',
        'type': 'Career',
        'detail': categories?.career,
      },
      {
        'title': 'Love & Relationships',
        'type': 'Love',
        'detail': categories?.love,
      },
      {
        'title': 'Wealth Indicators',
        'type': 'Wealth',
        'detail': categories?.wealth,
      },
      {
        'title': 'Health & Vitality',
        'type': 'Health',
        'detail': categories?.health,
      },
    ];

    for (var item in categoryItems) {
      final detail = item['detail'] as FaceReadingCategoryDetail?;
      if (detail == null) continue;

      final title = item['title'] as String;
      sections.add(
        PdfSection(
          title: title,
          content:
              'Score: ${detail.score}/100\n\nKey Insight:\n${detail.description ?? ''}',
          score: detail.score?.toDouble(),
        ),
      );

      if (detail.keywords != null && detail.keywords!.isNotEmpty) {
        sections.add(
          PdfSection(
            title: '${item['type']} Characteristics',
            content: 'Core traits identified in this category:',
            bulletPoints: detail.keywords,
            type: PdfSectionType.bullet,
          ),
        );
      }

      // Include global lists in each category to match UI Detail Parity
      if (lists != null) {
        if (lists.strengths != null && lists.strengths!.isNotEmpty) {
          sections.add(
            PdfSection(
              title: 'Strengths',
              content: 'Positive qualities revealed:',
              bulletPoints: lists.strengths,
              type: PdfSectionType.bullet,
            ),
          );
        }
        if (lists.areasForGrowth != null && lists.areasForGrowth!.isNotEmpty) {
          sections.add(
            PdfSection(
              title: 'Areas For Growth',
              content: 'Potential for development:',
              bulletPoints: lists.areasForGrowth,
              type: PdfSectionType.bullet,
            ),
          );
        }
        if (lists.socialTraits != null && lists.socialTraits!.isNotEmpty) {
          sections.add(
            PdfSection(
              title: 'Social Traits',
              content: 'Interactions and relationships:',
              bulletPoints: lists.socialTraits,
              type: PdfSectionType.bullet,
            ),
          );
        }
        if (lists.recommendations != null &&
            lists.recommendations!.isNotEmpty) {
          sections.add(
            PdfSection(
              title: 'Recommendations',
              content: 'Actionable advice:',
              bulletPoints: lists.recommendations,
              type: PdfSectionType.bullet,
            ),
          );
        }
      }
    }

    // 8. Facial Features Detailed Analysis
    if (features != null) {
      sections.add(
        PdfSection(
          title: 'Facial Features Analysis',
          content:
              'A deep-dive into each individual facial feature and its psychological correspondence.',
          type: PdfSectionType.text,
        ),
      );

      final featureList = [
        {'title': 'Forehead', 'key': 'FOREHEAD', 'feature': features.forehead},
        {'title': 'Eyes', 'key': 'EYES', 'feature': features.eyes},
        {'title': 'Nose', 'key': 'NOSE', 'feature': features.nose},
        {'title': 'Mouth', 'key': 'MOUTH_LIPS', 'feature': features.mouth},
        {'title': 'Chin', 'key': 'CHIN_JAW', 'feature': features.chin},
        {
          'title': 'Face Shape',
          'key': 'FACE_SHAPE',
          'feature': features.faceShape,
        },
      ];

      for (var item in featureList) {
        final feature = item['feature'] as FaceReadingFeature?;
        if (feature == null) continue;

        final String title = item['title'] as String;
        final String key = item['key'] as String;

        final reading = result.readings.firstWhereOrNull(
          (r) => r.category == key,
        );

        String detailContent =
            'Rating: ${feature.rating}\nFinding: ${feature.text}';

        final rInterpretation = reading?.interpretation;
        if (rInterpretation != null) {
          detailContent +=
              '\n\nDetailed Interpretation:\n${rInterpretation.replaceAll('**', '')}';
        }

        final rIssue = reading?.issueDescription;
        if (reading?.hasIssue == true && rIssue != null) {
          detailContent += '\n\nAreas of Concern:\n$rIssue';
        }

        final rRemedy = reading?.remedy;
        if (rRemedy != null && rRemedy.isNotEmpty) {
          detailContent += '\n\nRemedy & Suggestions:\n$rRemedy';
        }

        sections.add(PdfSection(title: title, content: detailContent));
      }
    }

    // 9. Key Remedies (Global Summary)
    if (result.keyRemedies != null && result.keyRemedies!.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Summary of Remedies',
          content: 'Key remedial actions for overall balance:',
          bulletPoints: result.keyRemedies,
          type: PdfSectionType.bullet,
        ),
      );
    }

    // Get user metadata
    String? userName;
    if (Get.isRegistered<UserDashboardController>()) {
      userName = Get.find<UserDashboardController>().userName.value;
    }

    /*
    showDialog(
      context: Get.context!,
      builder: (context) => PdfLanguageSelectionDialog(
        onLanguageSelected: (language) async {
          await PdfGeneratorService.generateAstrologyReport(
            title: 'Face Reading Analysis',
            sections: sections,
            metadata: PdfMetadata(
              userName: userName,
              generatedAt: DateTime.now(),
              reportType: PdfReportType.faceReading,
            ),
            languageCode: language.code,
          );
        },
      ),
    );
    */

    // English-only for now (Direct Generation)
    await PdfGeneratorService.generateAstrologyReport(
      title: 'Face Reading Analysis',
      sections: sections,
      metadata: PdfMetadata(
        userName: userName,
        generatedAt: DateTime.now(),
        reportType: PdfReportType.faceReading,
      ),
      languageCode: 'en',
    );
  }
}
