import 'dart:math';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/widgets/offering_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';

class VirtualDarshanView extends GetView<VirtualDarshanController> {
  const VirtualDarshanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Vertical Image Reel - Center of screen
            Obx(
              () => Center(
                child: _buildVerticalImageReel(
                  controller.godsList[controller.currentGodIndex.value],
                ),
              ),
            ),
            IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: controller.aartiController,
                  builder: (_, __) {
                    if (!controller.aartiController.isAnimating) {
                      return const SizedBox();
                    }

                    final t = controller.aartiController.value;
                    const radius = 140.0;
                    final angle = 2 * pi * t;
                    final x = radius * cos(angle);
                    final y = radius * sin(angle);

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Image.asset(
                        AppConstant.eMandirAartiIcon,
                        width: 50.w,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 10.h,
              left: 10.w,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: _CircleIcon(Icons.arrow_back),
                  ),
                  SizedBox(width: 10.w),
                  AutoTranslateText(
                    'Virtual Darshan',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Positioned(
                top: 60.h,
                left: 12.w,
                right: 12.w,
                child: SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25.r,
                              backgroundImage: AssetImage(
                                controller
                                    .godsList[controller.currentGodIndex.value]
                                    .profileImage,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0.w),
                              child: AutoTranslateText(
                                controller
                                    .godsList[controller.currentGodIndex.value]
                                    .name,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.godsList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            final isSelected =
                                controller.currentGodIndex.value == index;
                            return GestureDetector(
                              onTap: () => controller.navigateToGod(index),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.orange,
                                          width: 3,
                                        )
                                      : null,
                                  gradient: const LinearGradient(
                                    colors: [Colors.orange, Colors.deepOrange],
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 24.r,
                                  backgroundImage: AssetImage(
                                    controller.godsList[index].profileImage,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => Positioned(
                bottom: 90.h,
                left: 18.w,
                child: InkWell(
                  onTap: () => _openOfferingBottomSheet(context),
                  child: Image.asset(controller.selectedOfferingIcon.value),
                ),
              ),
            ),
            Positioned(
              bottom: 90.h,
              right: 18.w,
              child: InkWell(
                onTap: () => controller.toggleAarti(context),
                child: Image.asset(AppConstant.eMandirAartiIcon),
              ),
            ),
            Positioned(
              bottom: 22.h,
              left: 18.w,
              child: InkWell(
                onTap: controller.playShankh,
                child: Image.asset(AppConstant.eMandirSankhIcon),
              ),
            ),
            Positioned(
              bottom: 22.h,
              right: 18.w,
              child: InkWell(
                onTap: controller.navigateToDevotionalLibrary,
                child: Image.asset(AppConstant.eMandirListenNowIcon),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AutoTranslateText(
                    'Listen Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalImageReel(god) {
    return PageView.builder(
      controller: controller.verticalPageController,
      scrollDirection: Axis.vertical,
      itemCount: god.galleryImages.length,
      itemBuilder: (context, index) {
        final imagePath = god.galleryImages[index];

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openOfferingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => OfferingBottomSheetWidget(
        onSelect: (item) {
          controller.handleOfferingSelection(item);
          // If flower was selected and aarti is playing, restart flower rain
          if (item.type == "Flower" && controller.aartiController.isAnimating) {
            controller.startFlowerRain(context);
          }
        },
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;

  const _CircleIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 26.sp),
    );
  }
}
