import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/palm_reading_model.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PalmReadingDetailView extends StatelessWidget {
  const PalmReadingDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PalmReadingController>();
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 800.w;

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(), // Match Face Reading background
      body: Column(
        children: [
          const CommonHeader(title: 'Palm Reading Detail'),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingReading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.readingError.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64.w, color: Colors.red),
                      Spacing.h(16),
                      AutoTranslateText(
                        controller.readingError.value,
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: '#3E2723'.toColor(),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Spacing.h(24),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const AutoTranslateText('Go Back'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: AppPaddings.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Summary Section
                          _buildSummarySection(controller),

                          Spacing.h(32),

                          // Palm Lines Analysis
                          _buildPalmLinesSection(controller),

                          Spacing.h(32),

                          // Mount Analysis
                          _buildMountAnalysisSection(controller),

                          Spacing.h(32),

                          // Special Markings
                          _buildSpecialMarkingsSection(controller),

                          Spacing.h(32),

                          // Consult Expert Section
                          _buildConsultExpertSection(),

                          Spacing.h(32),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(PalmReadingController controller) {
    return Container(
      padding: AppPaddings.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ["#F38B3B".toColor(), "#F38B3B".toColor()],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: "#F38B3B".toColor().withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.white, size: 24.w),
              Spacing.w(12),
              AutoTranslateText(
                'Summary',
                style: MyTextTheme.mediumBCB
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold)
                    .merge(AppTypography.h2),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            controller.palmReadingData.value?.summary.isNotEmpty == true
                ? controller.palmReadingData.value!.summary
                : 'Your palm reveals a person with strong emotional intelligence and practical wisdom. You have natural leadership qualities combined with creativity. Your life path shows resilience and adaptability, with opportunities for significant success in both personal and professional spheres.',
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.white,
              height: 1.5,
            ),
          ),
          Spacing.h(20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.astrologyServices);
              },
              icon: Icon(
                Icons.chat_bubble_outline,
                color: "#F38B3B".toColor(),
                size: 20.w,
              ),
              label: AutoTranslateText(
                'Consult Expert',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#F38B3B".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: AppPaddings.symmetric(v: 12, h: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalmLinesSection(PalmReadingController controller) {
    return Obx(() {
      final readingData = controller.palmReadingData.value;
      if (readingData == null) return const SizedBox.shrink();

      // Get all line categories from API
      final lineCategories = readingData.readings
          .where(
            (r) => [
              'HEART_LINE',
              'HEAD_LINE',
              'LIFE_LINE',
              'FATE_LINE',
              'SUN_LINE',
            ].contains(r.category.toUpperCase()),
          )
          .toList();

      if (lineCategories.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Palm Lines Analysis',
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h1),
          ),
          Spacing.h(16),
          ...lineCategories.map((reading) {
            String title;
            IconData icon;
            Color iconColor;

            switch (reading.category.toUpperCase()) {
              case 'HEART_LINE':
                title = 'Heart Line';
                icon = Icons.favorite;
                iconColor = Colors.red;
                break;
              case 'HEAD_LINE':
                title = 'Head Line';
                icon = Icons.psychology;
                iconColor = "#F38B3B".toColor();
                break;
              case 'LIFE_LINE':
                title = 'Life Line';
                icon = Icons.trending_up;
                iconColor = Colors.lightBlue;
                break;
              case 'FATE_LINE':
                title = 'Fate Line';
                icon = Icons.arrow_upward;
                iconColor = Colors.purple;
                break;
              case 'SUN_LINE':
                title = 'Sun Line';
                icon = Icons.wb_sunny;
                iconColor = Colors.amber;
                break;
              default:
                title = reading.category;
                icon = Icons.linear_scale;
                iconColor = "#F38B3B".toColor();
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildLineCard(
                title,
                icon,
                iconColor,
                reading.interpretation,
                controller,
                reading.category,
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget _buildLineCard(
    String title,
    IconData icon,
    Color iconColor,
    String interpretation,
    PalmReadingController controller,
    String category,
  ) {
    return Container(
      padding: AppPaddings.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24.w),
              ),
              Spacing.w(16),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            interpretation,
            style: MyTextTheme.mediumBCN.copyWith(
              color: const Color(0xFF5F2221),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMountAnalysisSection(PalmReadingController controller) {
    return Obx(() {
      final readingData = controller.palmReadingData.value;
      if (readingData == null) return const SizedBox.shrink();

      // Get MOUNTS reading from API
      PalmReadingItem? mountsReading;
      try {
        mountsReading = readingData.readings.firstWhere(
          (r) => r.category.toUpperCase() == 'MOUNTS',
        );
      } catch (e) {
        mountsReading = null;
      }

      if (mountsReading == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Mount Analysis',
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h1),
          ),
          Spacing.h(16),
          Container(
            padding: AppPaddings.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
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
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.landscape,
                        color: Colors.green,
                        size: 24.w,
                      ),
                    ),
                    Spacing.w(16),
                    Expanded(
                      child: AutoTranslateText(
                        'Mounts',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacing.h(16),
                AutoTranslateText(
                  mountsReading.interpretation,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#3E2723'.toColor(),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSpecialMarkingsSection(PalmReadingController controller) {
    return Obx(() {
      final readingData = controller.palmReadingData.value;
      if (readingData == null) return const SizedBox.shrink();

      // Get FINGERS reading from API
      PalmReadingItem? fingersReading;
      try {
        fingersReading = readingData.readings.firstWhere(
          (r) => r.category.toUpperCase() == 'FINGERS',
        );
      } catch (e) {
        fingersReading = null;
      }

      if (fingersReading == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Finger Analysis',
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h1),
          ),
          Spacing.h(16),
          Container(
            padding: AppPaddings.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
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
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.back_hand,
                        color: Colors.blue,
                        size: 24.w,
                      ),
                    ),
                    Spacing.w(16),
                    Expanded(
                      child: AutoTranslateText(
                        'Fingers',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacing.h(16),
                AutoTranslateText(
                  fingersReading.interpretation,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#3E2723'.toColor(),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildConsultExpertSection() {
    return Container(
      padding: AppPaddings.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          AutoTranslateText(
            'Need Deeper Insight?',
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(12),
          AutoTranslateText(
            'Talk to an expert astrologer for detailed palm analysis.',
            style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          Spacing.h(20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.astrologyServices);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5F2221),
                foregroundColor: Colors.white,
                padding: AppPaddings.symmetric(v: 16, h: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoTranslateText(
                    'Consult Now',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.w(8),
                  Icon(Icons.arrow_forward, size: 20.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
