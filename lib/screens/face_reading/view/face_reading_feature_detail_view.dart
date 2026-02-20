import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/face_reading_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceReadingFeatureDetailView extends StatelessWidget {
  const FaceReadingFeatureDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = Get.arguments?['title'] ?? '';
    final String rating = Get.arguments?['rating'] ?? '';
    final String text = Get.arguments?['text'] ?? '';
    final String categoryKey = Get.arguments?['categoryKey'] ?? '';
    final FaceReadingData? result = Get.arguments?['result'];

    // Find the detailed reading for this feature
    FaceReadingCategory? featureReading;
    if (result != null && result.readings.isNotEmpty) {
      featureReading = result.readings.firstWhere(
        (reading) => reading.category == categoryKey,
        orElse: () => FaceReadingCategory(category: categoryKey),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: title,
              subtitle: AutoTranslateText(
                'AI-Powered Physiognomy reading',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0x666F221E),
                ),
              ),
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Rating
                    _buildHeaderSection(title, rating, text),
                    Spacing.h(24),
                    // Detailed Interpretation
                    if (featureReading?.interpretation != null)
                      _buildInterpretationCard(featureReading!.interpretation!),
                    if (featureReading?.interpretation != null) Spacing.h(16),
                    // Issues (if any)
                    if (featureReading?.hasIssue == true &&
                        featureReading?.issueDescription != null)
                      _buildIssuesCard(featureReading!.issueDescription!),
                    if (featureReading?.hasIssue == true &&
                        featureReading?.issueDescription != null)
                      Spacing.h(16),
                    // Remedy (if any)
                    if (featureReading?.remedy != null &&
                        featureReading!.remedy!.isNotEmpty)
                      _buildRemedyCard(featureReading.remedy!),
                    if (featureReading?.remedy != null &&
                        featureReading!.remedy!.isNotEmpty)
                      Spacing.h(16),
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

  Widget _buildHeaderSection(String title, String rating, String text) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.visibility, color: "#F38B3B".toColor(), size: 32.w),
              Spacing.w(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      title,
                      style: MyTextTheme.largeBCB
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h2),
                    ),
                    Spacing.h(8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: "#F38B3B".toColor(),
                          size: 24.w,
                        ),
                        Spacing.w(8),
                        AutoTranslateText(
                          rating,
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
          Spacing.h(16),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
            ),
            child: AutoTranslateText(
              text,
              style: MyTextTheme.mediumBCN
                  .copyWith(color: '#3E2723'.toColor(), height: 1.5)
                  .merge(AppTypography.body1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationCard(String interpretation) {
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
                'Detailed Interpretation',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          // Parse and display the interpretation text (may contain markdown-like formatting)
          ...interpretation.split('\n\n').map((paragraph) {
            if (paragraph.trim().isEmpty) return const SizedBox.shrink();

            // Check if paragraph is a heading (starts with **)
            final isHeading =
                paragraph.trim().startsWith('**') &&
                paragraph.trim().endsWith('**');

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AutoTranslateText(
                paragraph.trim().replaceAll('**', ''),
                style: isHeading
                    ? MyTextTheme.mediumBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      )
                    : MyTextTheme.mediumBCN
                          .copyWith(color: '#3E2723'.toColor(), height: 1.6)
                          .merge(AppTypography.body1),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildIssuesCard(String issueDescription) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#F38B3B".toColor().withOpacity(0.3),
          width: 1,
        ),
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
              Icon(
                Icons.warning_amber_rounded,
                color: "#F38B3B".toColor(),
                size: 20.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Areas of Concern',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            issueDescription,
            style: MyTextTheme.mediumBCN
                .copyWith(color: '#3E2723'.toColor(), height: 1.6)
                .merge(AppTypography.body1),
          ),
        ],
      ),
    );
  }

  Widget _buildRemedyCard(String remedy) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
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
              Icon(Icons.healing, color: Colors.green, size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'Remedy & Suggestions',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            remedy,
            style: MyTextTheme.mediumBCN
                .copyWith(color: '#3E2723'.toColor(), height: 1.6)
                .merge(AppTypography.body1),
          ),
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
