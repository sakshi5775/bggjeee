import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/ai_chat/controllers/ai_chat_controller.dart';

import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchBarWidget extends BasePage<AiChatController> {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: AppRadius.all(12),
        border: Border.all(color: AppColors.dividerLight, width: 1),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: (value) => controller.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: 'Search personas by name, description, or tags...',
          hintStyle: MyTextTheme.smallBCN.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 20.h,
          ),
          suffixIcon: Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                      size: 20.h,
                    ),
                    onPressed: () {
                      controller.searchQuery.value = '';
                      controller.searchController.clear();
                    },
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding: AppPaddings.symmetric(h: 16, v: 12),
        ),
        style: MyTextTheme.smallBCN.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
