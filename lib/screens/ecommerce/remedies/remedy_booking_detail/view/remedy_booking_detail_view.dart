import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_booking_detail/controller/remedy_booking_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemedyBookingDetailView extends BasePage<RemedyBookingDetailController> {
  const RemedyBookingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Booking Detail'),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.booking.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.deepOrange,
                      strokeWidth: 2,
                    ),
                  );
                }
                final b = controller.booking.value;
                if (b == null) {
                  return Center(
                    child: AutoTranslateText(
                      'Booking not found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildServiceCard(b),
                      SizedBox(height: 16.h),
                      _buildInfoCard(b),
                      if (controller.canPay || controller.canCancel) ...[
                        SizedBox(height: 20.h),
                        if (controller.canPay)
                          Obx(
                            () => MyButton(
                              title: controller.isPaymentInProgress.value
                                  ? 'Opening payment...'
                                  : 'Pay Now',
                              useGradient: true,
                              onPress: controller.isPaymentInProgress.value
                                  ? null
                                  : () => controller.initiatePayment(),
                            ),
                          ),
                        if (controller.canPay && controller.canCancel)
                          SizedBox(height: 12.h),
                        if (controller.canCancel)
                          Obx(
                            () => MyButton(
                              title: controller.isCancelling.value
                                  ? 'Cancelling...'
                                  : 'Cancel Booking',
                              useGradient: false,
                              onPress: controller.isCancelling.value
                                  ? null
                                  : () => controller.showCancelDialog(),
                            ),
                          ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(dynamic b) {
    final snapshot = b.serviceSnapshot;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: snapshot?.image ?? '',
              width: 70.w,
              height: 70.w,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 70.w,
                height: 70.w,
                color: Colors.white24,
                child: const Icon(Icons.image, color: Colors.white54),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  snapshot?.title ?? 'Remedy',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  '₹${b.pricing?.totalAmount?.toStringAsFixed(0) ?? '0'}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'ID: ${b.bookingId ?? b.id ?? '-'}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(dynamic b) {
    final status = b.status ?? 'pending';
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AutoTranslateText(
                'Status',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _statusColor(status),
                  ),
                ),
              ),
            ],
          ),
          if (b.customerDetails != null) ...[
            SizedBox(height: 12.h),
            AutoTranslateText(
              'Customer',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '${b.customerDetails?.fullName ?? ''}\n${b.customerDetails?.phone ?? ''}',
              style: TextStyle(fontSize: 13.sp, color: Colors.black87),
            ),
          ],
          if (b.cancellation != null) ...[
            SizedBox(height: 12.h),
            AutoTranslateText(
              'Cancellation',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              b.cancellation?.reason ?? '',
              style: TextStyle(fontSize: 12.sp, color: Colors.red[700]),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
      case 'refunded':
        return Colors.red;
      case 'payment_pending':
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
