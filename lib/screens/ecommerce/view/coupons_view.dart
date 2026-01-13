import 'package:astrobharataiuser/data_model/coupon_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/coupons_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CouponsView extends GetView<CouponsController> {
  const CouponsView({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: AutoTranslateText(
          'Available Coupons',
          style: AppTypography.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18.sp),
          onPressed: Get.back,
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.loadCoupons,
          color: AppColors.saffron,
          child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.coupons.isEmpty
                  ? ListView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                      children: [
                        Icon(Icons.card_giftcard,
                            size: 72.sp, color: AppColors.textSecondary.withOpacity(0.4)),
                        SizedBox(height: 16.h),
                        AutoTranslateText(
                          'No coupons available',
                          textAlign: TextAlign.center,
                  style: AppTypography.h3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                        ),
                        SizedBox(height: 8.h),
                        AutoTranslateText(
                          'Check back later for new offers and discounts.',
                          textAlign: TextAlign.center,
                          style: AppTypography.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                      itemCount: controller.coupons.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (_, index) {
                        final coupon = controller.coupons[index];
                        return _CouponCard(
                          coupon: coupon,
                          dateFormat: dateFormat,
                          onApply: () => controller.applyCoupon(coupon),
                          onValidate: () => controller.validateCoupon(coupon),
                        );
                      },
                    ),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AutoTranslateText(
                  coupon.code ?? '',
                    style: AppTypography.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: coupon.code ?? ''));
                  Get.snackbar(
                    'Coupon copied',
                    '${coupon.code ?? ''} copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.saffron,
                  side: BorderSide(color: AppColors.saffron),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const AutoTranslateText('Copy'),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          AutoTranslateText(
            coupon.description ?? '',
              style: AppTypography.body1.copyWith(
                color: AppColors.textSecondary,
              ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              _InfoChip(label: 'Type', value: discountType),
              if (coupon.discountValue != null)
                _InfoChip(
                  label: discountType == 'PERCENTAGE' ? 'Discount' : 'Amount',
                  value: discountType == 'PERCENTAGE'
                      ? '${coupon.discountValue?.toStringAsFixed(0)}%'
                      : '₹${coupon.discountValue?.toStringAsFixed(0)}',
                ),
              if (coupon.maxDiscountAmount != null)
                _InfoChip(
                  label: 'Max Discount',
                  value: '₹${coupon.maxDiscountAmount?.toStringAsFixed(0)}',
                ),
              if (coupon.minPurchaseAmount != null)
                _InfoChip(
                  label: 'Min Purchase',
                  value: '₹${coupon.minPurchaseAmount?.toStringAsFixed(0)}',
                ),
              _InfoChip(label: 'Valid Till', value: expiry),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onValidate,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.saffron,
                    side: BorderSide(color: AppColors.saffron),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const AutoTranslateText('Check Eligibility'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: const AutoTranslateText('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.saffron.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoTranslateText(
            label,
            style: AppTypography.label.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          AutoTranslateText(
            value,
            style: AppTypography.body2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.saffron,
            ),
          ),
        ],
      ),
    );
  }
}


