import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/festival_filtered_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class FestivalFilteredView extends BasePage<FestivalFilteredController> {
  const FestivalFilteredView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            // Header
            Obx(() => CommonHeader(title: controller.festivalName.value)),

            // Festival List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: "#DFB343".toColor(),
                    ),
                  );
                }

                final festivals = controller.filteredFestivals;

                if (festivals.isEmpty) {
                  return Center(
                    child: AutoTranslateText(
                      'No festivals found',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: "#6F221E".toColor().withValues(alpha: 0.6),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount: festivals.length,
                  itemBuilder: (context, index) {
                    final item = festivals[index];
                    final dateStr = item['date'] as String;
                    final festival = item['festival'] as Map<String, dynamic>;

                    // Parse date
                    DateTime? date;
                    try {
                      final parts = dateStr.split('/');
                      if (parts.length == 3) {
                        date = DateTime(
                          int.parse(parts[0]),
                          int.parse(parts[1]),
                          int.parse(parts[2]),
                        );
                      }
                    } catch (e) {
                      // Invalid date format
                    }

                    final dayNumber = date != null ? date.day : 0;
                    final monthName = date != null
                        ? DateFormat('MMM').format(date).toUpperCase()
                        : '';
                    final dayName = date != null
                        ? DateFormat('EEEE').format(date)
                        : '';

                    // Alternate between orange and yellow
                    final isOrange = index % 2 == 0;
                    final badgeColor = isOrange
                        ? Colors.orange.shade600
                        : Colors.yellow.shade700;

                    return _buildFestivalCard(
                      dayNumber: dayNumber,
                      monthName: monthName,
                      dayName: dayName,
                      festival: festival,
                      dateStr: dateStr,
                      date: date,
                      badgeColor: badgeColor,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFestivalCard({
    required int dayNumber,
    required String monthName,
    required String dayName,
    required Map<String, dynamic> festival,
    required String dateStr,
    DateTime? date,
    required Color badgeColor,
  }) {
    return GestureDetector(
      onTap: () =>
          _navigateToFestivalDetail(festival, dateStr, dayNumber, dayName),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Date Badge (hexagonal/diamond shape)
            Container(
              width: 60.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoTranslateText(
                    dayNumber.toString(),
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    monthName,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.w(16),
            // Festival Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    festival['name']?.toString() ?? 'Festival',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    dayName,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor().withValues(alpha: 0.7),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.w(8),
            // Three dots
            GestureDetector(
              onTap: () => _showCalendarOptions(
                festival,
                dateStr,
                dayNumber,
                dayName,
                date,
              ),
              child: Icon(
                Icons.more_vert,
                color: "#6F221E".toColor().withValues(alpha: 0.5),
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFestivalDetail(
    Map<String, dynamic> festival,
    String dateStr,
    int dayNumber,
    String dayName,
  ) {
    UserMainController.pushInCurrentTab(
      AppRoutes.festivalDetail,
      arguments: {
        'festival': festival,
        'date': dateStr,
        'dayNumber': dayNumber,
        'dayName': dayName,
        'location': controller.location.value,
        'latitude': null,
        'longitude': null,
        'timezone': null,
      },
    );
  }

  void _showCalendarOptions(
    Map<String, dynamic> festival,
    String dateStr,
    int dayNumber,
    String dayName,
    DateTime? date,
  ) {
    final eventDate = date ?? DateTime.now();

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          _buildCalendarOptionsSheet(festival, eventDate, dayNumber, dayName),
    );
  }

  Widget _buildCalendarOptionsSheet(
    Map<String, dynamic> festival,
    DateTime eventDate,
    int dayNumber,
    String dayName,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Spacing.h(16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AutoTranslateText(
                  'Add to Calendar',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacing.h(16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutoTranslateText(
                              festival['name']?.toString() ?? 'Festival',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: "#6F221E".toColor(),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.h(8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16.w,
                                  color: "#6F221E".toColor().withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                Spacing.w(8),
                                Flexible(
                                  child: AutoTranslateText(
                                    DateFormat(
                                      'EEEE, MMMM dd, yyyy',
                                    ).format(eventDate),
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: "#6F221E".toColor().withOpacity(
                                        0.7,
                                      ),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (festival['description'] != null) ...[
                              Spacing.h(8),
                              AutoTranslateText(
                                festival['description']?.toString() ?? '',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: "#6F221E".toColor().withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 12.sp,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Spacing.h(16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _addToCalendar(festival, eventDate),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: "#DFB343".toColor(),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 20.w,
                              ),
                              Spacing.w(8),
                              Flexible(
                                child: AutoTranslateText(
                                  'Add to Calendar',
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacing.h(12),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: AutoTranslateText(
                          'This will open your default calendar app to save the event',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addToCalendar(
    Map<String, dynamic> festival,
    DateTime eventDate,
  ) async {
    try {
      final event = Event(
        title: festival['name']?.toString() ?? 'Hindu Festival',
        description: festival['description']?.toString() ?? '',
        location: controller.location.value,
        startDate: DateTime(
          eventDate.year,
          eventDate.month,
          eventDate.day,
          0,
          0,
        ),
        endDate: DateTime(
          eventDate.year,
          eventDate.month,
          eventDate.day,
          23,
          59,
        ),
        allDay: true,
        iosParams: const IOSParams(reminder: Duration(minutes: 15)),
        androidParams: const AndroidParams(emailInvites: []),
      );

      await Add2Calendar.addEvent2Cal(event);

      Get.back();
      Get.snackbar(
        'Success',
        'Event added to calendar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.back();

      String errorMessage = 'Failed to add event to calendar';
      if (e.toString().contains('MissingPluginException')) {
        errorMessage =
            'Calendar plugin not initialized. Please rebuild the app after running "flutter pub get"';
      } else {
        errorMessage = 'Failed to add event to calendar: ${e.toString()}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }
}
