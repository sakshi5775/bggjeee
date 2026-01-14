import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  "All Astrologers",
                  style: AppTypography.h2.copyWith(color: '#820B17'.toColor()),
                ),
                Spacing.w(16),
                AutoTranslateText(
                  "View All",
                  style: AppTypography.body1.copyWith(
                    color: '#9D4807'.toColor(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              separatorBuilder: (context, index) => Spacing.w(8),
              itemCount: controller.allAstrologer.length,
              padding: AppPaddings.symmetric(h: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.deepOrange, width: 1),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.astrologerDetail,
                            arguments: {
                              "astrologer": controller.allAstrologer[index],
                            },
                          );
                        },
                        child: NetworkImageWithLoader(
                          url:
                              controller.allAstrologer[index].profilePicture ??
                              '',
                          width: 70,
                          height: 70,
                          isCircular: true,
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
