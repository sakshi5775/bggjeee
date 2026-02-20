import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/handwriting_astrology_model.dart';
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

class HandwritingAstrologyResultsView extends StatelessWidget {
  const HandwritingAstrologyResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HandwritingData? result = Get.arguments?['result'];

    if (result == null) {
      return Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.h),
            child: const CommonHeader(
              title: 'Handwriting Analysis',
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

    final overview = result.overview;
    final categories = result.categories;
    final features = result.features;
    final lists = result.lists;
    final score = overview?.score ?? 0;
    final tags = overview?.tags ?? [];

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: 'Your Handwriting Analysis',
              subtitle: AutoTranslateText(
                'AI-Powered Graphology reading',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF5F2221).withValues(alpha: 0.7),
                ),
              ),
              showSearch: false,
              showCart: false,
              showLanguage: false,
              showWallet: false,
              customActions: [
                IconButton(
                  onPressed: () => _exportToPdf(result),
                  icon: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: '#6F221E'.toColor(),
                    size: 22.w,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.history,
                    color: '#6F221E'.toColor(),
                    size: 22.w,
                  ),
                  onPressed: () =>
                      Get.toNamed(AppRoutes.handwritingAstrologyHistory),
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
                    // Summary Section
                    if (result.summary != null) ...[
                      _buildSummarySection(result.summary!),
                      Spacing.h(24),
                    ],
                    // Detailed Analysis Section
                    _buildDetailedAnalysisSection(categories, result),
                    Spacing.h(24),
                    // Handwriting Features Section
                    _buildHandwritingFeaturesSection(features, result),
                    Spacing.h(24),
                    // Lists Section (Strengths, Areas for Growth, etc.)
                    if (lists != null) ...[
                      _buildListsSection(lists),
                      Spacing.h(24),
                    ],
                    // User Input Section
                    if (result.userInput != null) ...[
                      _buildUserInputSection(result.userInput!),
                      Spacing.h(24),
                    ],
                    // Images Section
                    if (result.imageUrls != null &&
                        result.imageUrls!.isNotEmpty) ...[
                      _buildImagesSection(result.imageUrls!),
                      Spacing.h(24),
                    ],
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

  Widget _buildOverallScoreSection(
    HandwritingData result,
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
          // Image preview
          if (result.imageUrls != null && result.imageUrls!.isNotEmpty)
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
                child: Image.network(
                  result.imageUrls!.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: '#FFF2E8'.toColor(),
                    child: Icon(
                      Icons.edit_note,
                      size: 50.w,
                      color: "#F38B3B".toColor(),
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: '#FFF2E8'.toColor(),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.edit_note,
                size: 50.w,
                color: "#F38B3B".toColor(),
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

  Widget _buildSummarySection(String summary) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                Icon(Icons.summarize, color: "#F38B3B".toColor(), size: 20.w),
                Spacing.w(8),
                AutoTranslateText(
                  'Summary',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(12),
            AutoTranslateText(
              summary,
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#3E2723'.toColor(),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAnalysisSection(
    HandwritingCategories? categories,
    HandwritingData result,
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
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          if (categories.emotionalIntelligence != null)
            _buildCategoryCard(
              title: 'Emotional Intelligence',
              icon: Icons.psychology,
              category: categories.emotionalIntelligence!,
            ),
          Spacing.h(12),
          if (categories.ambition != null)
            _buildCategoryCard(
              title: 'Ambition',
              icon: Icons.trending_up,
              category: categories.ambition!,
            ),
          Spacing.h(12),
          if (categories.communication != null)
            _buildCategoryCard(
              title: 'Communication',
              icon: Icons.chat_bubble,
              category: categories.communication!,
            ),
          Spacing.h(12),
          if (categories.creativity != null)
            _buildCategoryCard(
              title: 'Creativity',
              icon: Icons.lightbulb,
              category: categories.creativity!,
            ),
          Spacing.h(12),
          if (categories.stability != null)
            _buildCategoryCard(
              title: 'Stability',
              icon: Icons.balance,
              category: categories.stability!,
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required HandwritingCategoryDetail category,
  }) {
    return InkWell(
      onTap: () => _showCategoryDetails(title, icon, category),
      borderRadius: BorderRadius.circular(12.r),
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
                Spacing.h(4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                  color: "#F38B3B".toColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryDetails(
    String title,
    IconData icon,
    HandwritingCategoryDetail category,
  ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: '#FFF2E8'.toColor(),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: "#F38B3B".toColor(), size: 24.w),
                    ),
                    Spacing.w(12),
                    Expanded(
                      child: AutoTranslateText(
                        title,
                        style: MyTextTheme.largeBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: '#666666'.toColor()),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                Spacing.h(20),
                // Score
                Row(
                  children: [
                    Icon(Icons.star, color: "#F38B3B".toColor(), size: 24.w),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Score: ${category.score ?? 0}/100',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: "#F38B3B".toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(16),
                // Title
                if (category.title != null && category.title!.isNotEmpty) ...[
                  AutoTranslateText(
                    category.title!,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.h(12),
                ],
                // Description
                if (category.description != null &&
                    category.description!.isNotEmpty) ...[
                  AutoTranslateText(
                    'Description',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    category.description!,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: '#666666'.toColor(),
                      height: 1.6,
                    ),
                  ),
                  Spacing.h(16),
                ],
                // Keywords
                if (category.keywords != null &&
                    category.keywords!.isNotEmpty) ...[
                  AutoTranslateText(
                    'Keywords',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.h(8),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: category.keywords!.map((keyword) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: '#FFF2E8'.toColor(),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: "#F38B3B".toColor().withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.w,
                              color: "#F38B3B".toColor(),
                            ),
                            Spacing.w(6),
                            AutoTranslateText(
                              keyword,
                              style: MyTextTheme.smallBCN.copyWith(
                                color: '#3E2723'.toColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandwritingFeaturesSection(
    HandwritingFeatures? features,
    HandwritingData result,
  ) {
    if (features == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit, color: "#F38B3B".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Handwriting Features',
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Letter Size',
                  features.letterSize?.rating ?? 'N/A',
                  features.letterSize?.text ?? '',
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  'Slant',
                  features.slant?.rating ?? 'N/A',
                  features.slant?.text ?? '',
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Pressure',
                  features.pressure?.rating ?? 'N/A',
                  features.pressure?.text ?? '',
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  'Spacing',
                  features.spacing?.rating ?? 'N/A',
                  features.spacing?.text ?? '',
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Baseline',
                  features.baseline?.rating ?? 'N/A',
                  features.baseline?.text ?? '',
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  'Zones',
                  features.zones?.rating ?? 'N/A',
                  features.zones?.text ?? '',
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Loops',
                  features.loops?.rating ?? 'N/A',
                  features.loops?.text ?? '',
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  'Connections',
                  features.connections?.rating ?? 'N/A',
                  features.connections?.text ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String rating, String text) {
    return InkWell(
      onTap: () => _showFeatureDetails(title, rating, text),
      borderRadius: BorderRadius.circular(12.r),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(4),
            Row(
              children: [
                Icon(Icons.star, size: 14.w, color: "#F38B3B".toColor()),
                Spacing.w(4),
                Flexible(
                  child: AutoTranslateText(
                    rating,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#F38B3B".toColor(),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
            Spacing.h(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.w,
                  color: "#F38B3B".toColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureDetails(String title, String rating, String text) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.7,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: '#FFF2E8'.toColor(),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit_note,
                        color: "#F38B3B".toColor(),
                        size: 24.w,
                      ),
                    ),
                    Spacing.w(12),
                    Expanded(
                      child: AutoTranslateText(
                        title,
                        style: MyTextTheme.largeBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: '#666666'.toColor()),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                Spacing.h(20),
                // Rating
                Row(
                  children: [
                    Icon(Icons.star, color: "#F38B3B".toColor(), size: 24.w),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Rating: $rating',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: "#F38B3B".toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(16),
                // Description
                AutoTranslateText(
                  'Description',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacing.h(8),
                AutoTranslateText(
                  text,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#666666'.toColor(),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListsSection(HandwritingLists lists) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lists.strengths != null && lists.strengths!.isNotEmpty) ...[
            _buildListCard(
              'Strengths',
              Icons.check_circle,
              lists.strengths!,
              Colors.green,
            ),
            Spacing.h(12),
          ],
          if (lists.areasForGrowth != null &&
              lists.areasForGrowth!.isNotEmpty) ...[
            _buildListCard(
              'Areas for Growth',
              Icons.trending_up,
              lists.areasForGrowth!,
              "#F38B3B".toColor(),
            ),
            Spacing.h(12),
          ],
          if (lists.careerAptitudes != null &&
              lists.careerAptitudes!.isNotEmpty) ...[
            _buildListCard(
              'Career Aptitudes',
              Icons.work,
              lists.careerAptitudes!,
              Colors.blue,
            ),
            Spacing.h(12),
          ],
          if (lists.recommendations != null &&
              lists.recommendations!.isNotEmpty) ...[
            _buildListCard(
              'Recommendations',
              Icons.lightbulb,
              lists.recommendations!,
              Colors.purple,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListCard(
    String title,
    IconData icon,
    List<String> items,
    Color color,
  ) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 6.w, color: color),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      item,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: '#3E2723'.toColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInputSection(HandwritingUserInput userInput) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                Icon(Icons.person, color: "#F38B3B".toColor(), size: 20.w),
                Spacing.w(8),
                AutoTranslateText(
                  'Your Information',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(16),
            if (userInput.name != null && userInput.name!.isNotEmpty)
              _buildInfoRow('Name', userInput.name!),
            if (userInput.dateOfBirth != null &&
                userInput.dateOfBirth!.isNotEmpty)
              _buildInfoRow('Date of Birth', userInput.dateOfBirth!),
            if (userInput.gender != null && userInput.gender!.isNotEmpty)
              _buildInfoRow('Gender', userInput.gender!),
            if (userInput.language != null && userInput.language!.isNotEmpty)
              _buildInfoRow('Language', userInput.language!),
            if (userInput.additionalNotes != null &&
                userInput.additionalNotes!.isNotEmpty) ...[
              Spacing.h(8),
              AutoTranslateText(
                'Additional Notes',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.h(4),
              AutoTranslateText(
                userInput.additionalNotes!,
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#666666'.toColor(),
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: AutoTranslateText(
              '$label:',
              style: MyTextTheme.mediumBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.mediumBCN.copyWith(color: '#666666'.toColor()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection(List<String> imageUrls) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                Icon(Icons.image, color: "#F38B3B".toColor(), size: 20.w),
                Spacing.w(8),
                AutoTranslateText(
                  'Handwriting Images',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(16),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: imageUrls.map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    url,
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100.w,
                        height: 100.w,
                        color: '#E8E8E8'.toColor(),
                        child: Icon(
                          Icons.broken_image,
                          color: '#999999'.toColor(),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
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
            style: MyTextTheme.largeBCB.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Chat with our expert graphologists for personalized guidance and detailed analysis.',
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

  Future<void> _exportToPdf(HandwritingData result) async {
    final overview = result.overview;
    final categories = result.categories;
    final List<PdfSection> sections = [];

    // 1. Overall Score & Reading
    if (overview != null) {
      sections.add(
        PdfSection(
          title: 'Overall Analysis',
          content: 'Your handwriting analysis score is ${overview.score}/100.',
          score: overview.score?.toDouble(),
          bulletPoints: overview.tags,
          type: PdfSectionType.bullet,
        ),
      );
    }

    // 2. Summary
    if (result.summary != null) {
      sections.add(PdfSection(title: 'Summary', content: result.summary!));
    }

    // 3. Detailed Categories
    if (categories != null) {
      final Map<String, HandwritingCategoryDetail?> allCats = {
        'Emotional Intelligence': categories.emotionalIntelligence,
        'Ambition': categories.ambition,
        'Communication': categories.communication,
        'Creativity': categories.creativity,
        'Stability': categories.stability,
      };

      for (var entry in allCats.entries) {
        final cat = entry.value;
        if (cat != null) {
          sections.add(
            PdfSection(
              title: entry.key,
              content: cat.description ?? '',
              score: cat.score?.toDouble(),
              bulletPoints: cat.keywords,
              type: PdfSectionType.bullet,
            ),
          );
        }
      }
    }

    // 4. Handwriting Features
    final features = result.features;
    if (features != null) {
      final Map<String, HandwritingFeature?> allFeatures = {
        'Letter Size': features.letterSize,
        'Slant': features.slant,
        'Pressure': features.pressure,
        'Spacing': features.spacing,
        'Baseline': features.baseline,
        'Zones': features.zones,
        'Loops': features.loops,
        'Connections': features.connections,
      };

      for (var entry in allFeatures.entries) {
        final feature = entry.value;
        if (feature != null) {
          sections.add(
            PdfSection(
              title: entry.key,
              content: feature.text ?? '',
              bulletPoints: feature.rating != null
                  ? ['Rating: ${feature.rating}']
                  : null,
              type: PdfSectionType.bullet,
            ),
          );
        }
      }
    }

    // 5. Strengths & Areas for Growth
    if (result.lists?.strengths != null &&
        result.lists!.strengths!.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Key Strengths',
          content: 'Positive traits identified from your handwriting:',
          bulletPoints: result.lists!.strengths,
          type: PdfSectionType.bullet,
        ),
      );
    }
    if (result.lists?.areasForGrowth != null &&
        result.lists!.areasForGrowth!.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Areas for Growth',
          content: 'Potential areas for personal development:',
          bulletPoints: result.lists!.areasForGrowth,
          type: PdfSectionType.bullet,
        ),
      );
    }

    // 6. Career & Recommendations
    if (result.lists?.careerAptitudes != null &&
        result.lists!.careerAptitudes!.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Career Aptitudes',
          content: 'Professional fields that align with your personality:',
          bulletPoints: result.lists!.careerAptitudes,
          type: PdfSectionType.bullet,
        ),
      );
    }
    if (result.lists?.recommendations != null &&
        result.lists!.recommendations!.isNotEmpty) {
      sections.add(
        PdfSection(
          title: 'Recommendations',
          content: 'Suggested next steps based on your profile:',
          bulletPoints: result.lists!.recommendations,
          type: PdfSectionType.bullet,
        ),
      );
    }

    // 7. Analysis Context
    if (result.userInput != null) {
      final input = result.userInput!;
      final List<String> inputDetails = [];
      if (input.gender != null) inputDetails.add('Gender: ${input.gender}');
      if (input.language != null)
        inputDetails.add('Language: ${input.language}');
      if (input.additionalNotes != null && input.additionalNotes!.isNotEmpty) {
        inputDetails.add('Additional Notes: ${input.additionalNotes}');
      }

      if (inputDetails.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Analysis Context',
            content:
                'The analysis was performed with the following user context:',
            bulletPoints: inputDetails,
            type: PdfSectionType.bullet,
          ),
        );
      }
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
            title: 'Handwriting Analysis Report',
            sections: sections,
            metadata: PdfMetadata(
              userName: userName,
              generatedAt: DateTime.now(),
              reportType: PdfReportType.handwriting,
            ),
            languageCode: language.code,
          );
        },
      ),
    );
    */

    // English-only for now (Direct Generation)
    await PdfGeneratorService.generateAstrologyReport(
      title: 'Handwriting Analysis Report',
      sections: sections,
      metadata: PdfMetadata(
        userName: userName,
        generatedAt: DateTime.now(),
        reportType: PdfReportType.handwriting,
      ),
      languageCode: 'en',
    );
  }
}

