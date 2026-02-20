import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NavtaraAnalyzeTab extends StatelessWidget {
  final NavtaraController controller;
  const NavtaraAnalyzeTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final maroon = Color(0xFF6F221E);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalyzeForm(maroon),
          Spacing.h(20),
          Obx(() {
            // Loader is handled by Dialog

            final analysis = controller.analysis.value;
            if (analysis == null) {
              return Center(
                child: AutoTranslateText(
                  'No analysis generated yet. Fill the form above.',
                  style: MyTextTheme.smallBCN,
                ),
              );
            }
            return _buildAnalysisResult(analysis, maroon);
          }),
        ],
      ),
    );
  }

  Widget _buildAnalyzeForm(Color maroon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: maroon.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Analyze Personal Predictions',
            style: MyTextTheme.mediumBCB.copyWith(color: maroon),
          ),
          Spacing.h(12),

          // Question
          AutoTranslateText(
            'Your Question (optional)',
            style: MyTextTheme.smallBCB,
          ),
          Spacing.h(8),
          TextField(
            controller: controller.questionController,
            decoration: _inputDecoration(
              'Enter your question (optional)',
              maroon,
            ),
            maxLines: 2,
          ),
          Spacing.h(16),

          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              SizedBox(
                width: 150.w,
                child: _buildActionButton(
                  'GENERAL',
                  'General Analysis',
                  Icons.auto_awesome,
                  maroon,
                ),
              ),
              SizedBox(
                width: 150.w,
                child: _buildActionButton(
                  'TRANSIT',
                  'Transit Analysis',
                  Icons.trending_up,
                  maroon,
                ),
              ),
              SizedBox(
                width: 150.w,
                child: _buildActionButton(
                  'TIMING',
                  'Timing Analysis',
                  Icons.access_time,
                  maroon,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, Color maroon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: MyTextTheme.smallBCN.copyWith(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: maroon.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: maroon.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: maroon),
      ),
      filled: true,
      fillColor: maroon.withOpacity(0.02),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    );
  }

  Widget _buildActionButton(
    String type,
    String label,
    IconData icon,
    Color maroon,
  ) {
    return GestureDetector(
      onTap: () => controller.analyzeSpecific(type),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16.w),
            Spacing.w(8),
            AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResult(NavtaraAnalysis analysis, Color maroon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Summary', analysis.prediction.summary, maroon),
        Spacing.h(16),
        _buildInfoCard(
          'Detailed Analysis',
          analysis.prediction.detailedAnalysis,
          maroon,
        ),
        Spacing.h(16),
        _buildBulletList(
          'Strength Areas',
          analysis.prediction.strengthAreas,
          Colors.green,
          maroon,
        ),
        Spacing.h(16),
        _buildBulletList(
          'Challenge Areas',
          analysis.prediction.challengeAreas,
          Colors.red,
          maroon,
        ),
        Spacing.h(16),
        _buildRemediesSection(analysis.remedies, maroon),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content, Color maroon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: maroon.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(color: maroon),
          ),
          Spacing.h(8),
          AutoTranslateText(
            content,
            style: MyTextTheme.smallBCN.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletList(
    String title,
    List<String> items,
    Color bulletColor,
    Color maroon,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: maroon.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(color: maroon),
          ),
          Spacing.h(8),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Icon(Icons.circle, size: 6.w, color: bulletColor),
                  ),
                  Spacing.w(10),
                  Expanded(
                    child: AutoTranslateText(
                      item,
                      style: MyTextTheme.smallBCN.copyWith(height: 1.4),
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

  Widget _buildRemediesSection(NavtaraRemedies remedies, Color maroon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Recommended Remedies',
          style: MyTextTheme.mediumBCB.copyWith(color: maroon),
        ),
        Spacing.h(12),
        if (remedies.mantras.isNotEmpty)
          _buildBulletList('Mantras', remedies.mantras, Colors.orange, maroon),
        if (remedies.mantras.isNotEmpty) Spacing.h(12),
        if (remedies.charities.isNotEmpty)
          _buildBulletList(
            'Charities',
            remedies.charities,
            Colors.blue,
            maroon,
          ),
      ],
    );
  }
}
