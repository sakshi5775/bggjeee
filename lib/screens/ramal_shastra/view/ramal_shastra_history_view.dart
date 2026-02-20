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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RamalShastraHistoryView extends StatefulWidget {
  const RamalShastraHistoryView({Key? key}) : super(key: key);

  @override
  State<RamalShastraHistoryView> createState() =>
      _RamalShastraHistoryViewState();
}

class _RamalShastraHistoryViewState extends State<RamalShastraHistoryView> {
  final RamalShastraController controller = Get.find<RamalShastraController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadHistory(refresh: true);
    });
  }

  Future<void> _deleteReading(String readingId, int index) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: AutoTranslateText('Delete Reading'),
        content: AutoTranslateText(
          'Are you sure you want to delete this reading?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: AutoTranslateText('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: AutoTranslateText(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.deleteReading(readingId, index);
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy â€¢ hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'History'),
            Expanded(child: Obx(() => _buildContent())),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (controller.isLoadingHistory.value &&
        controller.historyReadings.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>('#EA632B'.toColor()),
        ),
      );
    }

    if (controller.historyReadings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64.w, color: '#EA632B'.toColor()),
            Spacing.h(16),
            AutoTranslateText(
              'No reading history',
              style: MyTextTheme.largeBCB
                  .copyWith(color: '#3E2723'.toColor())
                  .merge(AppTypography.h2),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'Start your Ramal Shastra journey',
              style: MyTextTheme.mediumBCN.copyWith(color: '#666666'.toColor()),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadHistory(refresh: true),
      color: '#EA632B'.toColor(),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount:
            controller.historyReadings.length +
            (controller.pagination.value?.hasNextPage == true ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.historyReadings.length) {
            controller.loadMoreHistory();
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    '#EA632B'.toColor(),
                  ),
                ),
              ),
            );
          }

          final reading = controller.historyReadings[index];
          return _buildReadingCard(reading, index);
        },
      ),
    );
  }

  Widget _buildReadingCard(RamalShastraData reading, int index) {
    final outcome = reading.judgment?.outcome ?? 'Unknown';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRoutes.ramalShastraDetail,
            arguments: {'result': reading},
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: '#FFF2E8'.toColor(),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.casino,
                  color: '#EA632B'.toColor(),
                  size: 30.w,
                ),
              ),
              Spacing.w(16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AutoTranslateText(
                            reading.question ?? 'Ramal Shastra Reading',
                            style: MyTextTheme.mediumBCB
                                .copyWith(
                                  color: '#3E2723'.toColor(),
                                  fontWeight: FontWeight.bold,
                                )
                                .merge(AppTypography.h3),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: '#666666'.toColor(),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20.w,
                                  ),
                                  Spacing.w(8),
                                  AutoTranslateText(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  _deleteReading(
                                    reading.readingId ?? '',
                                    index,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacing.h(4),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: '#FFF2E8'.toColor(),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: AutoTranslateText(
                            outcome,
                            style: MyTextTheme.smallBCB.copyWith(
                              color: '#EA632B'.toColor(),
                            ),
                          ),
                        ),
                        Spacing.w(8),
                        Expanded(
                          child: AutoTranslateText(
                            _formatDate(reading.createdAt),
                            style: MyTextTheme.smallBCN.copyWith(
                              color: '#666666'.toColor(),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

