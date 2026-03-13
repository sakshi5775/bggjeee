import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/prashna_kundali_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/core/services/pdf_generator_service.dart';
import 'package:astrobharataiuser/data_model/pdf_metadata.dart';
import 'package:astrobharataiuser/data_model/pdf_section.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';

import '../../../core/services/share_service.dart';

class PrashnaKundaliResultsView extends StatelessWidget {
  const PrashnaKundaliResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Result can come from controller (new analysis) or arguments (history selection)
    final PrashnaReading? result = Get.arguments is PrashnaReading
        ? Get.arguments
        : (Get.arguments is Map ? Get.arguments['result'] : null);

    if (result == null) {
      return Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          endDrawer: const CommonEndDrawer(),
          body: Center(
            child: AutoTranslateText(
              "No result data found",
              style: MyTextTheme.mediumBCB.copyWith(color: '#3E2723'.toColor()),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            CommonHeader(
              title: 'Your Reading',
              customActions: [
                IconButton(
                  onPressed: () => _exportToPdf(result),
                  icon: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: "#F38B3B".toColor(),
                    size: 24.w,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // ShareService.shareKundli(
                    //   kundliId: result.answerToQuestion,
                    //   userName: result.,
                    // );
                  },
                  icon: Icon(
                    Icons.share,
                    color: "#F38B3B".toColor(),
                    size: 24.w,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(result),
                    Spacing.h(24),
                    _buildOverallAnswerSection(result),
                    Spacing.h(24),
                    _buildInsightsSection(result.prashnaInsights),
                    Spacing.h(24),
                    _buildInterpretationsSection(result.readings),
                    Spacing.h(24),
                    _buildRemediesSection(result.remedies),
                    Spacing.h(32),
                    _buildActionButtons(),
                    Spacing.h(32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPdf(PrashnaReading result) async {
    final List<PdfSection> sections = [];

    // 1. Header Info (Question & Context)
    sections.add(
      PdfSection(
        title: 'Prashna Kundali Reading',
        content: 'Question Asked: ${result.questionAsked}',
        bulletPoints: [
          'Location: ${result.city}',
          'Time of Question: ${result.askTime != null ? DateFormat('dd MMM yyyy, hh:mm a').format(result.askTime!) : 'N/A'}',
        ],
        type: PdfSectionType.bullet,
      ),
    );

    // 2. Divine Answer & Summary
    sections.add(
      PdfSection(
        title: 'Divine Answer: ${result.answerToQuestion}',
        content: result.summary,
      ),
    );

    if (result.timingAdvice.isNotEmpty) {
      sections.add(
        PdfSection(title: 'Timing Advice', content: result.timingAdvice),
      );
    }

    // 3. Astrological Insights
    final insights = result.prashnaInsights;
    if (insights != null) {
      final List<String> insightPoints = [];
      if (insights.lagnaAnalysis.isNotEmpty)
        insightPoints.add('Lagna Analysis: ${insights.lagnaAnalysis}');
      if (insights.moonPosition.isNotEmpty)
        insightPoints.add('Moon Position: ${insights.moonPosition}');
      if (insights.planetaryInfluence.isNotEmpty)
        insightPoints.add(
          'Planetary Influence: ${insights.planetaryInfluence}',
        );
      if (insights.horaLord.isNotEmpty)
        insightPoints.add('Hora Lord: ${insights.horaLord}');
      if (insights.currentDasha.isNotEmpty)
        insightPoints.add('Current Dasha: ${insights.currentDasha}');

      if (insightPoints.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Astrological Insights',
            content:
                'Detailed planetary influences at the time of your question:',
            bulletPoints: insightPoints,
            type: PdfSectionType.bullet,
          ),
        );
      }
    }

    // 4. Detailed Interpretations
    if (result.readings.isNotEmpty) {
      for (var reading in result.readings) {
        sections.add(
          PdfSection(title: reading.category, content: reading.interpretation),
        );
      }
    }

    // 5. Remedies
    final remedies = result.remedies;
    if (remedies != null) {
      if (remedies.mantras.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Recommended Mantras',
            content: 'Sacred chants for your situation:',
            bulletPoints: remedies.mantras,
            type: PdfSectionType.bullet,
          ),
        );
      }
      if (remedies.gemstones.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Gemstone Suggestions',
            content: 'Harmonious stones for your energy:',
            bulletPoints: remedies.gemstones,
            type: PdfSectionType.bullet,
          ),
        );
      }
      if (remedies.charities.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Charity & Donations',
            content: 'Acts of giving to balance karmic influences:',
            bulletPoints: remedies.charities,
            type: PdfSectionType.bullet,
          ),
        );
      }
      if (remedies.behaviors.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Behavioral Advice',
            content: 'Mindful actions and attitudes:',
            bulletPoints: remedies.behaviors,
            type: PdfSectionType.bullet,
          ),
        );
      }
      if (remedies.practicalAdvice.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Practical Recommendations',
            content: 'Tangible steps to take:',
            bulletPoints: remedies.practicalAdvice,
            type: PdfSectionType.bullet,
          ),
        );
      }
      if (remedies.colors.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Colors to Wear',
            content: 'Favorable colors for your current phase:',
            bulletPoints: remedies.colors,
            type: PdfSectionType.bullet,
          ),
        );
      }
    }

    // User metadata
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
            title: 'Prashna Kundali Report',
            sections: sections,
            metadata: PdfMetadata(
              userName: userName,
              generatedAt: DateTime.now(),
              reportType: PdfReportType.prashna,
            ),
            languageCode: language.code,
          );
        },
      ),
    );
    */

    // English-only for now (Direct Generation)
    await PdfGeneratorService.generateAstrologyReport(
      title: 'Prashna Kundali Report',
      sections: sections,
      metadata: PdfMetadata(
        userName: userName,
        generatedAt: DateTime.now(),
        reportType: PdfReportType.prashna,
      ),
      languageCode: 'en',
    );
  }

  Widget _buildHeaderCard(PrashnaReading result) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: "#F38B3B".toColor().withValues(alpha: 0.35),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30.h,
            right: -40.w,
            child: Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    "#DD2914".toColor().withValues(alpha: 0.35),
                    "#F38B3B".toColor().withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.psychology_alt,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          "Your Question",
                          style: MyTextTheme.smallBCN.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          result.questionAsked,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Spacing.h(16),

              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildHeaderInfoItem(
                        Icons.location_on,
                        "Location",
                        result.city,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 32.h,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    Spacing.w(12),
                    Expanded(
                      child: _buildHeaderInfoItem(
                        Icons.access_time,
                        "Time",
                        result.askTime != null
                            ? DateFormat(
                                'dd MMM, hh:mm a',
                              ).format(result.askTime!)
                            : '-',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.white),
        Spacing.w(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                label,
                style: MyTextTheme.smallBCN.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 10.sp,
                ),
              ),
              AutoTranslateText(
                value,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverallAnswerSection(PrashnaReading result) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
                'Divine Answer',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#F38B3B".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Spacing.h(16),

          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ['#FFFAF0'.toColor(), '#FFF8E1'.toColor()],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: "#F38B3B".toColor().withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  result.answerToQuestion,
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: "#F38B3B".toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
                Spacing.h(12),
                AutoTranslateText(
                  result.summary,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#3E2723'.toColor(),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          if (result.timingAdvice.isNotEmpty) ...[
            Spacing.h(16),
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: '#FFF2E8'.toColor(),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: "#F38B3B".toColor().withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: "#F38B3B".toColor().withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.timer_outlined,
                      size: 18.sp,
                      color: "#F38B3B".toColor(),
                    ),
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          "Best Timing",
                          style: MyTextTheme.smallBCN.copyWith(
                            color: '#999999'.toColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          result.timingAdvice,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightsSection(PrashnaInsights? insights) {
    if (insights == null) return SizedBox.shrink();

    final insightsList = [
      if (insights.lagnaAnalysis.isNotEmpty)
        ('Lagna Analysis', insights.lagnaAnalysis, Icons.star_border),
      if (insights.moonPosition.isNotEmpty)
        ('Moon Position', insights.moonPosition, Icons.nightlight_round),
      if (insights.planetaryInfluence.isNotEmpty)
        ('Planetary Influence', insights.planetaryInfluence, Icons.public),
      if (insights.horaLord.isNotEmpty)
        ('Hora Lord', insights.horaLord, Icons.wb_sunny),
      if (insights.currentDasha.isNotEmpty)
        ('Current Dasha', insights.currentDasha, Icons.timelapse),
    ];

    if (insightsList.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          Icons.insights,
          "Astrological Insights",
          "Detailed planetary positions and influences",
        ),
        Spacing.h(16),
        ...insightsList.map(
          (insight) => _buildInsightCard(
            icon: insight.$3,
            label: insight.$1,
            value: insight.$2,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ['#FFF2E8'.toColor(), '#FFFAF0'.toColor()],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: "#F38B3B".toColor().withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 18.sp, color: "#F38B3B".toColor()),
          ),
          Spacing.w(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  label,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(6),
                AutoTranslateText(
                  value,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#666666'.toColor(),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationsSection(List<PrashnaInterpretation> readings) {
    if (readings.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          Icons.menu_book,
          "Detailed Interpretations",
          "In-depth analysis of various aspects",
        ),
        Spacing.h(16),
        ...readings.asMap().entries.map((entry) {
          final index = entry.key;
          final reading = entry.value;
          return _buildInterpretationCard(reading, index);
        }),
      ],
    );
  }

  Widget _buildInterpretationCard(PrashnaInterpretation reading, int index) {
    final colors = [
      ('#F38B3B', '#FFF2E8'),
      ('#DD2914', '#FFFAF0'),
      ('#FFA500', '#FFF8E1'),
    ];
    final colorPair = colors[index % colors.length];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colorPair.$2.toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colorPair.$1.toColor().withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: AutoTranslateText(
                  reading.category,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: colorPair.$1.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            reading.interpretation,
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#3E2723'.toColor(),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemediesSection(PrashnaRemedies? remedies) {
    if (remedies == null) return SizedBox.shrink();

    final allRemedies = <(String, List<String>, IconData)>[
      ("Mantras", remedies.mantras, Icons.self_improvement),
      ("Gemstones", remedies.gemstones, Icons.diamond),
      ("Charities", remedies.charities, Icons.volunteer_activism),
      ("Behaviors", remedies.behaviors, Icons.psychology),
      ("Practical Advice", remedies.practicalAdvice, Icons.lightbulb),
      ("Colors", remedies.colors, Icons.palette),
    ].where((e) => e.$2.isNotEmpty).toList();

    if (allRemedies.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          Icons.healing,
          "Recommended Remedies",
          "Actions to enhance positive outcomes",
        ),
        Spacing.h(16),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: ['#ffffff'.toColor(), '#ffffff'.toColor()],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: allRemedies.asMap().entries.map((entry) {
              final index = entry.key;
              final remedy = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < allRemedies.length - 1 ? 20.h : 0,
                ),
                child: _buildRemedyItem(remedy.$3, remedy.$1, remedy.$2),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRemedyItem(IconData icon, String category, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: "#F38B3B".toColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 16.sp),
            ),
            Spacing.w(12),
            AutoTranslateText(
              category,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#F38B3B".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Spacing.h(12),
        ...items.map(
          (text) => Padding(
            padding: EdgeInsets.only(left: 36.w, bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6.h),
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: "#F38B3B".toColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: AutoTranslateText(
                    text,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: Colors.black.withValues(alpha: 0.95),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20.w),
          ),
          Spacing.w(12),
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
                      .merge(AppTypography.h3),
                ),
                Spacing.h(2),
                AutoTranslateText(
                  subtitle,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: '#999999'.toColor(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: "#F38B3B".toColor().withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => UserMainController.pushInCurrentTab(AppRoutes.astrologyServices),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: '#ffffff'.toColor(),
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, size: 18.w),
                  Spacing.w(8),
                  AutoTranslateText(
                    "Talk to Astrologer",
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Spacing.h(12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              foregroundColor: "#F38B3B".toColor(),
              side: BorderSide(color: "#F38B3B".toColor(), width: 1.5),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology_alt, size: 18.w),
                Spacing.w(8),
                AutoTranslateText(
                  "Ask Another Question",
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#F38B3B".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
