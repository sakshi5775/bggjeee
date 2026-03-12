import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/data_model/coupon_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/coupons_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CouponsView extends GetView<CouponsController> {
  final bool showBackButton;
  const CouponsView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            CommonHeader(
              title: 'Available Coupons',
              showBackButton: showBackButton,
              subtitle: AutoTranslateText(
                'Save more with exclusive offers',
                style: TextStyle(
                  color: '#6F221E'.toColor().withValues(alpha: 0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: controller.loadCoupons,
                  color: AppColors.saffron,
                  child: controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.saffron,
                          ),
                        )
                      : controller.coupons.isEmpty
                      ? _EmptyCouponsView()
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
                          itemCount: controller.coupons.length,
                          separatorBuilder: (_, __) => SizedBox(height: 16.h),
                          itemBuilder: (_, index) {
                            final coupon = controller.coupons[index];
                            return _CouponCard(
                              coupon: coupon,
                              dateFormat: dateFormat,
                              onApply: () => controller.applyCoupon(coupon),
                              onValidate: () =>
                                  controller.validateCoupon(coupon),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCouponsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: '#68171E'.toColor().withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.card_giftcard_rounded,
                size: 64.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            AutoTranslateText(
              'No coupons available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
                color: '#68171E'.toColor(),
              ),
            ),
            SizedBox(height: 12.h),
            AutoTranslateText(
              'Check back later for new offers and discounts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.dateFormat,
    required this.onApply,
    required this.onValidate,
  });

  final CouponModel coupon;
  final DateFormat dateFormat;
  final VoidCallback onApply;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    final discountType = coupon.discountType?.toUpperCase() ?? '';
    final expiry = coupon.validUntil != null
        ? dateFormat.format(DateTime.parse(coupon.validUntil!))
        : 'No expiry';
    final discountValue = coupon.discountValue ?? 0;
    final isPercentage = discountType == 'PERCENTAGE';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: '#68171E'.toColor().withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main Card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white,
                  '#FEF6C3'.toColor().withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: '#E3B341'.toColor().withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Code and Copy Button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Coupon Code',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          AutoTranslateText(
                            coupon.code ?? '',
                            style: TextStyle(
                              fontFamily: 'Baloo2',
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              color: '#68171E'.toColor(),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: '#F38B3B'.toColor().withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: coupon.code ?? ''),
                            );
                            Get.snackbar(
                              'Coupon copied',
                              '${coupon.code ?? ''} copied to clipboard',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: '#68171E'.toColor(),
                              colorText: Colors.white,
                              borderRadius: 12.r,
                            );
                          },
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.copy_rounded,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6.w),
                                AutoTranslateText(
                                  'Copy',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: Colors.white,
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
                SizedBox(height: 16.h),
                // Description
                if (coupon.description != null &&
                    coupon.description!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: AutoTranslateText(
                      coupon.description ?? '',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: '#68171E'.toColor(),
                        height: 1.5,
                      ),
                    ),
                  ),
                if (coupon.description != null &&
                    coupon.description!.isNotEmpty)
                  SizedBox(height: 16.h),
                // Discount Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: '#68171E'.toColor().withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer_rounded,
                        color: '#E3B341'.toColor(),
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        isPercentage
                            ? '${discountValue.toStringAsFixed(0)}% OFF'
                            : '₹${discountValue.toStringAsFixed(0)} OFF',
                        style: TextStyle(
                          fontFamily: 'Baloo2',
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          color: '#E3B341'.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Info Chips
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    if (coupon.minPurchaseAmount != null)
                      _InfoChip(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Min Purchase',
                        value:
                            '₹${coupon.minPurchaseAmount?.toStringAsFixed(0)}',
                      ),
                    if (coupon.maxDiscountAmount != null)
                      _InfoChip(
                        icon: Icons.percent_rounded,
                        label: 'Max Discount',
                        value:
                            '₹${coupon.maxDiscountAmount?.toStringAsFixed(0)}',
                      ),
                    _InfoChip(
                      icon: Icons.calendar_today_rounded,
                      label: 'Valid Till',
                      value: expiry,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Action Buttons
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: '#68171E'.toColor().withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        color: Colors.white,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onValidate,
                          borderRadius: BorderRadius.circular(16.r),
                          child: Icon(
                            Icons.verified_user_rounded,
                            size: 24.sp,
                            color: '#68171E'.toColor(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: '#F38B3B'.toColor().withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onApply,
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 18.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6.w),
                                  AutoTranslateText(
                                    'Apply Coupon',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.sp,
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
              ],
            ),
          ),
          // Decorative Elements
          Positioned(
            top: -20.h,
            right: -20.w,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    '#E3B341'.toColor().withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.saffron.withValues(alpha: 0.15),
            AppColors.saffron.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.saffron.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.saffron),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoTranslateText(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              AutoTranslateText(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: '#68171E'.toColor(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
