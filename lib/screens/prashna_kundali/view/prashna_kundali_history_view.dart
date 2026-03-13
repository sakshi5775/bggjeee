import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/prashna_kundali/controller/prashna_kundali_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';

class PrashnaKundaliHistoryView extends GetView<PrashnaKundaliController> {
  const PrashnaKundaliHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch history on load
    controller.fetchHistory(page: 1);

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            CommonHeader(title: 'Reading History'),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingHistory.value &&
                    controller.historyReadings.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation("#F38B3B".toColor()),
                    ),
                  );
                }

                if (controller.historyReadings.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchHistory(page: 1),
                  color: "#F38B3B".toColor(),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    itemCount: controller.historyReadings.length,
                    itemBuilder: (context, index) {
                      final reading = controller.historyReadings[index];
                      return _buildHistoryCard(reading, index);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: '#FFFAF0'.toColor(),
                shape: BoxShape.circle,
                border: Border.all(color: '#F5D7B8'.toColor(), width: 2),
              ),
              child: Icon(
                Icons.history_edu,
                size: 60.w,
                color: "#F38B3B".toColor().withValues(alpha: 0.6),
              ),
            ),
            Spacing.h(24),
            AutoTranslateText(
              "No History Yet",
              style: MyTextTheme.largeBCB
                  .copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  )
                  .merge(AppTypography.h2),
              textAlign: TextAlign.center,
            ),
            Spacing.h(12),
            AutoTranslateText(
              "Your Prashna kundli readings will appear here.\nStart by asking your first question!",
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#666666'.toColor(),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Spacing.h(32),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: "#F38B3B".toColor().withValues(alpha: 0.35),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: '#ffffff'.toColor(),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 32.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.psychology_alt, size: 18.w),
                    Spacing.w(8),
                    AutoTranslateText(
                      "Ask Your Question",
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(var reading, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            UserMainController.pushInCurrentTab(
              AppRoutes.prashnaKundaliResults,
              arguments: {'result': reading},
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: "#F38B3B".toColor().withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.psychology_alt,
                        color: Colors.white,
                        size: 22.w,
                      ),
                    ),
                    Spacing.w(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            reading.askTime != null
                                ? DateFormat(
                                    'dd MMM yyyy',
                                  ).format(reading.askTime!)
                                : '-',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: '#999999'.toColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacing.h(2),
                          AutoTranslateText(
                            reading.askTime != null
                                ? DateFormat('hh:mm a').format(reading.askTime!)
                                : '-',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: '#CCCCCC'.toColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: '#FFF2E8'.toColor(),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: "#F38B3B".toColor().withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: AutoTranslateText(
                        "Reading #${controller.historyReadings.length - index}",
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#F38B3B".toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                Spacing.h(16),

                // Question
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: '#FFFAF0'.toColor(),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: '#F5D7B8'.toColor(), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 16.sp,
                        color: "#F38B3B".toColor(),
                      ),
                      Spacing.w(8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoTranslateText(
                              "Question",
                              style: MyTextTheme.smallBCN.copyWith(
                                color: '#999999'.toColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacing.h(4),
                            AutoTranslateText(
                              reading.questionAsked,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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

                Spacing.h(12),

                // Answer preview
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16.sp,
                      color: "#F38B3B".toColor(),
                    ),
                    Spacing.w(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            "Answer",
                            style: MyTextTheme.smallBCN.copyWith(
                              color: '#999999'.toColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacing.h(4),
                          AutoTranslateText(
                            reading.answerToQuestion,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#F38B3B".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Spacing.h(16),

                // View Details button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        UserMainController.pushInCurrentTab(
                          AppRoutes.prashnaKundaliResults,
                          arguments: {'result': reading},
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: "#F38B3B".toColor(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoTranslateText(
                            "View Full Reading",
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: "#F38B3B".toColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacing.w(4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16.sp,
                            color: "#F38B3B".toColor(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
