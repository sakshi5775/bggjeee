import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/ai_chat/controllers/ai_chat_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoryFilterChips extends BasePage<AiChatController> {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              // Menu icon (toggle grid/list view)
              GestureDetector(
                onTap: () => controller.toggleViewMode(),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Obx(
                    () => Icon(
                      controller.isGridView.value ? Icons.view_list : Icons.grid_view,
                      size: 20.w,
                      color: const Color(0xFF5F2221),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // All filter - always show this
              _buildFilterChip(
                label: 'All',
                isSelected: controller.selectedCategory.value == null,
                onTap: () => controller.clearFilter(),
                icon: null,
              ),
              SizedBox(width: 8.w),
              // Category filters with icons - dynamically show all categories from API
              if (controller.categories.isNotEmpty)
                ...controller.categories.map(
                  (category) => Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: _buildFilterChip(
                      label: category.label,
                      isSelected: controller.selectedCategory.value?.value ==
                          category.value,
                      onTap: () => controller.filterByCategory(category),
                      icon: _getCategoryIcon(category.value),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.orangeGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : const Color(0xFFE0E0E0),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: '#F38B3B'.toColor().withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16.w,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF666666),
              ),
              SizedBox(width: 6.w),
            ],
            AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF666666),
                fontWeight: FontWeight.w600,
              ).merge(AppTypography.body2),
            ),
          ],
        ),
      ),
    );
  }

  IconData? _getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'RELATIONSHIP_COUNSELOR':
      case 'LOVE':
        return Icons.favorite;
      case 'CAREER_GUIDANCE':
      case 'CAREER':
        return Icons.work;
      case 'MARRIAGE':
        return Icons.favorite_border;
      case 'HEALTH_ASTROLOGY':
      case 'HEALTH':
        return Icons.health_and_safety;
      case 'VEDIC_EXPERT':
      case 'VEDIC':
        return Icons.auto_awesome;
      case 'NUMEROLOGIST':
      case 'NUMEROLOGY':
        return Icons.numbers;
      case 'TAROT_READER':
      case 'TAROT':
        return Icons.style;
      case 'PALMISTRY':
        return Icons.handyman;
      case 'VASTU_CONSULTANT':
      case 'VASTU':
        return Icons.home;
      case 'GEMOLOGY_EXPERT':
      case 'GEMOLOGY':
        return Icons.diamond;
      case 'LIFE_COACH':
      case 'COACH':
        return Icons.psychology;
      case 'SPIRITUAL_GUIDE':
      case 'SPIRITUAL':
        return Icons.spa;
      default:
        return null;
    }
  }
}
