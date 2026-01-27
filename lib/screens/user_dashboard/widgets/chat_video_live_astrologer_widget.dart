import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
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
      if (controller.isLoadingLiveStreams.value) {
        return Container();
      }
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
            child: ListView.separated(
              separatorBuilder: (context, index) => Spacing.w(8),
              itemCount: controller.allAstrologer.length,
              padding: EdgeInsets.only(left: 16.w, right: 0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final astrologer = controller.allAstrologer[index];
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
                        width: 74.w,
                        height: 74.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 74.w,
                              height: 74.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.orangeGradient,
                              ),
                            ),
                            ClipOval(
                              child: SizedBox(
                                width: 70.w,
                                height: 70.h,
                                child: NetworkImageWithLoader(
                                  url: astrologer.profilePicture ?? '',
                                  width: 70.w,
                                  height: 70.h,
                                  isCircular: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacing.h(4),
                      SizedBox(
                        width: 70.w,
                        child: AutoTranslateText(
                          astrologerName,
                          style: AppTypography.body2.copyWith(
                            color: '#3D0C11'.toColor(),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
