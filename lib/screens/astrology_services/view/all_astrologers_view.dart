import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/all_astrologers_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrology_header_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/chat_initiation_helper.dart';
import 'package:astrobharataiuser/utils/call_initiation_helper.dart';

class AllAstrologersView extends StatelessWidget {
  final String? initialFilter;

  const AllAstrologersView({Key? key, this.initialFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AllAstrologersController(initialFilter: initialFilter),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFf8f0be), // Light cream background
      body: SafeArea(
        child: Column(
          children: [
            // Header and Filter Section (combined with curved bottom)
            _buildHeaderWithFilters(context, controller),

            // Astrologer List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.astrologers.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFDFB343)),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.astrologers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoTranslateText(
                          controller.errorMessage.value,
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: const Color(0xFF5F2221),
                          ),
                        ),
                        Spacing.h(16),
                        ElevatedButton(
                          onPressed: () => controller.refresh(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDFB343),
                          ),
                          child: const AutoTranslateText('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.astrologers.isEmpty) {
                  return Center(
                    child: AutoTranslateText(
                      'No astrologers found',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: const Color(0xFF5F2221),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  color: const Color(0xFFDFB343),
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    itemCount:
                        controller.astrologers.length +
                        (controller.hasMoreData.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.astrologers.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: Color(0xFFDFB343),
                            ),
                          ),
                        );
                      }
                      final astrologer = controller.astrologers[index];
                      return _buildAstrologerCard(
                        astrologer,
                        controller,
                        isFirst: index == 0,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithFilters(
    BuildContext context,
    AllAstrologersController controller,
  ) {
    return AstrologyHeaderWidget(
      padding: EdgeInsets.zero, // We'll handle padding in the content
      content: Column(
        children: [
          // Header Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white, // White color for back arrow
                    size: 24.w,
                  ),
                ),
                // Logo/App Name
                AutoTranslateText(
                  'AstroBharatAI',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: const Color(0xFFDFB343), // Gold color
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
                // Wallet and Cart icons
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.wallet);
                      },
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white, // White color
                        size: 24.w,
                      ),
                    ),
                    Spacing.w(16),
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white, // White color
                      size: 24.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filter Section
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
            child: SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = controller.filterOptions[index];

                  return Obx(() {
                    final isSelected =
                        controller.selectedFilter.value == filter;
                    return GestureDetector(
                      onTap: () => controller.setFilter(filter),
                      child: Container(
                        margin: EdgeInsets.only(right: 12.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors
                                    .white // White background when selected
                              : const Color(
                                  0xFF5D1C21,
                                ), // Dark maroon when not selected (matches parent)
                          borderRadius: BorderRadius.circular(20.r),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(
                                    0xFFDFB343,
                                  ), // Gold border when selected
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Center(
                          child: AutoTranslateText(
                            filter,
                            style: MyTextTheme.mediumBCN.copyWith(
                              color: isSelected
                                  ? const Color(
                                      0xFF5D1C21,
                                    ) // Dark maroon text when selected
                                  : Colors
                                        .white, // White text when not selected
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologerCard(
    AstrologerModel astrologer,
    AllAstrologersController controller, {
    bool isFirst = false,
  }) {
    final isOnline = astrologer.isOnline;
    final rating = astrologer.rating;
    final totalRatings = astrologer.totalRatings;
    final price = controller.getPrice(astrologer);
    final specializations = controller.getSpecializations(astrologer);
    final languages = controller.getLanguages(astrologer);
    final experience = '${astrologer.experienceYears} years';

    return GestureDetector(
      onTap: () {
        Get.toNamed('/astrologer-detail', arguments: astrologer);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white, // White background
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Profile Picture and Rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFDFB343), // Gold border
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: _buildImage(astrologer.profilePicture, size: 80),
                      ),
                    ),
                    // Online indicator
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 18.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50), // Green
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                        ),
                      ),
                  ],
                ),
                Spacing.h(8),
                // Rating Badge (below image, slightly offset to left)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFDFB343), // Gold border
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFFDFB343),
                        size: 14.w,
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        rating.toStringAsFixed(1),
                        style: MyTextTheme.smallBCB.copyWith(
                          color: const Color(0xFF5F2221),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.w(12),
            // Right Side: Details and Actions
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with verified checkmark
                  Row(
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          astrologer.displayName,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFF5F2221), // Dark maroon
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.verified, color: Colors.blue, size: 18.w),
                    ],
                  ),
                  Spacing.h(6),
                  // Specialization
                  AutoTranslateText(
                    specializations,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF5F2221), // Dark text
                    ),
                  ),
                  Spacing.h(6),
                  // Languages
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 14.w,
                        color: const Color(0xFF5F2221),
                      ),
                      Spacing.w(4),
                      Flexible(
                        child: AutoTranslateText(
                          languages,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF5F2221),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(6),
                  // Experience
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.w,
                        color: const Color(0xFF5F2221),
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        experience,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF5F2221),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(6),
                  // Rate with reviews
                  Row(
                    children: [
                      AutoTranslateText(
                        '₹',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF5F2221),
                        ),
                      ),
                      AutoTranslateText(
                        '$price (${totalRatings} reviews)',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF5F2221),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(12),
                  // Action Buttons
                  Row(
                    children: [
                      // Chat Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ChatInitiationHelper.initiateChat(astrologer);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDFB343), // Gold
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 18.w,
                              ),
                              Spacing.w(6),
                              AutoTranslateText(
                                'Chat',
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacing.w(8),
                      // Call Button
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFFDFB343),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            CallInitiationHelper.initiateVoiceCall(astrologer);
                          },
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.phone,
                            color: const Color(0xFF5F2221), // Dark maroon icon
                            size: 20.w,
                          ),
                        ),
                      ),
                      Spacing.w(8),
                      // Video Call Button
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFFDFB343),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            CallInitiationHelper.initiateVideoCall(astrologer);
                          },
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.videocam,
                            color: const Color(0xFF5F2221), // Dark maroon icon
                            size: 20.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, {double size = 80}) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'placeholder_url') {
      return Container(
        width: size.w,
        height: size.h,
        color: Colors.grey.withOpacity(0.3),
        child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withOpacity(0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withOpacity(0.3),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFFDFB343),
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withOpacity(0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
      );
    }
  }
}
