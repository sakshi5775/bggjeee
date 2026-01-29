import 'dart:math';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
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
            // Vertical Image Reel - Center of screen (like Instagram Reels)
            Obx(
              () => controller.godsCount == 0
                  ? const Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      controller: controller.verticalPageController,
                      scrollDirection: Axis.vertical,
                      itemCount: controller.godsCount,
                      onPageChanged: (index) {
                        controller.currentGodIndex.value = index;
                      },
                      itemBuilder: (context, index) {
                        final imageUrl = controller.getGodImageAt(index);
                        return _buildGodImageDisplay(imageUrl);
                      },
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
                      child: SvgAssets(
                        path: AppConstant.eMandirThaliIcon,
                        height: 50.h,
                        width: 50.w,
                        colorFilter: ColorFilter.mode(
                          AppColors.deepOrange,
                          BlendMode.srcIn,
                        ),
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
              () => controller.godsCount == 0
                  ? const SizedBox.shrink()
                  : Positioned(
                      top: 60.h,
                      left: 12.w,
                      right: 2.w,
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
                                    radius: 20.r,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage:
                                        controller.currentGodImage.startsWith(
                                          'http',
                                        )
                                        ? NetworkImage(
                                            controller.currentGodImage,
                                          )
                                        : AssetImage(controller.currentGodImage)
                                              as ImageProvider,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0.w),
                                    child: AutoTranslateText(
                                      controller.currentGodName,
                                      style: AppTypography.body1.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
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
                                itemCount: controller.godsCount,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) {
                                  final isSelected =
                                      controller.currentGodIndex.value == index;
                                  final godImage = controller.getGodImageAt(
                                    index,
                                  );
                                  return GestureDetector(
                                    onTap: () =>
                                        controller.navigateToGod(index),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: isSelected
                                            ? Border.all(
                                                color: Colors.orange,
                                                width: 3,
                                              )
                                            : null,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.orange,
                                            Colors.deepOrange,
                                          ],
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Container(
                                          width: 50.r,
                                          height: 40.r,
                                          color: Colors.grey.shade200,
                                          child: godImage.startsWith('http')
                                              ? Image.network(
                                                  godImage,
                                                  fit: BoxFit.fill,
                                                  width: 40.r,
                                                  height: 40.r,
                                                  errorBuilder: (_, __, ___) =>
                                                      Icon(
                                                        Icons.person,
                                                        size: 24.r,
                                                      ),
                                                )
                                              : Image.asset(
                                                  godImage,
                                                  fit: BoxFit.cover,
                                                  width: 50.r,
                                                  height: 40.r,
                                                ),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child:
                          controller.selectedOfferingIcon.value.startsWith(
                            'http',
                          )
                          ? Image.network(
                              controller.selectedOfferingIcon.value,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Image.asset(AppConstant.eMandirLadduIcon),
                            )
                          : Image.asset(controller.selectedOfferingIcon.value),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 90.h,
              right: 18.w,
              child: InkWell(
                onTap: () => controller.toggleAarti(context),
                child: SvgAssets(path: AppConstant.eMandirThali2Icon),
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

  Widget _buildGodImageDisplay(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.black),
      child: imageUrl.startsWith('http')
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.orange,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            )
          : Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
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
      builder: (sheetContext) => OfferingBottomSheetWidget(
        onSelect: (item) {
          controller.handleOfferingSelection(item);
          // If flower/garland was selected, start a brief flower rain animation
          final slug = controller.currentCategorySlug;
          if (slug == 'flowers' || slug == 'garland') {
            // Start flower rain burst (1 second animation)
            controller.startFlowerRainBurst(context);
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
