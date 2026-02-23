import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/ext/hex_color_ext.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/auto_translate_text.dart';

class AllAstrologerWidget extends BasePage<UserDashboardController> {
  const AllAstrologerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoadingLiveStreams.value;
      final astrologers = controller.allAstrologer;
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  "All Astrologers",
                  style: AppTypography.h2.copyWith(color: '#820B17'.toColor()),
                ),
                Spacing.w(16),
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.allAstrologers);
                    },
                    child: AutoTranslateText(
                      "View All",
                      style: AppTypography.body1.copyWith(
                        color: '#9D4807'.toColor(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(2),
          SizedBox(
            height: 100.h,
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => Spacing.w(8),
                    itemCount: astrologers.length,
                    padding: EdgeInsets.only(left: 16.w, right: 0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final astrologer = astrologers[index];
                      final astrologerName = astrologer.displayName.isNotEmpty
                          ? astrologer.displayName
                          : astrologer.name;
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.astrologerDetail,
                            arguments: {"astrologer": astrologer},
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 60.w,
                              height: 60.w,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 60.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // gradient: AppColors.orangeGradient,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60.w,
                                    height: 60.w,
                                    child: NetworkImageWithLoader(
                                      url: astrologer.profilePicture ?? '',
                                      width: 60.w,
                                      height: 60.w,
                                      isCircular: true,
                                    ),
                                  ),
                                  // Green dot indicator for online astrologers
                                  if (astrologer.isOnline)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 16.w,
                                        height: 16.w,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF4CAF50,
                                          ), // Green
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Spacing.h(1),
                            SizedBox(
                              width: 70.w,
                              child: AutoTranslateText(
                                astrologerName,
                                style: AppTypography.h3.copyWith(
                                  color: '#68171E'.toColor(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.currency_rupee,
                                  size: 9.w,
                                  color: AppColors.deepOrange,
                                ),
                                AutoTranslateText(
                                  '${astrologer.chatPricePerMin?.toInt() ?? 0}/min',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: AppColors.deepOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}

/// Same data as All Astrologers but in reversed order, for Chat/Call row.
class ChatCallAstrologerWidget extends BasePage<UserDashboardController> {
  const ChatCallAstrologerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoadingLiveStreams.value;
      final astrologers = controller.allAstrologer.reversed.toList();
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  "Astro Chat & Call",
                  style: AppTypography.h2.copyWith(color: '#820B17'.toColor()),
                ),
                Spacing.w(16),
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.allAstrologers);
                    },
                    child: AutoTranslateText(
                      "View All",
                      style: AppTypography.body1.copyWith(
                        color: '#9D4807'.toColor(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(2),
          SizedBox(
            height: 100.h,
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => Spacing.w(8),
                    itemCount: astrologers.length,
                    padding: EdgeInsets.only(left: 16.w, right: 0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final astrologer = astrologers[index];
                      final astrologerName = astrologer.displayName.isNotEmpty
                          ? astrologer.displayName
                          : astrologer.name;
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.astrologerDetail,
                            arguments: {"astrologer": astrologer},
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 60.w,
                                  height: 60.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,

                                    color: Colors.white,
                                  ),
                                ),
                                // NetworkImageWithLoader(
                                //   url: astrologer.profilePicture ?? '',
                                //   // width: 70.w,
                                //   // height: 70.h,
                                //   fit: BoxFit.cover,
                                //   isCircular: true,
                                // ),
                                Container(
                                  height: 60.w,
                                  width: 60.w,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: astrologer.profilePicture ?? '',
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.deepOrange,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.person,
                                            size: 35.w,
                                            color: Colors.grey[600],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // Green dot indicator for online astrologers
                                if (astrologer.isOnline)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 16.w,
                                      height: 16.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4CAF50), // Green
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Spacing.h(1),
                            SizedBox(
                              width: 70.w,
                              child: AutoTranslateText(
                                astrologerName,
                                style: AppTypography.h3.copyWith(
                                  color: '#68171E'.toColor(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.currency_rupee,
                                  size: 9.w,
                                  color: AppColors.deepOrange,
                                ),
                                AutoTranslateText(
                                  '${astrologer.chatPricePerMin?.toInt() ?? 0}/min',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: AppColors.deepOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
