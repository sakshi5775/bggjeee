import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/book_puja/controller/book_puja_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookPujaHeaderWidget extends StatelessWidget {
  const BookPujaHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookPujaController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF3E2723),
            ),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(height: 8),
          // Title
          Center(
            child: AutoTranslateText(
              'Book Your Puja',
              style: MyTextTheme.veryLargeBCB.copyWith(
                color: const Color(0xFF3E2723),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Center(
            child: AutoTranslateText(
              'Choose from daily rituals, dosh nivaran, havan & special pujas.',
              style: MyTextTheme.mediumBCN.copyWith(
                color: const Color(0xFF666666),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          // Search field
          Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.orangeGradient.colors.first,
                      size: 24,
                    ),
                    suffixIcon: controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            color: const Color(0xFF999999),
                            onPressed: () => controller.clearSearch(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
