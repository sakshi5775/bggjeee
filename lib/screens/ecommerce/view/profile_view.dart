import 'dart:io';

import 'package:astrobharataiuser/app_manager/common/image_picker.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/profile_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileView extends GetView<ProfileController> {
  final bool showBackButton;

  const ProfileView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header using CommonHeader
              CommonHeader(
                title: 'My Profile',
                titleColor: AppColors.templeGold,
                showBackButton: showBackButton,
                actions: [
                  IconButton(
                    onPressed: () {
                      if (LoginGuard.isLoggedIn) {
                        controller.onLogoutTap();
                      } else {
                        Get.toNamed(AppRoutes.login);
                      }
                    },
                    icon: Icon(
                      LoginGuard.isLoggedIn ? Icons.logout : Icons.login,
                      color: AppColors.templeGold,
                      size: 22.w,
                    ),
                    tooltip: LoginGuard.isLoggedIn ? 'Logout' : 'Login',
                    padding: EdgeInsets.all(8.w),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Expanded(
                child: Obx(
                  () => RefreshIndicator(
                    onRefresh: controller.loadProfile,
                    color: AppColors.deepOrange,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderCard(),
                          SizedBox(height: 24.h),
                          _buildAccountInfoCard(context),
                          SizedBox(height: 24.h),
                          _buildActionGrid(context),
                          SizedBox(height: 24.h),
                          _buildRecentOrders(),
                          SizedBox(height: 24.h),
                          _buildHelpSection(),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfoCard(BuildContext context) {
    final profile = controller.profile.value;
    final memberSince = _formatMemberSinceDate(profile?.createdAt);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.templeGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.account_circle_outlined,
                    color: AppColors.templeGold,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AutoTranslateText(
                    'Account Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              children: [
                _AccountDetailRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: controller.userEmail.value.isEmpty
                      ? 'Not set'
                      : controller.userEmail.value,
                  iconColor: AppColors.deepOrange,
                ),
                SizedBox(height: 16.h),
                _AccountDetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: controller.userPhone.value.isEmpty
                      ? 'Not set'
                      : controller.userPhone.value,
                  iconColor: AppColors.templeGold,
                ),
                SizedBox(height: 16.h),
                _AccountDetailRow(
                  icon: Icons.verified_user_outlined,
                  label: 'Status',
                  value:
                      profile?.metadata?.accountStatus?.toUpperCase() ??
                      'ACTIVE',
                  iconColor: AppColors.green,
                ),
                SizedBox(height: 16.h),
                _AccountDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Member Since',
                  value: memberSince,
                  iconColor: AppColors.deepOrange,
                ),
                SizedBox(height: 20.h),
                // Edit Profile Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepOrange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showEditProfileSheet(context),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w),
                            AutoTranslateText(
                              'Manage Your Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Builder(
      builder: (context) {
        final avatarUrl = controller.profileImageUrl.value;
        final hasAvatar = avatarUrl.isNotEmpty;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white.withValues(alpha: 0.95)],
              ),
            ),
            child: Column(
              children: [
                // Profile Section with Avatar, Name, Email, Phone
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar with Camera Icon
                        Stack(
                          children: [
                            Container(
                              width: 110.w,
                              height: 110.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: hasAvatar
                                    ? null
                                    : AppColors.orangeGradient,
                                border: Border.all(
                                  color: AppColors.deepOrange.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.deepOrange.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                                image: hasAvatar
                                    ? DecorationImage(
                                        image: NetworkImage(avatarUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: !hasAvatar
                                  ? Icon(
                                      Icons.person_outline,
                                      size: 55.sp,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  final image =
                                      await ImagePickerHelper.pickImage(
                                        context,
                                      );
                                  if (image != null) {
                                    controller.setProfilePicture(image);
                                    final success = await controller
                                        .updateProfile();
                                    if (success) {
                                      await controller.loadProfile();
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.orangeGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.deepOrange.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Name
                        AutoTranslateText(
                          controller.userName.value,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColorMaroon,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        // Email
                        if (controller.userEmail.value.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 14.w,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: AutoTranslateText(
                                  controller.userEmail.value,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        // Phone
                        if (controller.userPhone.value.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 14.w,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: AutoTranslateText(
                                  controller.userPhone.value,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Last Login Banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepOrange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.access_time,
                              size: 18.w,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoTranslateText(
                                'Last Login',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              AutoTranslateText(
                                controller.lastLoginText.value.isNotEmpty
                                    ? controller.lastLoginText.value
                                    : '18 Dec 2025 . 08:33 PM',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
      },
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    final actions = [
      _ProfileAction(
        icon: Icons.shopping_bag_outlined,
        label: 'Orders',
        subtitle: '${controller.ordersCount} Orders',
        onTap: () => Get.toNamed(AppRoutes.orders),
      ),
      _ProfileAction(
        icon: Icons.local_florist_outlined,
        label: 'My Pooja',
        subtitle: '2 Poojas',
        onTap: controller.onFollowingTap,
      ),
      _ProfileAction(
        icon: Icons.auto_awesome_outlined,
        label: 'Wishlist',
        subtitle: '${controller.wishlistCount} Items',
        onTap: () => Get.toNamed(AppRoutes.wishlist),
      ),
      _ProfileAction(
        icon: Icons.favorite,
        label: 'Following',
        subtitle: '${controller.followingCount} Astrologers',
        onTap: controller.onFollowingTap,
      ),
      _ProfileAction(
        icon: Icons.location_on_outlined,
        label: 'Addresses',
        subtitle: '${controller.addressesCount} Addresses',
        onTap: controller.onAddressesTap,
      ),
      _ProfileAction(
        icon: Icons.percent,
        label: 'Coupons',
        subtitle: '${controller.couponCount} Coupons',
        onTap: () => Get.toNamed(AppRoutes.coupons),
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.templeGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.dashboard_outlined,
                    color: AppColors.templeGold,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AutoTranslateText(
                    'Your Dashboard',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (_, index) =>
                  _ProfileActionTile(action: actions[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.templeGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.templeGold,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AutoTranslateText(
                    'Recent Orders',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: controller.isLoading.value
                ? Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.deepOrange,
                        ),
                      ),
                    ),
                  )
                : controller.recentOrders.isEmpty
                ? Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.lightBackground,
                          AppColors.lightBackground.withValues(alpha: 0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.deepOrange.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 48.w,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 12.h),
                        AutoTranslateText(
                          'No orders placed yet',
                          style: TextStyle(
                            color: AppColors.textColorMaroon,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AutoTranslateText(
                          'Start exploring the shop!',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: controller.recentOrders
                        .take(3)
                        .map(
                          (order) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _RecentOrderTile(order: order),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white.withValues(alpha: 0.95)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepOrange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.headset_mic_outlined,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AutoTranslateText(
                    'Needs Assistance?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                      color: AppColors.textColorMaroon,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            AutoTranslateText(
              'Our Support Team is available 24x7 to assist you with your orders, refunds, and product queries.',
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepOrange.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.toNamed(AppRoutes.supportTickets),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.headset_mic,
                          size: 22.w,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.w),
                        AutoTranslateText(
                          'Contact Support',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMemberSinceDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Not available';
    try {
      final date = DateTime.parse(isoString).toLocal();
      final day = date.day;
      String suffix = 'th';
      if (day == 1 || day == 21 || day == 31) suffix = 'st';
      if (day == 2 || day == 22) suffix = 'nd';
      if (day == 3 || day == 23) suffix = 'rd';
      return '${day}$suffix ${DateFormat('MMMM,yyyy').format(date)}';
    } catch (_) {
      return 'Not available';
    }
  }

  Widget _AccountDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Widget? trailing,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [iconColor, iconColor.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, size: 18.w, color: Colors.white),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.textColorMaroon,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    final controller = Get.find<ProfileController>();
    File? selectedImage;
    bool imageChanged = false;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.95,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20.w,
            right: 20.w,
            top: 20.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Edit Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () {
                        if (selectedImage != null) {
                          controller.setProfilePicture(null);
                        }
                        if (Get.isBottomSheetOpen == true ||
                            Get.isDialogOpen == true) {
                          Get.back();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Scrollable form
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Picture
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final image = await ImagePickerHelper.pickImage(
                                context,
                              );
                              if (image != null) {
                                setState(() {
                                  selectedImage = image;
                                  imageChanged = true;
                                  controller.setProfilePicture(image);
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50.r,
                                  backgroundColor: AppColors.lightBackground,
                                  backgroundImage:
                                      imageChanged && selectedImage != null
                                      ? FileImage(selectedImage!)
                                      : (controller
                                                .profileImageUrl
                                                .value
                                                .isNotEmpty
                                            ? NetworkImage(
                                                controller
                                                    .profileImageUrl
                                                    .value,
                                              )
                                            : null),
                                  child:
                                      imageChanged &&
                                          selectedImage == null &&
                                          controller
                                              .profileImageUrl
                                              .value
                                              .isEmpty
                                      ? AutoTranslateText(
                                          controller.userInitials,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.saffron,
                                          ),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.saffron,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 18.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Personal Info Section
                        _buildSectionTitle('Personal Information'),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.fullNameController,
                          decoration: _inputDecoration(
                            'Full Name',
                            Icons.person_outline,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.selectedGender.value,
                            decoration: _inputDecoration(
                              'Gender',
                              Icons.wc_outlined,
                            ),
                            items: ProfileController.genderOptions.map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: AutoTranslateText(
                                  value,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedGender.value = newValue;
                              if (newValue != null) {
                                controller.genderController.text = newValue;
                              }
                            },
                            hint: AutoTranslateText(
                              'Select Gender',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            style: TextStyle(color: AppColors.textPrimary),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.saffron,
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.selectedMaritalStatus.value,
                            decoration: _inputDecoration(
                              'Marital Status',
                              Icons.favorite_outline,
                            ),
                            items: ProfileController.maritalStatusOptions.map((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: AutoTranslateText(
                                  value,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedMaritalStatus.value = newValue;
                              if (newValue != null) {
                                controller.maritalStatusController.text =
                                    newValue;
                              }
                            },
                            hint: AutoTranslateText(
                              'Select Marital Status',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            style: TextStyle(color: AppColors.textPrimary),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.saffron,
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.occupationController,
                          decoration: _inputDecoration(
                            'Occupation',
                            Icons.work_outline,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Contact Info Section
                        _buildSectionTitle('Contact Information'),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.alternatePhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                            'Alternate Phone',
                            Icons.phone_outlined,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.cityController,
                          decoration: _inputDecoration(
                            'City (Type city name to auto-fill)',
                            Icons.location_city_outlined,
                          ),
                          onChanged: (_) {
                            // Debounce to avoid too many API calls while typing
                            Future.delayed(Duration(milliseconds: 800), () {
                              if (controller.cityController.text
                                      .trim()
                                      .length >=
                                  3) {
                                controller.onContactCityChanged();
                              }
                            });
                          },
                        ),
                        Obx(
                          () => controller.isFetchingCoordinates.value
                              ? Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16.w,
                                        height: 16.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      AutoTranslateText(
                                        'Auto-filling address...',
                                        style: AppTypography.body2.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.stateController,
                          decoration: _inputDecoration(
                            'State',
                            Icons.map_outlined,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.pincodeController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(
                                  'Pincode/Postal Code',
                                  Icons.pin_outlined,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: TextField(
                                controller: controller.countryController,
                                decoration: _inputDecoration(
                                  'Country',
                                  Icons.public_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        // Birth Chart Section
                        _buildSectionTitle('Birth Chart Information'),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.birthDateController,
                          decoration: _inputDecoration(
                            'Date of Birth (dd/mm/yyyy)',
                            Icons.calendar_today_outlined,
                          ),
                          readOnly: true,
                          onTap: () => controller.selectBirthDate(),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.birthCityController,
                          decoration: _inputDecoration(
                            'Birth City (Type city name to auto-fill)',
                            Icons.location_city_outlined,
                          ),
                          onChanged: (_) {
                            // Debounce to avoid too many API calls
                            Future.delayed(Duration(milliseconds: 800), () {
                              if (controller.birthCityController.text
                                      .trim()
                                      .length >=
                                  3) {
                                controller.onBirthCityChanged();
                              }
                            });
                          },
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.birthStateController,
                          decoration: _inputDecoration(
                            'Birth State',
                            Icons.map_outlined,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.birthCountryController,
                          decoration: _inputDecoration(
                            'Birth Country',
                            Icons.public_outlined,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.birthLatitudeController,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: _inputDecoration(
                                  'Latitude',
                                  Icons.navigation_outlined,
                                ),
                                readOnly: true,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: TextField(
                                controller: controller.birthLongitudeController,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                decoration: _inputDecoration(
                                  'Longitude',
                                  Icons.navigation_outlined,
                                ),
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.birthTimezoneController,
                          decoration: _inputDecoration(
                            'Timezone',
                            Icons.access_time_outlined,
                          ),
                          readOnly: true,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.birthHourController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(
                                  'Hour (0-23)',
                                  Icons.access_time,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: TextField(
                                controller: controller.birthMinuteController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(
                                  'Minute (0-59)',
                                  Icons.access_time,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: TextField(
                                controller: controller.birthSecondController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(
                                  'Second (0-59)',
                                  Icons.access_time,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => controller.isFetchingCoordinates.value
                              ? Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16.w,
                                        height: 16.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      AutoTranslateText(
                                        'Fetching coordinates...',
                                        style: AppTypography.body2.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                        SizedBox(height: 24.h),
                        // Preferences Section
                        _buildSectionTitle('Preferences'),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: controller.languageController,
                          decoration: _inputDecoration(
                            'Language (hi/en)',
                            Icons.language_outlined,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        AutoTranslateText(
                          'Notification Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Obx(
                          () => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AutoTranslateText(
                              'Email Notifications',
                              style: AppTypography.body1,
                            ),
                            value: controller.emailNotificationController.value,
                            onChanged: (value) =>
                                controller.emailNotificationController.value =
                                    value ?? false,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        Obx(
                          () => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AutoTranslateText(
                              'SMS Notifications',
                              style: AppTypography.body1,
                            ),
                            value: controller.smsNotificationController.value,
                            onChanged: (value) =>
                                controller.smsNotificationController.value =
                                    value ?? false,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        Obx(
                          () => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AutoTranslateText(
                              'Push Notifications',
                              style: AppTypography.body1,
                            ),
                            value: controller.pushNotificationController.value,
                            onChanged: (value) =>
                                controller.pushNotificationController.value =
                                    value ?? false,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        Obx(
                          () => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: AutoTranslateText(
                              'WhatsApp Notifications',
                              style: AppTypography.body1,
                            ),
                            value:
                                controller.whatsappNotificationController.value,
                            onChanged: (value) =>
                                controller
                                        .whatsappNotificationController
                                        .value =
                                    value ?? false,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isUpdatingProfile.value
                                  ? null
                                  : () async {
                                      final success = await controller
                                          .updateProfile();
                                      if (success) {
                                        Future.delayed(
                                          Duration(milliseconds: 300),
                                          () {
                                            if (Get.isBottomSheetOpen == true ||
                                                Get.isDialogOpen == true) {
                                              Get.back();
                                            } else if (Navigator.of(
                                              context,
                                            ).canPop()) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.saffron,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: controller.isUpdatingProfile.value
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : AutoTranslateText(
                                      'Update Profile',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AutoTranslateText(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.saffron),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.saffron),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.saffron, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
      filled: true,
      fillColor: AppColors.lightBackground,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }

  static String? _resolveOrderImage(OrderItem? item) {
    if (item == null) return null;
    final product = item.product;
    if (product?.images != null && product!.images!.isNotEmpty) {
      try {
        final primary = product.images!.firstWhere(
          (img) => img.isPrimary == true,
          orElse: () => product.images!.first,
        );
        if (primary.url != null && primary.url!.isNotEmpty) {
          final url = primary.url!;
          return url.startsWith('http') ? url : 'http://65.1.131.197:8000$url';
        }
      } catch (_) {}
    }
    final snapshotUrl = item.productSnapshot?.image;
    if (snapshotUrl != null && snapshotUrl.isNotEmpty) {
      return snapshotUrl.startsWith('http')
          ? snapshotUrl
          : 'http://65.1.131.197:8000$snapshotUrl';
    }
    return null;
  }
}

class _ProfileAction {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({required this.action});

  final _ProfileAction action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, AppColors.lightBackground],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.deepOrange.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepOrange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(action.icon, color: Colors.white, size: 26.w),
                ),
                SizedBox(height: 10.h),
                AutoTranslateText(
                  action.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.textColorMaroon,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Flexible(
                  child: AutoTranslateText(
                    action.subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  const _RecentOrderTile({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    try {
      final firstItem = order.items.isNotEmpty ? order.items.first : null;
      final imageUrl = ProfileView._resolveOrderImage(firstItem);

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(
              AppRoutes.orderDetail,
              arguments: {'orderId': order.id ?? order.orderId},
            );
          },
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, AppColors.lightBackground],
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.deepOrange.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: imageUrl != null
                        ? NetworkImageWithLoader(
                            url: imageUrl,
                            height: 50.h,
                            width: 50.w,
                          )
                        : Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              gradient: AppColors.orangeGradient.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.inventory_2,
                              size: 24.w,
                              color: AppColors.deepOrange,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        order.orderId ?? 'Order',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: AppColors.textColorMaroon,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      AutoTranslateText(
                        firstItem?.productSnapshot?.name ??
                            firstItem?.product?.name ??
                            '${order.itemCount ?? 0} items',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AutoTranslateText(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      // Return a safe fallback widget if there's any error
      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 20.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AutoTranslateText(
                'Order ${order.orderId ?? 'N/A'}',
                style: TextStyle(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
  }
}
