import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/book_puja_controller.dart';

class BookPujaHeaderWidget extends StatelessWidget {
  const BookPujaHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookPujaController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Common Header
        const CommonHeader(title: 'Book Your Pooja'),
        // Search field
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(
            () => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                focusNode: controller.searchFocusNode,
                onSubmitted: (value) => controller.onSearch(value),
                decoration: InputDecoration(
                  hintText: 'Search pujas...',
                  hintStyle: MyTextTheme.mediumBCN.copyWith(
                    color: const Color(0xFF999999),
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.orangeGradient.colors.first,
                    size: 24.r,
                  ),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 20.r),
                          color: const Color(0xFF999999),
                          onPressed: () => controller.clearSearch(),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
