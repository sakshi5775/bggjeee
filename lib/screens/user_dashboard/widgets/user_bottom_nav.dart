import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/core/controllers/global_nav_controller.dart';

class UserBottomNav extends StatelessWidget {
  const UserBottomNav({super.key});

  static final LinearGradient _inactiveGradient = AppColors.orangeGradient;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<GlobalNavController>();
    return Obx(() {
      final items = c.navItems;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _buildNavItem(
                icon: items[index].icon,
                label: items[index].label,
                index: index,
                selectedIndex: c.selectedIndexRx.value,
                onTap: () => c.onTabClick(index),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            // gradient: isSelected ? AppColors.orangeGradient : null,
            color: isSelected
                ? const Color.fromARGB(255, 247, 219, 187)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected
                  ? NetworkImageWithLoader(url: icon, height: 20.h, width: 20.w)
                  : ShaderMask(
                      shaderCallback: (bounds) =>
                          _inactiveGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: NetworkImageWithLoader(
                        url: icon,
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
              SizedBox(height: 2.h),
              Flexible(
                child:
                    // isSelected
                    //     ? AutoTranslateText(
                    //         label,
                    //         style: AppTypography.label.copyWith(
                    //           color: Colors.white,
                    //           fontSize: 10.sp,
                    //         ),
                    //         maxLines: 1,
                    //         overflow: TextOverflow.ellipsis,
                    //       )
                    //     :
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          _inactiveGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: AutoTranslateText(
                        label,
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
