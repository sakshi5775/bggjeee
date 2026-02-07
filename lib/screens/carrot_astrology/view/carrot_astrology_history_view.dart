import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/carrot_astrology_model.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/controller/carrot_astrology_history_controller.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/utils/carrot_astrology_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CarrotAstrologyHistoryView extends StatelessWidget {
  const CarrotAstrologyHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CarrotAstrologyHistoryController());
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(
              title: 'Carrot Astrology History',
              subtitle: AutoTranslateText(
                'View all your readings',
                style: TextStyle(fontSize: 12, color: Color(0xFF6F221E)),
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    children: [
                      _buildFilterSection(controller),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value &&
                              controller.historyList.isEmpty) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CarrotAstrologyColors.orangeColor,
                                ),
                              ),
                            );
                          }

                          if (controller.historyList.isEmpty &&
                              !controller.isLoading.value) {
                            return _buildEmptyState(controller);
                          }

                          return RefreshIndicator(
                            onRefresh: () =>
                                controller.loadHistory(reset: true),
                            color: CarrotAstrologyColors.orangeColor,
                            child: ListView.builder(
                              padding: EdgeInsets.all(16.w),
                              itemCount:
                                  controller.historyList.length +
                                  (controller.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == controller.historyList.length) {
                                  controller.loadMore();
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              CarrotAstrologyColors.orangeColor,
                                            ),
                                      ),
                                    ),
                                  );
                                }

                                final item = controller.historyList[index];
                                return _buildHistoryCard(controller, item);
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(CarrotAstrologyHistoryController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedStatus.value.isEmpty
                            ? null
                            : controller.selectedStatus.value,
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: Colors.grey[600],
                              size: 18.w,
                            ),
                            Spacing.w(8),
                            AutoTranslateText(
                              controller.statusDisplayText,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        items: controller.statusOptions.map((status) {
                          String displayText;
                          switch (status) {
                            case 'PROCESSING':
                              displayText = 'Processing';
                              break;
                            case 'COMPLETED':
                              displayText = 'Completed';
                              break;
                            case 'FAILED':
                              displayText = 'Failed';
                              break;
                            default:
                              displayText = 'All Status';
                          }
                          return DropdownMenuItem<String>(
                            value: status.isEmpty ? null : status,
                            child: AutoTranslateText(
                              displayText,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: '#3E2723'.toColor(),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: controller.onStatusFilterChanged,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
                          size: 24.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedZodiacSign.value.isEmpty
                            ? null
                            : controller.selectedZodiacSign.value,
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.grey[600],
                              size: 18.w,
                            ),
                            Spacing.w(8),
                            AutoTranslateText(
                              controller.zodiacSignDisplayText,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        items: ['', ...controller.zodiacSigns].map((sign) {
                          return DropdownMenuItem<String>(
                            value: sign.isEmpty ? null : sign,
                            child: AutoTranslateText(
                              sign.isEmpty ? 'All Zodiac Signs' : sign,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: '#3E2723'.toColor(),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: controller.onZodiacSignFilterChanged,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[600],
                          size: 24.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Obx(
            () =>
                (controller.selectedStatus.value.isNotEmpty ||
                    controller.selectedZodiacSign.value.isNotEmpty)
                ? SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: controller.clearFilters,
                      icon: Icon(
                        Icons.clear,
                        size: 18.w,
                        color: CarrotAstrologyColors.orangeColor,
                      ),
                      label: AutoTranslateText(
                        'Clear Filters',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: CarrotAstrologyColors.orangeColor,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(CarrotAstrologyHistoryController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64.w, color: Colors.grey[400]),
            Spacing.h(16),
            AutoTranslateText(
              'No readings found',
              style: MyTextTheme.largeBCB.copyWith(color: Colors.grey[600]),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'Your carrot astrology readings will appear here',
              style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    CarrotAstrologyHistoryController controller,
    CarrotAstrologyData reading,
  ) {
    final zodiacSign =
        reading.userInput?.zodiacSign ?? reading.zodiacInfo?.sign ?? 'Unknown';
    final status = reading.status ?? 'UNKNOWN';
    final isCompleted = status == 'COMPLETED';
    final isProcessing = status == 'PROCESSING';
    final isFailed = status == 'FAILED';

    final dateStr = _formatDate(reading.createdAt);
    final vegetableName = reading.vegetableMatch?.name ?? 'N/A';

    return GestureDetector(
      onTap: () => controller.viewReading(reading.readingId ?? ''),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                    color: '#FFF2E8'.toColor(),
                    shape: BoxShape.circle,
                  ),
                  child: AutoTranslateText(
                    controller.getZodiacSymbol(zodiacSign),
                    style: AppTypography.h1.copyWith(fontSize: 24.sp),
                  ),
                ),
                Spacing.w(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        zodiacSign,
                        style: MyTextTheme.mediumBCB
                            .copyWith(
                              color: '#3E2723'.toColor(),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.body2),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        vegetableName,
                        style: MyTextTheme.smallBCN
                            .copyWith(color: '#666666'.toColor())
                            .merge(AppTypography.body2),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(status, isCompleted, isProcessing, isFailed),
              ],
            ),
            if (reading.summary != null && reading.summary!.isNotEmpty) ...[
              Spacing.h(12),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: '#FFF8E1'.toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  reading.summary!,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: '#3E2723'.toColor(),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            Spacing.h(12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14.w, color: Colors.grey[600]),
                Spacing.w(4),
                AutoTranslateText(
                  dateStr,
                  style: MyTextTheme.smallBCN
                      .copyWith(color: Colors.grey[600])
                      .merge(AppTypography.label),
                ),
                Spacer(),
                Icon(Icons.chevron_right, size: 20.w, color: Colors.grey[400]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    String status,
    bool isCompleted,
    bool isProcessing,
    bool isFailed,
  ) {
    Color color;
    String text;

    if (isCompleted) {
      color = Colors.green;
      text = 'Completed';
    } else if (isProcessing) {
      color = Colors.orange;
      text = 'Processing';
    } else if (isFailed) {
      color = Colors.red;
      text = 'Failed';
    } else {
      color = Colors.grey;
      text = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: AutoTranslateText(
        text,
        style: MyTextTheme.smallBCN
            .copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            )
            .merge(AppTypography.label),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(date);
      }
    } catch (e) {
      return '';
    }
  }
}
