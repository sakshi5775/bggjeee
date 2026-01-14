import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class UserBottomNav extends StatelessWidget {
  final Function(int) onTap;
  const UserBottomNav({super.key, required this.onTap});

  static final LinearGradient _inactiveGradient = AppColors.orangeGradient;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UserMainController>();
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white, // White background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  index: 0,
                  selectedIndex: c.selectedIndex.value,
                  onTap: () => onTap(0),
                ),
                _buildNavItem(
                  icon: Icons.shopping_bag,
                  label: 'Shop',
                  index: 1,
                  selectedIndex: c.selectedIndex.value,
                  onTap: () => onTap(1),
                ),
                _buildNavItem(
                  icon: Icons.school,
                  label: 'Education',
                  index: 2,
                  selectedIndex: c.selectedIndex.value,
                  onTap: () => onTap(2),
                ),
                _buildNavItem(
                  icon: Icons.chat_bubble_outline,
                  label: 'Chats',
                  index: 3,
                  selectedIndex: c.selectedIndex.value,
                  onTap: () => onTap(3),
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  index: 4,
                  selectedIndex: c.selectedIndex.value,
                  onTap: () => onTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
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
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.orangeGradient : null,
            color: isSelected
                ? const Color(0xFFFFF8F0)
                : Colors.transparent, // Light yellow/cream for active
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected
                  ? Icon(icon, color: Colors.white, size: 22.w)
                  : ShaderMask(
                      shaderCallback: (bounds) =>
                          _inactiveGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Icon(icon, color: Colors.white, size: 22.w),
                    ),
              SizedBox(height: 2.h),
              isSelected
                  ? AutoTranslateText(
                      label,
                      style: AppTypography.label.copyWith(color: Colors.white),
                    )
                  : ShaderMask(
                      shaderCallback: (bounds) =>
                          _inactiveGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: AutoTranslateText(
                        label,
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
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
