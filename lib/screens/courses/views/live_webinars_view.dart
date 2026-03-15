import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/common_tab_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/screens/courses/controllers/live_webinars_controller.dart';
import 'package:astrobharataiuser/data_model/webinar_model.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:intl/intl.dart';

import '../../../app_manager/network_image.dart';

class LiveWebinarsView extends GetView<LiveWebinarsController> {
  const LiveWebinarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              Obx(
                () => CommonHeader(
                  title: 'Live Webinars',
                  subtitle: AutoTranslateText(
                    '${controller.liveCount} Live • ${controller.upcomingCount} Upcoming',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF5F2221).withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),

              // Scrollable Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshWebinars,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Row / Quick Info (Optional - using dynamic counts)
                        // _buildStatsRow(), // Removing mock stats as per request
                        SizedBox(height: 24.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Color(0xFFFF9C09),
                                  width: 3.w,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(left: 8.w),
                            child: AutoTranslateText(
                              "Live Now",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF5F2221), // Dark brown
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Hero Section (Live Now)
                        _buildLiveNowSection(),

                        SizedBox(height: 24.h),

                        // Tabs (Upcoming & Recordings)
                        Obx(
                          () => CommonTabSlider(
                            tabs: const ["Live", "Upcoming", "Recordings"],
                            selectedIndex: controller.selectedTab.value,
                            onTabSelected: (index) =>
                                controller.selectedTab.value = index,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Content List
                        _buildContentList(),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveNowSection() {
    return Obx(() {
      if (controller.liveWebinars.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "No live webinars currently.",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      // Show ALL live webinars in a horizontal scrollable slider
      return SizedBox(
        height: 280.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.liveWebinars.length,
          itemBuilder: (context, index) {
            final webinar = controller.liveWebinars[index];

            return Container(
              width: 340.w,
              margin: EdgeInsets.only(right: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: NetworkImage(
                    webinar.thumbnail ??
                        webinar.courseId?.thumbnail ??
                        'https://via.placeholder.com/400x200?text=No+Image',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.4),
                    BlendMode.darken,
                  ),
                  onError: (_, __) {},
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4D4D), // Bright Red
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.videocam,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'LIVE NOW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${webinar.viewerStats?.currentViewers ?? 0} Watching',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    Center(
                      child: GestureDetector(
                        onTap: () => controller.joinWebinar(webinar),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFF9C09,
                            ).withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      webinar.title ?? 'Untitled Webinar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10.r,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              (webinar.hostImage != null &&
                                  webinar.hostImage!.isNotEmpty)
                              ? NetworkImage(webinar.hostImage!)
                              : null,
                          onBackgroundImageError:
                              (webinar.hostImage != null &&
                                  webinar.hostImage!.isNotEmpty)
                              ? (_, __) {}
                              : null,
                          child:
                              (webinar.hostImage == null ||
                                  webinar.hostImage!.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 12.sp,
                                )
                              : null,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            webinar.hostName ?? "Unknown Host",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (webinar.scheduling?.estimatedDurationMinutes !=
                            null)
                          Text(
                            "${webinar.scheduling!.estimatedDurationMinutes} min",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10.sp,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.joinWebinar(webinar),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, size: 16.sp),
                            SizedBox(width: 6.w),
                            Text(
                              'Join Now - LIVE',
                              style: TextStyle(
                                fontSize: 14.sp,
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
          },
        ),
      );
    });
  }

  Widget _buildContentList() {
    return Obx(() {
      // If tab is 0 (Live), maybe we don't show list or show other live items?
      // Assuming controller has logic.
      var list = controller.currentList;
      // If Live(0) is selected, maybe we show remaining live items not in Hero?
      // Or just all live items.

      if (controller.selectedTab.value == 0 && list.isNotEmpty) {
        // Skip first if it's in Hero?
        // For simplicity, showing all or maybe skipping if implemented.
        if (list.length > 1) {
          list = list.sublist(1);
        } else {
          list = []; // Only one live, shown in Hero
        }
      }

      if (list.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Text(
              controller.selectedTab.value == 0
                  ? "No other live webinars"
                  : 'No items found',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: list.length,
        separatorBuilder: (c, i) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          return _buildWebinarCard(list[index]);
        },
      );
    });
  }

  Widget _buildWebinarCard(WebinarModel webinar) {
    bool isUpcoming = controller.selectedTab.value == 1;
    bool isRecording = controller.selectedTab.value == 2;
    // bool isLive = controller.selectedTab.value == 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: NetworkImageWithLoader(
                  url: webinar.thumbnail ?? webinar.courseId?.thumbnail ?? '',
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (webinar.rsvpCount != null && webinar.rsvpCount! > 0)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      "${webinar.rsvpCount} Attending",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Details Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Scheduled Date / Tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (webinar.scheduling?.scheduledStartTime != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4E0),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          DateFormat('dd MMM, hh:mm a').format(
                            webinar.scheduling!.scheduledStartTime!.toLocal(),
                          ),
                          style: TextStyle(
                            color: const Color(0xFFEAA92A),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (webinar.isUpcoming == true)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "UPCOMING",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 8.h),

                Text(
                  webinar.title ?? "Unknown Title",
                  style: TextStyle(
                    color: const Color(0xFF5F2221),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          (webinar.hostImage != null &&
                              webinar.hostImage!.isNotEmpty)
                          ? NetworkImage(webinar.hostImage!)
                          : null,
                      onBackgroundImageError:
                          (webinar.hostImage != null &&
                              webinar.hostImage!.isNotEmpty)
                          ? (_, __) {}
                          : null,
                      child:
                          (webinar.hostImage == null ||
                              webinar.hostImage!.isEmpty)
                          ? Icon(Icons.person, size: 16.sp, color: Colors.grey)
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      webinar.hostName ?? "Unknown Host",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),

                    // Action Button
                    if (webinar.status == "LIVE")
                      ElevatedButton(
                        onPressed: () => controller.joinWebinar(webinar),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAA92A),
                          foregroundColor: Colors.white,
                          minimumSize: Size(80.w, 30.h),
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Join Now",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      )
                    else if (webinar.status == "PREPARING")
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Starting Soon",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else if (isUpcoming)
                      Obx(() {
                        bool isRsvped = controller.isRsvped(
                          webinar.webinarId ?? webinar.id!,
                        );
                        return ElevatedButton(
                          onPressed: () => controller.toggleRsvp(webinar),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRsvped
                                ? Colors.grey.shade300
                                : const Color(0xFFEAA92A),
                            foregroundColor: isRsvped
                                ? Colors.black87
                                : Colors.white,
                            minimumSize: Size(80.w, 30.h),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isRsvped ? "RSVP'd" : "Notify Me",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        );
                      }),

                    if (isRecording)
                      ElevatedButton(
                        onPressed: () {}, // Play recording
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5F2221),
                          foregroundColor: Colors.white,
                          minimumSize: Size(80.w, 30.h),
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text("Watch", style: TextStyle(fontSize: 12.sp)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
