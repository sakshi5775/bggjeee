import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/localization/translations.dart'
    as AppTranslations;
import 'package:astrobharataiuser/core/value/dimension.dart';

import 'package:astrobharataiuser/screens/blogs/controller/all_blogs_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FilterChips extends StatelessWidget {
  final AllBlogsController controller;

  const FilterChips({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.filterOptions.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;
            return Container(
              margin: AppMargin.only(right: 8),
              child: GestureDetector(
                onTap: () => controller.filterBlogs(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: AppPaddings.symmetric(h: 16, v: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.saffron : AppColors.cardLight,
                    borderRadius: AppRadius.all(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.saffron
                          : AppColors.dividerLight,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.saffron.withValues(alpha: 0.3),
                              blurRadius: 8.r,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 4.r,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: LocalizedText(
                    text: _getFilterDisplayName(filter),
                    style: MyTextTheme.smallBCB.copyWith(
                      color: isSelected
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'all':
        return AppTranslations.Translations.all;
      case 'published':
        return AppTranslations.Translations.published;
      case 'draft':
        return AppTranslations.Translations.drafts;
      case 'under_review':
        return AppTranslations.Translations.underReview;
      default:
        return filter;
    }
  }
}
