import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/core/localization/translations.dart' as AppTranslations;
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/blogs/controller/all_blogs_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatelessWidget {
  final AllBlogsController controller;

  const SearchBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppMargin.only(bottom: 16),
      child: MyTextField(
        controller: TextEditingController(text: controller.searchQuery.value),
        hintText: AppTranslations.Translations.searchArticlesByTitle,
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.textSecondary,
          size: 20.h,
        ),
        suffixIcon: controller.searchQuery.value.isNotEmpty
            ? GestureDetector(
                onTap: controller.clearSearch,
                child: Icon(
                  Icons.clear,
                  color: AppColors.textSecondary,
                  size: 20.h,
                ),
              )
            : null,
        onChanged: (value) {
          controller.searchQuery.value = value;
          // Debounce search
          Future.delayed(const Duration(milliseconds: 500), () {
            if (controller.searchQuery.value == value) {
              controller.searchBlogs(value);
            }
          });
        },
        filled: true,
        filledColor: AppColors.lightBackground,
        borderRadius: AppRadius.all(25),
        headerText: null,
      ),
    );
  }
}
