import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/svg_assets.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/all_astrologers_controller.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/booking_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme/app_typography.dart';

class AllAstrologersView extends StatelessWidget {
  final String? initialFilter;
  final bool hideHeader;

  const AllAstrologersView({
    Key? key,
    this.initialFilter,
    this.hideHeader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a separate controller for embedded tab (hideHeader) vs full-screen
    // to avoid "ScrollController attached to multiple scroll views".
    final tag = hideHeader ? 'consult_tab' : null;
    final controller = Get.put<AllAstrologersController>(
      AllAstrologersController(initialFilter: initialFilter),
      tag: tag,
    );

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: !hideHeader,
          child: Column(
            children: [
              if (hideHeader)
                _buildFiltersOnly(context, controller)
              else
                _buildHeaderWithFilters(context, controller),

              // Astrologer List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.astrologers.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFDFB343),
                      ),
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

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification n) {
                      if (n is ScrollUpdateNotification ||
                          n is ScrollEndNotification) {
                        controller.onScrollMetrics(n.metrics);
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: controller.refresh,
                      color: const Color(0xFFDFB343),
                      child: ListView.builder(
                        primary: !hideHeader,
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
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersOnly(
    BuildContext context,
    AllAstrologersController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 0, 16.h),
        child: SizedBox(
          height: 36.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(right: 16.w),
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
                      color: isSelected ? Colors.white : Color(0xFF5D1C21),
                      borderRadius: BorderRadius.circular(8.r),
                      border: isSelected
                          ? Border.all(color: '#DEAF3E'.toColor(), width: 1)
                          : null,
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        filter,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: isSelected
                              ? '#DDAF3E'.toColor()
                              : Colors.white,
                          height: 1,
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
    );
  }

  Widget _buildHeaderWithFilters(
    BuildContext context,
    AllAstrologersController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
      ),
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.templeGold,
                      size: 20.w,
                    ),
                  ),
                ),
                Spacing.w(16),
                // Logo/App Name - Split into three parts
                SvgAssets(
                  path: 'assets/app/AstrobharatAi .svg',
                  width: 150.w,
                  height: 30.h,
                  colorFilter: ColorFilter.mode(
                    '#D9AB3B'.toColor(),
                    BlendMode.srcIn,
                  ),
                ),
                Spacer(),
                // Right Accessory (Wallet and Cart)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.wallet),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: AppColors.templeGold,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.cart),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: AppColors.templeGold,
                          size: 20.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filter Section
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 0, 20.h),
            child: SizedBox(
              height: 36.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(right: 16.w),
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
                          color: isSelected ? Colors.white : Color(0xFF5D1C21),
                          borderRadius: BorderRadius.circular(8.r),
                          border: isSelected
                              ? Border.all(color: '#DEAF3E'.toColor(), width: 1)
                              : null,
                        ),
                        child: Center(
                          child: AutoTranslateText(
                            filter,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                              color: isSelected
                                  ? '#DDAF3E'.toColor()
                                  : Colors.white,
                              height: 1,
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
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Profile Picture and Rating
            Column(
              children: [
                // Profile Picture Container
                Container(
                  width: 80.w,
                  height: 80.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Profile Picture with border
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: '#96090A'.toColor(),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: _buildImage(
                            astrologer.profilePicture,
                            size: 80,
                          ),
                        ),
                      ),
                      // Online indicator (bottom-left position)
                      if (isOnline)
                        Positioned(
                          bottom: 2,
                          left: 2,
                          child: Container(
                            width: 16.w,
                            height: 16.w,
                            decoration: BoxDecoration(
                              color: '#05DF72'.toColor(),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                // Rating Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.templeGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.templeGold, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: AppColors.templeGold, size: 14.w),
                      SizedBox(width: 4.w),
                      AutoTranslateText(
                        rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            // Right Side: Details and Actions
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with Follow button
                  Row(
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          astrologer.displayName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: '#68171E'.toColor(),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Follow Button
                      GestureDetector(
                        onTap: () {
                          // Handle follow action
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: AppColors.orangeGradient.colors.first,
                              width: 1,
                            ),
                          ),
                          child: AutoTranslateText(
                            'Follow',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              color: AppColors.orangeGradient.colors.first,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Specialization
                  AutoTranslateText(
                    specializations,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp,
                      color: '#909090'.toColor(),
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Languages
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        size: 12.w,
                        color: '#909090'.toColor(),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: AutoTranslateText(
                          languages,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp,
                            color: '#909090'.toColor(),
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // Experience
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12.w,
                        color: '#909090'.toColor(),
                      ),
                      SizedBox(width: 4.w),
                      AutoTranslateText(
                        experience,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                          color: '#909090'.toColor(),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // Price and Reviews Row
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.currency_rupee,
                            color: AppColors.templeGold,
                            size: 13.w,
                          ),
                          Flexible(
                            child: AutoTranslateText(
                              '$price/min',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                color: AppColors.templeGold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      AutoTranslateText(
                        '($totalRatings reviews)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 11.sp,
                          color: '#3D0C11'.toColor().withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Action Buttons
                  Row(
                    children: [
                      // Chat Button
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 36.h,
                          decoration: BoxDecoration(
                            gradient: AppColors.goldenGradient,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.booking,
                                  arguments: {
                                    'astrologer': astrologer,
                                    'callType': CallType.chat,
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(6.r),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: '#68171E'.toColor(),
                                    size: 16.w,
                                  ),
                                  SizedBox(width: 6.w),
                                  AutoTranslateText(
                                    'Chat',
                                    style: MyTextTheme.mediumBCB
                                        .copyWith(color: '#68171E'.toColor())
                                        .merge(
                                          AppTypography.h1.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Call Button
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: AppColors.templeGold,
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                '/booking',
                                arguments: {
                                  'astrologer': astrologer,
                                  'callType': CallType.voice,
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(6.r),
                            child: Icon(
                              Icons.phone,
                              color: '#68171E'.toColor(),
                              size: 16.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Video Call Button
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: AppColors.templeGold,
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                '/booking',
                                arguments: {
                                  'astrologer': astrologer,
                                  'callType': CallType.video,
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(6.r),
                            child: Icon(
                              Icons.videocam,
                              color: '#68171E'.toColor(),
                              size: 16.w,
                            ),
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
