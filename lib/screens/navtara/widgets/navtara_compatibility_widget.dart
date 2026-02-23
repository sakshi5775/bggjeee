import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NavtaraCompatibilityWidget extends StatefulWidget {
  final NavtaraController controller;
  const NavtaraCompatibilityWidget({super.key, required this.controller});

  @override
  State<NavtaraCompatibilityWidget> createState() =>
      _NavtaraCompatibilityWidgetState();
}

class _NavtaraCompatibilityWidgetState
    extends State<NavtaraCompatibilityWidget> {
  int _selectedRemedyTab = 0;

  @override
  void initState() {
    super.initState();
    // Fetch data if not already present
    if (widget.controller.compatibility.value == null) {
      widget.controller.checkCompatibility();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final compat = widget.controller.compatibility.value;
      if (compat == null) {
        return Center(
          child: AutoTranslateText(
            'Compatibility analysis unavailable.',
            style: MyTextTheme.mediumBCN,
          ),
        );
      }

      final analysis = compat.compatibilityAnalysis;

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildScoreCard(analysis),
            Spacing.h(16),
            _buildMappingCard(
              compat.person1.name,
              compat.person2.name,
              analysis.person1ToPerson2,
            ),
            Spacing.h(16),
            _buildMappingCard(
              compat.person2.name,
              compat.person1.name,
              analysis.person2ToPerson1,
            ),
            Spacing.h(20),
            _buildSection('Strengths', analysis.strengths, Colors.green),
            Spacing.h(16),
            _buildSection('Challenges', analysis.challenges, Colors.red),
            Spacing.h(20),
            _buildAdviceCard(analysis.advice),
            Spacing.h(20),
            _buildRemediesSection(compat.remedies),
          ],
        ),
      );
    });
  }

  Widget _buildScoreCard(CompatibilityAnalysis analysis) {
    final maroon = "#6F221E".toColor();
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: maroon.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          AutoTranslateText(
            'Compatibility Score',
            style: MyTextTheme.mediumBCB.copyWith(color: maroon),
          ),
          Spacing.h(12),
          Text(
            '${analysis.compatibilityScore.toStringAsFixed(1)}%',
            style: MyTextTheme.largeBCB.copyWith(
              fontSize: 48.sp,
              color: AppColors.deepOrange,
            ),
          ),
          AutoTranslateText(
            analysis.compatibilityLevel,
            style: MyTextTheme.mediumBCB.copyWith(color: maroon),
          ),
          Spacing.h(8),
          AutoTranslateText(
            analysis.mutualHarmony,
            style: MyTextTheme.smallBCN,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMappingCard(
    String fromName,
    String toName,
    CompatibilityCategory category,
  ) {
    final maroon = "#6F221E".toColor();
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: maroon.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            '$fromName to $toName',
            style: MyTextTheme.smallBCB.copyWith(color: AppColors.deepOrange),
          ),
          Spacing.h(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    category.category,
                    style: MyTextTheme.mediumBCB,
                  ),
                  AutoTranslateText(
                    category.nature,
                    style: MyTextTheme.smallBCN,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getFavorColor(
                    category.favorability,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AutoTranslateText(
                  'Favorability: ${category.favorability}%',
                  style: TextStyle(
                    color: _getFavorColor(category.favorability),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(color: color),
          ),
          Spacing.h(8),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, size: 16.w, color: color),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(item, style: MyTextTheme.smallBCN),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard(String advice) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.white),
              Spacing.w(8),
              AutoTranslateText(
                'Advice',
                style: MyTextTheme.mediumBCB.copyWith(color: Colors.white),
              ),
            ],
          ),
          Spacing.h(8),
          AutoTranslateText(
            advice,
            style: MyTextTheme.smallBCN.copyWith(
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemediesSection(NavtaraRemedies remedies) {
    final remedyTabs = ['Mantras', 'Charities', 'Colors', 'Behaviors'];
    final maroon = "#6F221E".toColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Remedies',
          style: MyTextTheme.mediumBCB.copyWith(color: maroon),
        ),
        Spacing.h(12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(remedyTabs.length, (index) {
              final isSelected = _selectedRemedyTab == index;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: AutoTranslateText(remedyTabs[index]),
                  selected: isSelected,
                  onSelected: (s) => setState(() => _selectedRemedyTab = index),
                  selectedColor: AppColors.deepOrange,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : maroon,
                  ),
                ),
              );
            }),
          ),
        ),
        Spacing.h(12),
        _buildRemedyContent(remedies),
      ],
    );
  }

  Widget _buildRemedyContent(NavtaraRemedies remedies) {
    List<String> items = [];
    switch (_selectedRemedyTab) {
      case 0:
        items = remedies.mantras;
        break;
      case 1:
        items = remedies.charities;
        break;
      case 2:
        items = remedies.colors;
        break;
      case 3:
        items = remedies.behaviors;
        break;
    }

    if (items.isEmpty)
      return const AutoTranslateText(
        'No remedies recommended for this category.',
      );

    return Column(
      children: items.map((item) => _buildRemedyItem(item)).toList(),
    );
  }

  Widget _buildRemedyItem(String item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.deepOrange, size: 16),
          Spacing.w(8),
          Expanded(child: AutoTranslateText(item, style: MyTextTheme.smallBCN)),
        ],
      ),
    );
  }

  Color _getFavorColor(int f) {
    if (f >= 70) return Colors.green;
    if (f >= 40) return Colors.orange;
    return Colors.red;
  }
}
