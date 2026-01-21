import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
                  label: 'Digital Mart',
                  index: 1,
                  selectedIndex: c.selectedIndex.value,
                  onTap: () => onTap(1),
                ),
                _buildNavItemWithImage(
                  imagePath: 'assets/app/digital_mandir.png',
                  label: 'Digital Mandir',
                  index: 2,
                  selectedIndex: c.selectedIndex.value,
                  onTap: () {
                    Get.toNamed('/book-puja');
                  },
                ),
                _buildNavItem(
                  icon: Icons.person,
                  label: 'Consult',
                  index: 3,
                  selectedIndex: c.selectedIndex.value,
                  onTap: () {
                    Get.toNamed('/astrology-services');
                  },
                ),
                _buildNavItem(
                  icon: Icons.school,
                  label: 'Digital Education',
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
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
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
                  ? Icon(icon, color: Colors.white, size: 20.w)
                  : ShaderMask(
                      shaderCallback: (bounds) =>
                          _inactiveGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Icon(icon, color: Colors.white, size: 20.w),
                    ),
              SizedBox(height: 2.h),
              Flexible(
                child: isSelected
                    ? AutoTranslateText(
                        label,
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemWithImage({
    required String imagePath,
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
            gradient: isSelected ? AppColors.orangeGradient : null,
            color: isSelected
                ? const Color(0xFFFFF8F0)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected
                  ? Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          imagePath,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image, color: Colors.white, size: 20.w);
                          },
                        ),
                      ),
                    )
                  : ShaderMask(
                      shaderCallback: (bounds) =>
                          _inactiveGradient.createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Image.asset(
                        imagePath,
                        width: 20.w,
                        height: 20.w,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image, size: 20.w);
                        },
                      ),
                    ),
              SizedBox(height: 2.h),
              Flexible(
                child: isSelected
                    ? AutoTranslateText(
                        label,
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
