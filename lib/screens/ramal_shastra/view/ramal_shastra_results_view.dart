import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/ramal_shastra_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/service/ramal_shastra_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RamalShastraResultsView extends StatelessWidget {
  const RamalShastraResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final RamalShastraData? result = Get.arguments?['result'];

    if (result == null) {
      return Scaffold(
        backgroundColor: '#FFF8E1'.toColor(),
        body: Center(
          child: AutoTranslateText(
            'No results found',
            style: MyTextTheme.mediumBCB.copyWith(color: '#3E2723'.toColor()),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(
              title: 'Results',
              customActions: [
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.ramalShastraStats),
                  icon: Icon(
                    Icons.bar_chart,
                    color: '#6F221E'.toColor(),
                    size: 24.w,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.ramalShastraHistory),
                  icon: Icon(
                    Icons.history,
                    color: '#6F221E'.toColor(),
                    size: 24.w,
                  ),
                ),
                if (result.readingId != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: '#6F221E'.toColor(),
                      size: 24.w,
                    ),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteDialog(result.readingId!);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Reading',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (result.readingId != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: '#F5D7B8'.toColor()),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tag, color: "#F38B3B".toColor(), size: 14.w),
                      Spacing.w(4),
                      AutoTranslateText(
                        'Reading ID: ${result.readingId}',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: '#3E2723'.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Header Card
                    _buildQuestionHeader(result),
                    Spacing.h(24),
                    // Section 1: Final Judgment Card (includes judgmentSummary)
                    _buildJudgmentCard(
                      result.judgment,
                      result.interpretation?.judgmentSummary,
                    ),
                    Spacing.h(24),
                    // Section 2: Answer to Question
                    _buildAnswerToQuestion(
                      result.interpretation?.answerToQuestion,
                    ),
                    Spacing.h(24),
                    // Section 3: Ramal Chart (4×4 Grid) - with chartData details if available
                    if (result.chart != null || result.chartData != null) ...[
                      _buildRamalChart(result.chart, result.chartData),
                      Spacing.h(24),
                    ],
                    // Element Distribution
                    if (result.chart?.relationships?.elementDistribution !=
                            null ||
                        result.chartData?.relationships?.elementDistribution !=
                            null) ...[
                      _buildElementDistribution(
                        result.chart?.relationships?.elementDistribution ??
                            result
                                .chartData
                                ?.relationships
                                ?.elementDistribution,
                      ),
                      Spacing.h(24),
                    ],
                    // House Relationships (Strong/Weak/Neutral)
                    if (result.chart?.relationships != null ||
                        result.chartData?.relationships != null) ...[
                      _buildHouseRelationships(
                        result.chart?.relationships ??
                            result.chartData?.relationships,
                      ),
                      Spacing.h(24),
                    ],
                    // Section 4: Key Houses
                    if (result.interpretation?.keyHouses != null &&
                        result.interpretation!.keyHouses!.isNotEmpty) ...[
                      _buildKeyHouses(result.interpretation!.keyHouses!),
                      Spacing.h(24),
                    ],
                    // Section 5: Summary
                    if (result.interpretation?.summary != null &&
                        result.interpretation!.summary!.isNotEmpty) ...[
                      _buildSummary(result.interpretation!.summary!),
                      Spacing.h(24),
                    ],
                    // Section 6: Detailed Analysis
                    if (result.interpretation?.detailedAnalysis != null) ...[
                      _buildDetailedAnalysis(
                        result.interpretation!.detailedAnalysis!,
                      ),
                      Spacing.h(24),
                    ],
                    // Section 7: Timing
                    if (result.interpretation?.timing != null) ...[
                      _buildTiming(result.interpretation!.timing!),
                      Spacing.h(24),
                    ],
                    // Section 8: Strengths & Challenges
                    if (result.interpretation?.strengths != null ||
                        result.interpretation?.challenges != null) ...[
                      _buildStrengthsChallenges(
                        result.interpretation?.strengths,
                        result.interpretation?.challenges,
                      ),
                      Spacing.h(24),
                    ],
                    // Section 9: Advice
                    if (result.interpretation?.advice != null &&
                        result.interpretation!.advice!.isNotEmpty) ...[
                      _buildAdvice(result.interpretation!.advice!),
                      Spacing.h(24),
                    ],
                    // Section 10: Remedies
                    if (result.interpretation?.remedies != null) ...[
                      _buildRemedies(result.interpretation!.remedies!),
                      Spacing.h(24),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String readingId) {
    Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: AutoTranslateText(
          'Delete Reading',
          style: MyTextTheme.largeBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: AutoTranslateText(
          'Are you sure you want to delete this reading? This action cannot be undone.',
          style: MyTextTheme.mediumBCN.copyWith(color: '#666666'.toColor()),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: AutoTranslateText(
              'Cancel',
              style: MyTextTheme.mediumBCN.copyWith(color: '#666666'.toColor()),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back(result: true);
              try {
                final controller = Get.find<RamalShastraController>();
                final index = controller.historyReadings.indexWhere(
                  (r) => r.readingId == readingId,
                );
                if (index >= 0) {
                  await controller.deleteReading(readingId, index);
                  Get.snackbar(
                    'Success',
                    'Reading deleted successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  Get.back(); // Go back to history or previous screen
                } else {
                  // If not in history, delete directly via service
                  final service = RamalShastraService();
                  await service.deleteRamal(readingId);
                  Get.snackbar(
                    'Success',
                    'Reading deleted successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  Get.back();
                }
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to delete reading: ${e.toString()}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: AutoTranslateText(
              'Delete',
              style: MyTextTheme.mediumBCB.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(RamalShastraData result) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Your Question',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      result.question ?? 'N/A',
                      style: MyTextTheme.largeBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h2),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (result.category != null) ...[
            Spacing.h(12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AutoTranslateText(
                result.category!,
                style: MyTextTheme.smallBCB.copyWith(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildJudgmentCard(
    RamalJudgment? judgment,
    RamalJudgmentSummary? judgmentSummary,
  ) {
    // Use judgmentSummary if judgment is null, create a compatible object
    final displayOutcome = judgment?.outcome ?? judgmentSummary?.outcome;
    final displayConfidence =
        judgment?.confidence ?? judgmentSummary?.confidence;
    final displayExplanation =
        judgment?.explanation ?? judgmentSummary?.explanation;

    if (displayOutcome == null) return SizedBox.shrink();

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
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.gavel, color: Colors.white, size: 24.w),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  'Final Judgment',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
              ),
            ],
          ),
          Spacing.h(20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Outcome',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#666666'.toColor(),
                      ),
                    ),
                    Spacing.h(8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: AutoTranslateText(
                        displayOutcome,
                        style: MyTextTheme.largeBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.w(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoTranslateText(
                    'Confidence',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: '#666666'.toColor(),
                    ),
                  ),
                  Spacing.h(8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.deepOrange.withOpacity(0.3),
                      ),
                    ),
                    child: AutoTranslateText(
                      '${((displayConfidence ?? 0) * 100).toStringAsFixed(0)}%',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: AppColors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (displayExplanation != null && displayExplanation.isNotEmpty) ...[
            Spacing.h(20),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: '#FFF8E1'.toColor().withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: '#F5D7B8'.toColor()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.deepOrange,
                        size: 18.w,
                      ),
                      Spacing.w(8),
                      AutoTranslateText(
                        'Explanation',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    displayExplanation,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: '#3E2723'.toColor(),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Show judge/reconciler strength if available from judgment
          if (judgment != null &&
              (judgment.judgeStrength != null ||
                  judgment.reconcilerStrength != null)) ...[
            Spacing.h(16),
            Divider(color: '#F5D7B8'.toColor()),
            Spacing.h(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (judgment.judgeStrength != null)
                  Column(
                    children: [
                      AutoTranslateText(
                        'Judge Strength',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: '#666666'.toColor(),
                        ),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        '${judgment.judgeStrength}/4',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                if (judgment.reconcilerStrength != null)
                  Column(
                    children: [
                      AutoTranslateText(
                        'Reconciler Strength',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: '#666666'.toColor(),
                        ),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        '${judgment.reconcilerStrength}/4',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.deepOrange.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerToQuestion(String? answer) {
    if (answer == null || answer.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: Colors.white, size: 24.w),
              Spacing.w(8),
              AutoTranslateText(
                'Answer to Question',
                style: MyTextTheme.largeBCB
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                    .merge(AppTypography.h2),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            answer,
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRamalChart(RamalChart? chart, RamalChartData? chartData) {
    // Use chartData if available, otherwise use chart
    List<RamalHouse> houses = [];
    if (chartData?.houses != null && chartData!.houses!.isNotEmpty) {
      houses = chartData.houses!
          .map(
            (h) => RamalHouse(
              houseNumber: h.houseNumber,
              name: h.name,
              strength: h.strength,
              element: h.element,
              isJudge: false,
              isReconciler: false,
            ),
          )
          .toList();
    } else if (chart?.houses != null && chart!.houses!.isNotEmpty) {
      houses = chart.houses!;
    } else {
      return SizedBox.shrink();
    }

    if (houses.isEmpty) return SizedBox.shrink();

    // Get matrix from chartData if available
    final matrix = chartData?.matrix;

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
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.grid_view, color: Colors.white, size: 24.w),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  'Ramal Chart (4×4 Grid)',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
              ),
            ],
          ),
          Spacing.h(20),
          // Show matrix if available
          if (matrix != null && matrix.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Matrix Pattern',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.h(8),
                  ...matrix.map((row) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row.map((value) {
                        return Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: value == 1
                                  ? AppColors.deepOrange
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Center(
                              child: Text(
                                value == 1 ? '●' : '○',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: value == 1
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
            Spacing.h(20),
          ],
          // Build 4x4 grid with house details
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
            ),
            child: Column(
              children: [
                AutoTranslateText(
                  'Houses Layout',
                  style: MyTextTheme.veryLarge20.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(12),
                ...List.generate(4, (row) {
                  return Row(
                    children: List.generate(4, (col) {
                      final index = row * 4 + col;
                      if (index >= houses.length) {
                        return Expanded(child: SizedBox.shrink());
                      }
                      final house = houses[index];
                      final isJudge =
                          house.isJudge ?? (house.houseNumber == 15);
                      final isReconciler =
                          house.isReconciler ?? (house.houseNumber == 16);
                      RamalHouseDetailed? detailedHouse;
                      if (chartData?.houses != null &&
                          index < (chartData!.houses?.length ?? 0)) {
                        detailedHouse = chartData.houses?[index];
                      }
                      return Expanded(
                        child: _buildHouseCell(
                          house,
                          isJudge,
                          isReconciler,
                          detailedHouse,
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
          ),
          // Show shakals if available
          if (chartData?.shakals != null && chartData!.shakals!.isNotEmpty) ...[
            Spacing.h(16),
            ExpansionTile(
              title: AutoTranslateText(
                'Shakals (Detailed Patterns)',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children:
                        (chartData.shakals?.asMap().entries.map((entry) {
                          final index = entry.key;
                          final shakal = entry.value;
                          return Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoTranslateText(
                                  'H${index + 1}',
                                  style: MyTextTheme.smallBCB.copyWith(
                                    color: '#3E2723'.toColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacing.h(4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: shakal.map((val) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                      ),
                                      child: Text(
                                        val == 1 ? '●' : '○',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: val == 1
                                              ? AppColors.deepOrange
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList() ??
                        []),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHouseCell(
    RamalHouse house,
    bool isJudge,
    bool isReconciler,
    RamalHouseDetailed? detailedHouse,
  ) {
    Color borderColor = Colors.grey.withOpacity(0.2);
    Color bgColor = _getElementColor(house.element).withOpacity(0.05);
    if (isJudge) {
      borderColor = AppColors.deepOrange;
      bgColor = AppColors.lightBackground;
    }
    if (isReconciler) {
      borderColor = Colors.grey[400]!;
      bgColor = Colors.grey[50]!;
    }

    final shakal = detailedHouse?.shakal;

    return GestureDetector(
      onTap: () {
        // Show house details dialog
        _showHouseDetails(house, detailedHouse);
      },
      child: Container(
        margin: EdgeInsets.all(3.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: borderColor,
            // width: isJudge || isReconciler ? 3 : 1.5,
          ),
          boxShadow: isJudge || isReconciler
              ? [
                  BoxShadow(
                    color: borderColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${house.houseNumber ?? 0}',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isJudge) ...[
                  Spacing.w(4),
                  Icon(Icons.star, size: 6.w, color: AppColors.deepOrange),
                ],
                if (isReconciler) ...[
                  Spacing.w(4),
                  Icon(Icons.balance, size: 6.w, color: Colors.grey[500]),
                ],
              ],
            ),
            Spacing.h(6),
            // Show shakal pattern if available
            if (shakal != null && shakal.length == 4)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: shakal.map((val) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Text(
                      val == 1 ? '●' : '○',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: val == 1
                            ? _getElementColor(house.element)
                            : Colors.grey[400],
                      ),
                    ),
                  );
                }).toList(),
              )
            else
              Container(
                width: 32.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: _getElementColor(house.element).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text(
                    _getDotPattern(house.strength ?? 0),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: _getElementColor(house.element),
                    ),
                  ),
                ),
              ),
            Spacing.h(6),
            // Element indicator
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                // color: _getElementColor(house.element),
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getElementColor(house.element).withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _getElementIcon(house.element),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Spacing.h(4),
            // Strength indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 12.w,
                  color: _getStrengthColor(house.strength ?? 0),
                ),
                Spacing.w(2),
                Text(
                  '${house.strength ?? 0}/4',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: _getStrengthColor(house.strength ?? 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // House name (abbreviated)
            Spacing.h(4),
            AutoTranslateText(
              _getHouseNameAbbreviation(house.name ?? ''),
              style: MyTextTheme.smallBCN.copyWith(color: '#666666'.toColor()),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getHouseNameAbbreviation(String name) {
    if (name.contains('/')) {
      return name.split('/').first;
    }
    if (name.length > 8) {
      return name.substring(0, 8);
    }
    return name;
  }

  Color _getStrengthColor(int strength) {
    if (strength >= 3) return AppColors.deepOrange;
    if (strength == 2) return AppColors.deepOrange.withOpacity(0.8);
    return AppColors.deepOrange.withOpacity(0.6);
  }

  String _getElementIcon(String? element) {
    switch (element?.toLowerCase()) {
      case 'fire':
        return '🔥';
      case 'air':
        return '💨';
      case 'water':
        return '💧';
      case 'earth':
        return '🌍';
      default:
        return '○';
    }
  }

  void _showHouseDetails(RamalHouse house, RamalHouseDetailed? detailed) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400.w),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AutoTranslateText(
                        'House ${house.houseNumber ?? 0} Details',
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              color: '#3E2723'.toColor(),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.h2),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                Spacing.h(16),
                if (detailed != null) ...[
                  _buildDetailRow('Name', detailed.name ?? house.name ?? 'N/A'),
                  _buildDetailRow('Type', detailed.type ?? 'N/A'),
                  _buildDetailRow('Element', detailed.element ?? 'N/A'),
                  _buildDetailRow('Gender', detailed.gender ?? 'N/A'),
                  _buildDetailRow(
                    'Strength',
                    '${detailed.strength ?? house.strength ?? 0}/4',
                  ),
                  if (detailed.meaning != null)
                    _buildDetailRow('Meaning', detailed.meaning!),
                  if (detailed.domain != null)
                    _buildDetailRow('Domain', detailed.domain!),
                  if (detailed.shakal != null &&
                      detailed.shakal!.length == 4) ...[
                    Spacing.h(12),
                    AutoTranslateText(
                      'Shakal Pattern',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.h(8),
                    Row(
                      children: detailed.shakal!.map((val) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: val == 1
                                  ? "#F38B3B".toColor()
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                val == 1 ? '●' : '○',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: val == 1
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (detailed.keywords != null &&
                      detailed.keywords!.isNotEmpty) ...[
                    Spacing.h(12),
                    AutoTranslateText(
                      'Keywords',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.h(8),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: detailed.keywords!.map((keyword) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: AutoTranslateText(
                            keyword,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ] else ...[
                  _buildDetailRow('Name', house.name ?? 'N/A'),
                  _buildDetailRow('Element', house.element ?? 'N/A'),
                  _buildDetailRow('Strength', '${house.strength ?? 0}/4'),
                ],
                Spacing.h(20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: AutoTranslateText('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.mediumBCB.copyWith(
                color: '#666666'.toColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacing.w(12),
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.mediumBCN.copyWith(color: '#3E2723'.toColor()),
            ),
          ),
        ],
      ),
    );
  }

  Color _getElementColor(String? element) {
    return AppColors.deepOrange;
  }

  String _getDotPattern(int strength) {
    final dots = strength.clamp(0, 4);
    return '●' * dots + '○' * (4 - dots);
  }

  Widget _buildKeyHouses(List<RamalKeyHouse> keyHouses) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Key Houses',
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(16),
          ...keyHouses.map((house) => _buildKeyHouseCard(house)),
        ],
      ),
    );
  }

  Widget _buildKeyHouseCard(RamalKeyHouse house) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'H${house.houseNumber}',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  house.name ?? '',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getElementColor(house.element).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AutoTranslateText(
                  '${house.strength ?? 0}/4',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: _getElementColor(house.element),
                  ),
                ),
              ),
            ],
          ),
          if (house.interpretation != null) ...[
            Spacing.h(12),
            AutoTranslateText(
              house.interpretation!,
              style: MyTextTheme.smallBCN.copyWith(
                color: '#666666'.toColor(),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysis(String analysis) {
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
      child: ExpansionTile(
        title: AutoTranslateText(
          'Detailed Analysis',
          style: MyTextTheme.largeBCB
              .copyWith(color: '#3E2723'.toColor(), fontWeight: FontWeight.bold)
              .merge(AppTypography.h2),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: AutoTranslateText(
              analysis,
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#3E2723'.toColor(),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiming(String timing) {
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
              Icon(Icons.access_time, color: AppColors.deepOrange, size: 24.w),
              Spacing.w(8),
              AutoTranslateText(
                'Timing Prediction',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            timing,
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#3E2723'.toColor(),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsChallenges(
    List<String>? strengths,
    List<String>? challenges,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (strengths != null && strengths.isNotEmpty)
            Expanded(child: _buildStrengthsCard(strengths)),
          if (strengths != null && challenges != null) Spacing.w(12),
          if (challenges != null && challenges.isNotEmpty)
            Expanded(child: _buildChallengesCard(challenges)),
        ],
      ),
    );
  }

  Widget _buildStrengthsCard(List<String> strengths) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Strengths',
            style: MyTextTheme.mediumBCB.copyWith(
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          ...strengths.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16.w,
                    color: Colors.green[700],
                  ),
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

  Widget _buildChallengesCard(List<String> challenges) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: "#F38B3B".toColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#F38B3B".toColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Challenges',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#F38B3B".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          ...challenges.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning, size: 16.w, color: "#F38B3B".toColor()),
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

  Widget _buildAdvice(List<String> advice) {
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
          AutoTranslateText(
            'Advice',
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(16),
          ...advice.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6.h, right: 12.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      item,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#3E2723'.toColor(),
                        height: 1.5,
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

  Widget _buildRemedies(RamalRemedies remedies) {
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
      child: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            AutoTranslateText(
              'Remedies',
              style: MyTextTheme.largeBCB
                  .copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  )
                  .merge(AppTypography.h2),
            ),
            Spacing.h(16),
            TabBar(
              isScrollable: true,
              labelColor: AppColors.deepOrange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.deepOrange,
              tabs: [
                Tab(text: 'Mantras'),
                Tab(text: 'Charity'),
                Tab(text: 'Behavior'),
                Tab(text: 'Practical'),
                Tab(text: 'Colors'),
              ],
            ),
            Spacing.h(16),
            SizedBox(
              height: 200.h,
              child: TabBarView(
                children: [
                  _buildRemediesList(remedies.mantras),
                  _buildRemediesList(remedies.charities),
                  _buildRemediesList(remedies.behaviors),
                  _buildRemediesList(remedies.practicalAdvice),
                  _buildRemediesList(remedies.colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemediesList(List<String>? items) {
    if (items == null || items.isEmpty) {
      return Center(
        child: AutoTranslateText(
          'No remedies available',
          style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
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
                  gradient: AppColors.orangeGradient,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: AutoTranslateText(
                  items[index],
                  style: MyTextTheme.smallBCN.copyWith(
                    color: '#3E2723'.toColor(),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildElementDistribution(Map<String, int>? elementDistribution) {
    if (elementDistribution == null || elementDistribution.isEmpty) {
      return SizedBox.shrink();
    }

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
              Icon(Icons.pie_chart, color: AppColors.deepOrange, size: 24.w),
              Spacing.w(8),
              AutoTranslateText(
                'Element Distribution',
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
          ...elementDistribution.entries.map((entry) {
            final element = entry.key;
            final count = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: _getElementColor(element).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _getElementColor(element),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          // color: _getElementColor(element),
                          gradient: AppColors.orangeGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _getElementIcon(element),
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                      ),
                      Spacing.w(12),
                      AutoTranslateText(
                        element.toUpperCase(),
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      // color: _getElementColor(element),
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                    ),
                    child: AutoTranslateText(
                      '$count',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildHouseRelationships(RamalRelationships? relationships) {
    if (relationships == null) return SizedBox.shrink();

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
          AutoTranslateText(
            'House Relationships',
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(16),
          if (relationships.strongHouses != null &&
              relationships.strongHouses!.isNotEmpty) ...[
            _buildRelationshipSection(
              'Strong Houses',
              relationships.strongHouses!,
              Colors.green,
              Icons.trending_up,
            ),
            Spacing.h(12),
          ],
          if (relationships.weakHouses != null &&
              relationships.weakHouses!.isNotEmpty) ...[
            _buildRelationshipSection(
              'Weak Houses',
              relationships.weakHouses!,
              Colors.red,
              Icons.trending_down,
            ),
            Spacing.h(12),
          ],
          if (relationships.neutralHouses != null &&
              relationships.neutralHouses!.isNotEmpty) ...[
            _buildRelationshipSection(
              'Neutral Houses',
              relationships.neutralHouses!,
              "#F38B3B".toColor(),
              Icons.remove,
            ),
          ],
          if (relationships.fireHouses != null &&
              relationships.fireHouses!.isNotEmpty) ...[
            Spacing.h(12),
            _buildRelationshipSection(
              'Fire Houses',
              relationships.fireHouses!,
              Colors.red,
              Icons.whatshot,
            ),
          ],
          if (relationships.waterHouses != null &&
              relationships.waterHouses!.isNotEmpty) ...[
            Spacing.h(12),
            _buildRelationshipSection(
              'Water Houses',
              relationships.waterHouses!,
              Colors.teal,
              Icons.water_drop,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRelationshipSection(
    String title,
    List<int> houses,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color, width: 1),
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
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.w(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AutoTranslateText(
                  '${houses.length}',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: houses.map((houseNum) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AutoTranslateText(
                  'H$houseNum',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(String summary) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#F38B3B".toColor().withOpacity(0.1),
            "#DD2914".toColor().withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.5),
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
              Icon(Icons.summarize, color: AppColors.deepOrange, size: 24.w),
              Spacing.w(8),
              AutoTranslateText(
                'Summary',
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
          AutoTranslateText(
            summary,
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#3E2723'.toColor(),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
