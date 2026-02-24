import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/all_astrologers_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';

class AllAstrologersView extends StatelessWidget {
  final String? initialFilter;
  final bool hideHeader;
  final bool showBackButton;

  const AllAstrologersView({
    super.key,
    this.initialFilter,
    this.hideHeader = false,
    this.showBackButton = true,
  });

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
      decoration: hideHeader
          ? null
          : BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: !hideHeader,
          bottom: false,
          child: Column(
            children: [
              if (hideHeader)
                _buildFiltersOnly(context, controller)
              else ...[
                CommonHeader(
                  title: 'Chat with Astrologer',
                  showBackButton: showBackButton,
                  showWallet: true,
                  showCart: true,
                  showSearch: true,
                ),
                _buildFiltersOnly(context, controller),
              ],

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
                      child: CustomScrollView(
                        primary: !hideHeader,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                            sliver: SliverToBoxAdapter(
                              child: Obx(() {
                                if (controller.astrologerBanners.isNotEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: BannerCarouselWidget(
                                      banners: controller.astrologerBanners,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
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
                                  final astrologer =
                                      controller.astrologers[index];
                                  return _buildAstrologerCard(
                                    astrologer,
                                    controller,
                                    isFirst: index == 0,
                                  );
                                },
                                childCount:
                                    controller.astrologers.length +
                                    (controller.hasMoreData.value ? 1 : 0),
                              ),
                            ),
                          ),
                          SliverPadding(padding: EdgeInsets.only(bottom: 16.h)),
                        ],
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
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          hideHeader ? 12.h : 0,
          0,
          hideHeader ? 8.h : 16.h,
        ),
        child: SizedBox(
          height: 36.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 16.w),
                ...controller.filterOptions.map((filter) {
                  return Obx(() {
                    final isSelected =
                        controller.selectedFilter.value == filter;
                    return Padding(
                      padding: EdgeInsets.only(right: 6.w),
                      child: GestureDetector(
                        onTap: () => controller.setFilter(filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: Get.width > 600 ? 10.h : 5.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppColors.orangeGradient
                                : null,
                            color: isSelected ? null : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: AppColors.saffron.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFed6f30,
                                      ).withValues(alpha: 0.25),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: AutoTranslateText(
                              filter,
                              textAlign: TextAlign.center,
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.saffron,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                }),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ),
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
              color: Colors.black.withValues(alpha: 0.08),
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
                    color: AppColors.templeGold.withValues(alpha: 0.15),
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
                          translate: false,
                          style: AppTypography.h3.copyWith(
                            color: '#68171E'.toColor(),
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Follow Button
                      Obx(() {
                        final astrologerId = astrologer.astrologerId;
                        final isFollowing =
                            controller.followStatus[astrologerId] ?? false;
                        final isLoading =
                            controller.followLoading[astrologerId] ?? false;

                        return GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => controller.toggleFollow(astrologer),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isFollowing
                                  ? Colors.grey[300]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: isFollowing
                                    ? Colors.grey
                                    : AppColors.orangeGradient.colors.first,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isLoading)
                                  SizedBox(
                                    width: 12.w,
                                    height: 12.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        isFollowing
                                            ? Colors.black87
                                            : AppColors
                                                  .orangeGradient
                                                  .colors
                                                  .first,
                                      ),
                                    ),
                                  )
                                else
                                  Icon(
                                    isFollowing
                                        ? Icons.check
                                        : Icons.person_add,
                                    color: isFollowing
                                        ? Colors.black87
                                        : AppColors.orangeGradient.colors.first,
                                    size: 14.w,
                                  ),
                                SizedBox(width: 4.w),
                                AutoTranslateText(
                                  isFollowing ? 'Following' : 'Follow',
                                  style: AppTypography.body1.copyWith(
                                    color: isFollowing
                                        ? Colors.black87
                                        : AppColors.orangeGradient.colors.first,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Price directly below name
                  Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        color: AppColors.templeGold,
                        size: 11.w, // Smaller icon
                      ),
                      AutoTranslateText(
                        '${astrologer.chatPricePerMin?.toInt() ?? 0}/min',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.templeGold,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      AutoTranslateText(
                        '($totalRatings)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: '#3D0C11'.toColor().withValues(alpha: 0.5),
                          fontSize: 10.sp, // Smaller font
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
                          color: '#909090'.toColor(),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
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
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                controller.initiateChat(astrologer);
                              },
                              borderRadius: BorderRadius.circular(6.r),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.white,
                                    size: 16.h,
                                  ),
                                  SizedBox(width: 6.w),
                                  AutoTranslateText(
                                    'Chat',
                                    style: AppTypography.h2.copyWith(
                                      color: Colors.white,
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
                            color: AppColors.deepOrange,
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              controller.initiateVoiceCall(astrologer);
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
                            color: AppColors.deepOrange,
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              controller.initiateVideoCall(astrologer);
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
        color: Colors.grey.withValues(alpha: 0.3),
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
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withValues(alpha: 0.3),
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
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
      );
    }
  }
}
