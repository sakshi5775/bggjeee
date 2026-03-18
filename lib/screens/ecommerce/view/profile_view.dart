import 'dart:io';

import 'package:astrobharataiuser/app_manager/common/image_picker.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/profile_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/data_model/report_model.dart';

class ProfileView extends GetView<ProfileController> {
  final bool showBackButton;

  const ProfileView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header using CommonHeader
              CommonHeader(
                title: 'My Profile',
                showBackButton: showBackButton,

                customActions: [
                  if (LoginGuard.isLoggedIn)
                    IconButton(
                      onPressed: controller.onLogoutTap,
                      icon: Icon(
                        Icons.logout,
                        color: '#6F221E'.toColor(),
                        size: 22.w,
                      ),
                      tooltip: 'Logout',
                      padding: EdgeInsets.all(8.w),
                      constraints: const BoxConstraints(),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: TextButton.icon(
                        onPressed: () => UserMainController.pushInCurrentTab(
                          AppRoutes.login,
                        ),
                        icon: Icon(
                          Icons.login,
                          color: '#6F221E'.toColor(),
                          size: 20.w,
                        ),
                        label: Text(
                          'Login',
                          style: TextStyle(
                            color: '#6F221E'.toColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
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
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 20.h,
                        bottom: 20.h,
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
                          if (LoginGuard.isLoggedIn) ...[
                            SizedBox(height: 24.h),
                            _buildDeleteAccountSection(),
                          ],
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
            padding: EdgeInsets.all(18),
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
                      fontSize: 18,
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
                                fontSize: 14,
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
        final localImage = controller.profilePicture.value;
        final avatarUrl = controller.profileImageUrl.value;
        final hasNetworkImage = avatarUrl.isNotEmpty;
        final hasAvatar = hasNetworkImage || localImage != null;

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
                              width: 110,
                              height: 110,
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

                                image: localImage != null
                                    ? DecorationImage(
                                        image: FileImage(localImage),
                                        fit: BoxFit.cover,
                                      )
                                    : hasNetworkImage
                                    ? DecorationImage(
                                        image: NetworkImage(avatarUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: !hasAvatar
                                  ? Icon(
                                      Icons.person_outline,
                                      size: 55,
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
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Name
                        controller.userName.value.isNotEmpty
                            ? Text(
                                controller.userName.value,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColorMaroon,
                                ),
                              )
                            : AutoTranslateText(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 22,
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
                                    fontSize: 13,
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
                                    fontSize: 13,
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
                                  fontSize: 11,
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
                                  fontSize: 13,
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
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.orders),
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
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.wishlist),
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
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.coupons),
      ),
      _ProfileAction(
        icon: Icons.history_edu_outlined,
        label: 'Kundli Reports',
        subtitle: '${controller.reportHistory.length} Reports',
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.kundliReportHistory),
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
                      fontSize: 18,
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
                crossAxisCount: Get.width > 600 ? 3 : 2,
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
                      fontSize: 18,
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
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AutoTranslateText(
                          'Start exploring the shop!',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
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
                    size: 24,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AutoTranslateText(
                    'Needs Assistance?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
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
                fontSize: 14,
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
                  onTap: () => UserMainController.pushInCurrentTab(
                    AppRoutes.supportTickets,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.headset_mic, size: 22, color: Colors.white),
                        SizedBox(width: 10.w),
                        AutoTranslateText(
                          'Contact Support',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
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

  Widget _buildDeleteAccountSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Delete your account',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textColorMaroon,
                  ),
                ),
                SizedBox(height: 8.h),
                AutoTranslateText(
                  'Permanently delete your account and all associated data. This action cannot be undone.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => Container(
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
                        onTap: controller.isDeletingAccount.value
                            ? null
                            : controller.onDeleteAccountTap,
                        borderRadius: BorderRadius.circular(14.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (controller.isDeletingAccount.value)
                                SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Icon(
                                  Icons.delete_outline,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              SizedBox(width: 10.w),
                              AutoTranslateText(
                                'Delete my account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildReportHistory() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.deepOrange.withValues(alpha: 0.1),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //           spreadRadius: 0,
  //         ),
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Header with gradient
  //         Container(
  //           padding: EdgeInsets.all(18.w),
  //           decoration: BoxDecoration(
  //             gradient: AppColors.primaryGradient,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20.r),
  //               topRight: Radius.circular(20.r),
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.all(8.w),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.templeGold.withValues(alpha: 0.2),
  //                   borderRadius: BorderRadius.circular(10.r),
  //                 ),
  //                 child: Icon(
  //                   Icons.picture_as_pdf_outlined,
  //                   color: AppColors.templeGold,
  //                   size: 24.w,
  //                 ),
  //               ),
  //               SizedBox(width: 12.w),
  //               Expanded(
  //                 child: AutoTranslateText(
  //                   'Kundali Reports',
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 18,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(16.w),
  //           child: Column(
  //             children: [
  //               // Filters Row
  //               SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: Row(
  //                   children: [
  //                     _buildFilterChip('All', 'all'),
  //                     SizedBox(width: 8.w),
  //                     _buildFilterChip('Sent', 'sent'),
  //                     SizedBox(width: 8.w),
  //                     _buildFilterChip('Pending', 'pending'),
  //                     SizedBox(width: 8.w),
  //                     _buildFilterChip('Failed', 'failed'),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 16.h),
  //               // Report Type Search/Filter
  //               Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 12.w),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.lightBackground,
  //                   borderRadius: BorderRadius.circular(12.r),
  //                   border: Border.all(
  //                     color: AppColors.deepOrange.withValues(alpha: 0.1),
  //                   ),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Icon(
  //                       Icons.search,
  //                       size: 18,
  //                       color: AppColors.textSecondary,
  //                     ),
  //                     SizedBox(width: 8.w),
  //                     Expanded(
  //                       child: TextField(
  //                         onChanged: (v) {
  //                           controller.searchReportType.value = v;
  //                           controller.loadReportHistory();
  //                         },
  //                         style: TextStyle(fontSize: 13),
  //                         decoration: InputDecoration(
  //                           hintText: 'Filter by report type...',
  //                           hintStyle: TextStyle(
  //                             color: AppColors.textSecondary.withValues(
  //                               alpha: 0.6,
  //                             ),
  //                             fontSize: 13,
  //                           ),
  //                           border: InputBorder.none,
  //                           isDense: true,
  //                           contentPadding: EdgeInsets.symmetric(
  //                             vertical: 12.h,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(height: 16.h),
  //               Obx(
  //                 () => controller.isHistoryLoading.value
  //                     ? Center(
  //                         child: Padding(
  //                           padding: EdgeInsets.all(20.w),
  //                           child: CircularProgressIndicator(
  //                             color: AppColors.deepOrange,
  //                           ),
  //                         ),
  //                       )
  //                     : controller.reportHistory.isEmpty
  //                     ? Container(
  //                         width: double.infinity,
  //                         padding: EdgeInsets.all(24.w),
  //                         decoration: BoxDecoration(
  //                           color: AppColors.lightBackground.withValues(
  //                             alpha: 0.5,
  //                           ),
  //                           borderRadius: BorderRadius.circular(12.r),
  //                           border: Border.all(
  //                             color: AppColors.deepOrange.withValues(
  //                               alpha: 0.1,
  //                             ),
  //                           ),
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Icon(
  //                               Icons.history_edu_outlined,
  //                               size: 40.w,
  //                               color: AppColors.textSecondary.withValues(
  //                                 alpha: 0.5,
  //                               ),
  //                             ),
  //                             SizedBox(height: 12.h),
  //                             AutoTranslateText(
  //                               'No reports found',
  //                               style: TextStyle(
  //                                 color: AppColors.textColorMaroon,
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     : Column(
  //                         children: controller.reportHistory
  //                             .map(
  //                               (report) => _ReportHistoryTile(
  //                                 report: report,
  //                                 onTap: () => controller.viewReport(report),
  //                               ),
  //                             )
  //                             .toList(),
  //                       ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFilterChip(String label, String value) {
  //   return Obx(
  //     () => ChoiceChip(
  //       label: AutoTranslateText(
  //         label,
  //         style: TextStyle(
  //           color: controller.selectedEmailStatus.value == value
  //               ? Colors.white
  //               : AppColors.textColorMaroon,
  //           fontSize: 12,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       selected: controller.selectedEmailStatus.value == value,
  //       onSelected: (selected) {
  //         if (selected) {
  //           controller.selectedEmailStatus.value = value;
  //           controller.loadReportHistory();
  //         }
  //       },
  //       selectedColor: AppColors.deepOrange,
  //       backgroundColor: Colors.white,
  //       side: BorderSide(
  //         color: controller.selectedEmailStatus.value == value
  //             ? Colors.transparent
  //             : AppColors.deepOrange.withValues(alpha: 0.2),
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20.r),
  //       ),
  //       showCheckmark: false,
  //       padding: EdgeInsets.symmetric(horizontal: 4.w),
  //     ),
  //   );
  // }

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
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header (address_form_sheet style)
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: 'Baloo2',
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          AutoTranslateText(
                            'Update your personal and birth chart details',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
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
                        borderRadius: BorderRadius.circular(20.r),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    20.h,
                    20.w,
                    MediaQuery.of(context).viewInsets.bottom + 20.h,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personal Information Section
                        _editSheetSectionHeader(
                          icon: Icons.person_rounded,
                          title: 'Personal Information',
                        ),
                        SizedBox(height: 16.h),
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
                                  radius: 48.r,
                                  backgroundColor: '#68171E'
                                      .toColor()
                                      .withValues(alpha: 0.1),
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
                                            fontSize: 24,
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
                                      gradient: AppColors.primaryGradient,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _editSheetField(
                          label: 'Full Name',
                          controller: controller.fullNameController,
                          icon: Icons.person_outline_rounded,
                        ),
                        SizedBox(height: 12.h),
                        Obx(
                          () => _editSheetDropdown<String>(
                            label: 'Gender',
                            value: controller.selectedGender.value,
                            items: ProfileController.genderOptions,
                            onChanged: (v) {
                              controller.selectedGender.value = v;
                              if (v != null)
                                controller.genderController.text = v;
                            },
                            hint: 'Select Gender',
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Obx(
                          () => _editSheetDropdown<String>(
                            label: 'Marital Status',
                            value: controller.selectedMaritalStatus.value,
                            items: ProfileController.maritalStatusOptions,
                            onChanged: (v) {
                              controller.selectedMaritalStatus.value = v;
                              if (v != null)
                                controller.maritalStatusController.text = v;
                            },
                            hint: 'Select Marital Status',
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _editSheetField(
                          label: 'Occupation',
                          controller: controller.occupationController,
                          icon: Icons.work_outline_rounded,
                        ),
                        SizedBox(height: 24.h),
                        // Birth Chart Section
                        _editSheetSectionHeader(
                          icon: Icons.calendar_today_rounded,
                          title: 'Birth Chart Information',
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () async {
                            await controller.selectBirthDate();
                            setState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: '#68171E'.toColor().withValues(
                                  alpha: 0.1,
                                ),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 20,
                                  color: AppColors.saffron,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      final text =
                                          controller.birthDateController.text;
                                      return AutoTranslateText(
                                        text.isEmpty
                                            ? 'Tap to select date of birth (dd/mm/yyyy)'
                                            : text,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: text.isEmpty
                                              ? AppColors.textSecondary
                                              : '#68171E'.toColor(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: AppColors.saffron,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24.r),
                                ),
                              ),
                              builder: (ctx) => Container(
                                height: MediaQuery.of(ctx).size.height * 0.8,
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewPadding.bottom,
                                ),
                                child: LocationBottomSheetWidget(
                                  onCitySelected:
                                      (city, state, country, [lat, lng, tz]) {
                                        controller
                                            .onBirthPlaceSelectedFromSheet(
                                              city,
                                              state,
                                              country,
                                            );
                                        Navigator.of(ctx).pop();
                                        setState(() {});
                                      },
                                  selectedCity:
                                      controller.birthCityController.text,
                                ),
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: _editSheetField(
                              label: 'Birth City',
                              controller: controller.birthCityController,
                              icon: Icons.location_city_rounded,
                              readOnly: true,
                            ),
                          ),
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
                                          color: AppColors.saffron,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      AutoTranslateText(
                                        'Fetching location details...',
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
                        GestureDetector(
                          onTap: () async {
                            await controller.selectBirthTime();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: '#68171E'.toColor().withValues(
                                  alpha: 0.1,
                                ),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 20,
                                  color: AppColors.saffron,
                                ),
                                SizedBox(width: 12.w),
                                Builder(
                                  builder: (context) {
                                    final h = controller
                                        .birthHourController
                                        .text
                                        .trim();
                                    final m = controller
                                        .birthMinuteController
                                        .text
                                        .trim();
                                    final hour24 = int.tryParse(h) ?? 0;
                                    final min = int.tryParse(m) ?? 0;
                                    final display =
                                        (h.isNotEmpty || m.isNotEmpty)
                                        ? TimePickerHelper.formatTime24To12Display(
                                            hour24,
                                            min,
                                          )
                                        : 'Tap to select birth time';
                                    return AutoTranslateText(
                                      display,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: (h.isEmpty && m.isEmpty)
                                            ? AppColors.textSecondary
                                            : '#68171E'.toColor(),
                                      ),
                                    );
                                  },
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: AppColors.saffron,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Update Profile Button
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: '#F38B3B'.toColor().withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: controller.isUpdatingProfile.value
                                  ? null
                                  : () async {
                                      final success = await controller
                                          .updateProfile();
                                      if (success && context.mounted) {
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
                              borderRadius: BorderRadius.circular(20.r),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                alignment: Alignment.center,
                                child: Obx(
                                  () => controller.isUpdatingProfile.value
                                      ? SizedBox(
                                          height: 24.h,
                                          width: 24.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_circle_rounded,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8.w),
                                            AutoTranslateText(
                                              'Update Profile',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
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
                        ),
                        SizedBox(height: 20.h),
                      ],
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

  Widget _editSheetSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 20, color: '#E3B341'.toColor()),
        ),
        SizedBox(width: 12.w),
        AutoTranslateText(
          title,
          style: TextStyle(
            fontFamily: 'Baloo2',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: '#68171E'.toColor(),
          ),
        ),
      ],
    );
  }

  Widget _editSheetField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: '#68171E'.toColor(),
        ),
        decoration: InputDecoration(
          labelText: label.isEmpty ? null : label,
          hintText: hint,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          prefixIcon: icon != Icons.access_time
              ? Icon(icon, size: 20, color: AppColors.saffron)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.saffron, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }

  Widget _editSheetDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            Icons.arrow_drop_down,
            size: 24,
            color: AppColors.saffron,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.saffron, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem<T>(
                value: e,
                child: AutoTranslateText(
                  e.toString(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: '#68171E'.toColor(),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        hint: AutoTranslateText(
          hint,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ),
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
                  padding: EdgeInsets.all(12.h),
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
                  child: Icon(action.icon, color: Colors.white, size: 26.h),
                ),
                SizedBox(height: 10.h),
                AutoTranslateText(
                  action.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textColorMaroon,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Flexible(
                  child: AutoTranslateText(
                    action.subtitle,
                    style: TextStyle(
                      fontSize: 11,
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
            UserMainController.pushInCurrentTab(
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
                      color: AppColors.deepOrange.withValues(alpha: 0.1),
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
                              color: AppColors.deepOrange.withValues(
                                alpha: 0.1,
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
                          fontSize: 14,
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
                          fontSize: 12,
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
                      fontSize: 13,
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
            Icon(Icons.error_outline, size: 20, color: AppColors.textSecondary),
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

class _ReportHistoryTile extends StatelessWidget {
  final ReportHistoryItem report;
  final VoidCallback onTap;

  const _ReportHistoryTile({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.lightBackground.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.deepOrange,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        report.reportName ?? 'Kundali Report',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textColorMaroon,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 10,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            report.generatedAt != null
                                ? DateFormat('dd MMM yyyy, hh:mm a').format(
                                    DateTime.parse(
                                      report.generatedAt!,
                                    ).toLocal(),
                                  )
                                : '',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (report.emailStatus != null &&
                              report.emailStatus!.isNotEmpty) ...[
                            SizedBox(width: 8.w),
                            _buildStatusBadge(report.emailStatus!),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    String label = status.capitalizeFirst ?? status;

    switch (status.toLowerCase()) {
      case 'sent':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'failed':
        color = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: AutoTranslateText(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
