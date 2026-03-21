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
    if (!Get.isRegistered<GlobalNavController>()) {
      return const SizedBox.shrink();
    }
    final c = Get.find<GlobalNavController>();
    return Obx(() {
      final activeSubIndex = c.activeSubMenuIndex.value;
      final showSubMenu = activeSubIndex != null;

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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: showSubMenu
              ? _buildSubMenu(context, c, activeSubIndex)
              : _buildMainMenu(c),
        ),
      );
    });
  }

  Widget _buildMainMenu(GlobalNavController c) {
    final items = c.navItems;
    return Container(
      key: const ValueKey('main_menu'),
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
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
    );
  }

  Widget _buildSubMenu(
    BuildContext context,
    GlobalNavController c,
    int parentIndex,
  ) {
    final subs = c.subMenuItems[parentIndex] ?? [];
    return Container(
      key: ValueKey('sub_menu_$parentIndex'),
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Row(
        children: [
          // Home button always stays
          _buildNavItem(
            icon: c.navItems[0].icon,
            label: 'Home',
            index: 0,
            selectedIndex: c.selectedIndexRx.value,
            onTap: () => c.onTabClick(0),
            isSmall: true,
          ),
          const VerticalDivider(width: 1, indent: 10, endIndent: 10),
          Expanded(
            child: Obx(() {
              // Ensure observable is read to prevent GetX "improper use" exception
              final activeIndex = c.activeSubItemIndex.value;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth:
                        MediaQuery.of(context).size.width -
                        90.w, // Accounts for Home button and divider space
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(subs.length, (index) {
                      final sub = subs[index];
                      final isSelected = activeIndex == index;
                      return _buildSubItem(
                        icon: sub['icon'] as IconData,
                        label: sub['label'] as String,
                        isSelected: isSelected,
                        onTap: () => c.onSubItemClick(index),
                      );
                    }),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSubItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 75.w,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          decoration: BoxDecoration(
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
                  ? Icon(icon, size: 20.h, color: AppColors.deepOrange)
                  : ShaderMask(
                      shaderCallback: (bounds) =>
                          _inactiveGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Icon(icon, size: 20.h, color: Colors.white),
                    ),
              SizedBox(height: 2.h),
              Flexible(
                child: isSelected
                    ? AutoTranslateText(
                        label,
                        style: AppTypography.label.copyWith(
                          color: AppColors.deepOrange,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      )
                    : ShaderMask(
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
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
    bool isSmall = false,
  }) {
    final isSelected = index == selectedIndex;
    return Container(
      width: isSmall ? 65.w : null,
      constraints: BoxConstraints(minWidth: isSmall ? 65.w : 70.w),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          decoration: BoxDecoration(
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
                child: ShaderMask(
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
                    textAlign: TextAlign.center,
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
