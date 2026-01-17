import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/ramal_shastra_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// Chart library not available - using simple visualizations instead

class RamalShastraStatsView extends StatefulWidget {
  const RamalShastraStatsView({Key? key}) : super(key: key);

  @override
  State<RamalShastraStatsView> createState() => _RamalShastraStatsViewState();
}

class _RamalShastraStatsViewState extends State<RamalShastraStatsView> {
  final RamalShastraController controller = Get.find<RamalShastraController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Obx(() => _buildContent()),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            "#F38B3B".toColor(),
            "#DD2914".toColor(),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Ramal Shastra Statistics',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h2),
                ),
                AutoTranslateText(
                  'Your reading statistics',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (controller.isLoadingStats.value) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>('#EA632B'.toColor()),
        ),
      );
    }

    final stats = controller.statsData.value;
    if (stats == null) {
      return Center(
        child: AutoTranslateText(
          'No statistics available',
          style: MyTextTheme.mediumBCN.copyWith(
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards(stats),
          Spacing.h(24),
          // Category Distribution Chart
          if (stats.categoryDistribution != null && stats.categoryDistribution!.isNotEmpty)
            _buildCategoryChart(stats.categoryDistribution!),
          Spacing.h(24),
          // Judgment Distribution Chart
          if (stats.judgmentDistribution != null && stats.judgmentDistribution!.isNotEmpty)
            _buildJudgmentChart(stats.judgmentDistribution!),
          Spacing.h(24),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(RamalStatsData stats) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Readings',
            '${stats.totalReadings ?? 0}',
            Icons.casino,
            Colors.blue,
          ),
        ),
        Spacing.w(12),
        Expanded(
          child: _buildSummaryCard(
            'Completed',
            '${stats.completedReadings ?? 0}',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        Spacing.w(12),
        Expanded(
          child: _buildSummaryCard(
            'Failed',
            '${stats.failedReadings ?? 0}',
            Icons.error,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.w),
          Spacing.h(8),
          AutoTranslateText(
            value,
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(4),
          AutoTranslateText(
            title,
            style: MyTextTheme.smallBCN.copyWith(
              color: '#666666'.toColor(),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart(List<RamalCategoryDistribution> categories) {
    return Container(
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
          AutoTranslateText(
            'Category Distribution',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(16),
          ...categories.map((category) {
            final index = categories.indexOf(category);
            final colors = [
              Colors.blue,
              Colors.green,
              "#F38B3B".toColor(),
              Colors.red,
              Colors.purple,
              Colors.teal,
              Colors.pink,
            ];
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colors[index % colors.length].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: colors[index % colors.length], width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    category.category ?? 'Unknown',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                    ),
                  ),
                  AutoTranslateText(
                    '${category.count ?? 0}',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: colors[index % colors.length],
                      fontWeight: FontWeight.bold,
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

  Widget _buildJudgmentChart(List<RamalJudgmentDistribution> judgments) {
    return Container(
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
          AutoTranslateText(
            'Outcome Distribution',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(16),
          ...judgments.map((judgment) {
            final index = judgments.indexOf(judgment);
            final colors = [
              Colors.green,
              "#F38B3B".toColor(),
              Colors.red,
              Colors.blue,
            ];
            final counts = judgments.map((j) => j.count ?? 0).toList();
            final maxCount = counts.isNotEmpty ? counts.reduce((a, b) => a > b ? a : b) : 0;
            final percentage = maxCount > 0 ? ((judgment.count ?? 0) / maxCount) : 0.0;
            
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoTranslateText(
                        judgment.outcome ?? 'Unknown',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                        ),
                      ),
                      AutoTranslateText(
                        '${judgment.count ?? 0}',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: colors[index % colors.length],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(colors[index % colors.length]),
                      minHeight: 20.h,
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
}

