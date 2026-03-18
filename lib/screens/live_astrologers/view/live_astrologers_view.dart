import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/screens/live_astrologers/controller/live_astrologers_controller.dart';
import 'package:astrobharataiuser/screens/live_stream/view/live_stream_view.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/common_tab_slider.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

import '../../../core/services/share_service.dart';

class LiveAstrologersView extends StatelessWidget {
  final bool showBackButton;

  const LiveAstrologersView({Key? key, this.showBackButton = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveAstrologersController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            // Header
            CommonHeader(
              title: 'Astro Live Streaming Hub',
              showBackButton: showBackButton,
              customActions: [
                GestureDetector(
                  onTap: () {
                    UserMainController.pushInCurrentTab(AppRoutes.streamReports);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Icon(
                      Icons.report_problem,
                      color: const Color(0xFF6F221E),
                      size: 24.w,
                    ),
                  ),
                ),
              ],
            ),

            // Tab Navigation
            Obx(
              () => CommonTabSlider(
                tabs: const ['ONGOING', 'UPCOMING'],
                selectedIndex: controller.selectedTab.value,
                onTabSelected: (index) => controller.switchTab(index),
              ),
            ),

            // Content based on selected tab
            Expanded(
              child: Obx(() {
                if (controller.selectedTab.value == 0) {
                  return _buildOngoingTab(controller);
                } else {
                  return _buildUpcomingTab(controller);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingTab(LiveAstrologersController controller) {
    return Obx(() {
      if (controller.isLoadingLiveStreams.value &&
          controller.liveStreams.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF5F2221)),
        );
      }

      if (controller.liveStreams.isEmpty) {
        if (controller.allAstrologers.isEmpty) {
          return Center(
            child: AutoTranslateText(
              'No astrologers at the moment',
              style: MyTextTheme.mediumBCN.copyWith(
                color: const Color(0xFF5F2221),
              ),
            ),
          );
        }
        return _buildOfflineAstrologersGrid(controller);
      }

      return RefreshIndicator(
        onRefresh: controller.loadLiveStreams,
        color: const Color(0xFF5F2221),
        child: GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.68,
          ),
          itemCount: controller.liveStreams.length,
          itemBuilder: (context, index) {
            final stream = controller.liveStreams[index];
            return _buildOngoingCard(controller, stream, context);
          },
        ),
      );
    });
  }

  Widget _buildOngoingCard(
    LiveAstrologersController controller,
    LiveStreamModel stream,
    BuildContext context,
  ) {
    final profilePicture =
        stream.astrologerPhoto ??
        controller.getProfilePictureForAstrologer(stream.astrologerId);
    final astrologerName = stream.astrologerName != 'Unknown'
        ? stream.astrologerName
        : controller.getAstrologerName(stream.astrologerId);

    return GestureDetector(
      onTap: () async {
        // Check if user is logged in before accessing live stream
        final isLoggedIn = await LoginGuard.ensureLoggedIn(
          message: 'Please login to watch live streams.',
          onLoginSuccess: () {
            // Navigate to live stream after successful login
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/live-stream-view'),
                builder: (_) => LiveStreamView(
                  stream: stream,
                  astrologerName: astrologerName,
                  astrologerProfilePicture: profilePicture,
                ),
              ),
            );
          },
        );

        if (isLoggedIn) {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/live-stream-view'),
              builder: (_) => LiveStreamView(
                stream: stream,
                astrologerName: astrologerName,
                astrologerProfilePicture: profilePicture,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile picture with LIVE badge
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: profilePicture != null
                      ? NetworkImageWithLoader(
                          url: profilePicture,
                          width: 80.w,
                          height: 80.w,
                          isCircular: false,
                        )
                      : Container(
                          width: 80.w,
                          height: 80.w,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 40.w,
                            color: Colors.grey[600],
                          ),
                        ),
                ),
                // LIVE badge at bottom-left
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4.r),
                        bottomLeft: Radius.circular(12.r),
                      ),
                    ),
                    child: AutoTranslateText(
                      'LIVE',
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.label),
                    ),
                  ),
                ),
              ],
            ),
            Spacing.h(8),
            // Astrologer name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: AutoTranslateText(
                astrologerName,
                translate: false,
                style: MyTextTheme.smallBCB
                    .copyWith(
                      color: const Color(0xFF68171E),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    )
                    .merge(AppTypography.h3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineAstrologersGrid(LiveAstrologersController controller) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: const Color(0xFF5F2221),
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.68,
        ),
        itemCount: controller.allAstrologers.length,
        itemBuilder: (context, index) {
          final astrologer = controller.allAstrologers[index];
          return GestureDetector(
            onTap: () {
              UserMainController.pushInCurrentTab('/astrologer-detail', arguments: astrologer);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: astrologer.profilePicture != null
                            ? NetworkImageWithLoader(
                                url: astrologer.profilePicture!,
                                width: 80.w,
                                height: 80.w,
                                isCircular: false,
                              )
                            : Container(
                                width: 80.w,
                                height: 80.w,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: 40.w,
                                  color: Colors.grey[600],
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4.r),
                              bottomLeft: Radius.circular(12.r),
                            ),
                          ),
                          child: AutoTranslateText(
                            'OFFLINE',
                            style: MyTextTheme.smallBCB
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8.sp,
                                )
                                .merge(AppTypography.label),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: AutoTranslateText(
                      astrologer.displayName.isNotEmpty
                          ? astrologer.displayName
                          : astrologer.name,
                      translate: false,
                      style: MyTextTheme.smallBCB
                          .copyWith(
                            color: const Color(0xFF68171E),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          )
                          .merge(AppTypography.h3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingTab(LiveAstrologersController controller) {
    return Obx(() {
      if (controller.isLoadingUpcomingStreams.value &&
          controller.upcomingStreams.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF5F2221)),
        );
      }

      if (controller.upcomingStreams.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No upcoming streams scheduled',
            style: MyTextTheme.mediumBCN.copyWith(
              color: const Color(0xFF5F2221),
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadUpcomingStreams,
        color: const Color(0xFF5F2221),
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.upcomingStreams.length,
          itemBuilder: (context, index) {
            final stream = controller.upcomingStreams[index];
            return _buildUpcomingCard(controller, stream);
          },
        ),
      );
    });
  }

  Widget _buildUpcomingCard(
    LiveAstrologersController controller,
    UpcomingStreamModel stream,
  ) {
    final profilePicture = controller.getUpcomingProfilePictureForAstrologer(
      stream.astrologerId,
    );
    final astrologerName = controller.getUpcomingAstrologerName(
      stream.astrologerId,
    );
    final scheduledTime = stream.scheduling.scheduledStartTime;
    final dateFormat = DateFormat('dd MMM, EEEE | hh:mm a', 'en_US');

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile picture with green dot
          Stack(
            children: [
              ClipOval(
                child: profilePicture != null
                    ? NetworkImageWithLoader(
                        url: profilePicture,
                        width: 60.w,
                        height: 60.w,
                        isCircular: true,
                      )
                    : Container(
                        width: 60.w,
                        height: 60.w,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 30.w,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
              // Green dot indicator
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacing.w(12),
          // Name, specialization, and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  astrologerName,
                  translate: false,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: const Color(0xFF68171E),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      )
                      .merge(AppTypography.h3),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  stream.scheduling.description.isNotEmpty
                      ? stream.scheduling.description
                      : (stream.scheduling.title.isNotEmpty
                            ? stream.scheduling.title
                            : 'Live Session'),
                  style: MyTextTheme.smallBCN.copyWith(color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacing.h(4),
                AutoTranslateText(
                  dateFormat.format(scheduledTime),
                  style: MyTextTheme.smallBCN.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          Spacing.w(8),
          // Share icon
          GestureDetector(
            onTap: () {
              ShareService.shareAstrologer(
                astrologerId: stream.astrologerId,
                astrologerName: astrologerName,
              );
            },
            child: Icon(
              Icons.share,
              color: const Color(0xFF5F2221),
              size: 24.w,
            ),
          ),
        ],
      ),
    );
  }
}
