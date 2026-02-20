import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/controller/my_booking_detail_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/widgets/booking_detail_widgets.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data_model/my_booking_model.dart';

class MyBookingDetailView extends BasePage<MyBookingDetailController> {
  const MyBookingDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header
            CommonHeader(
              title: 'Booking Details',
              subtitle: controller.booking.value?.bookingId != null
                  ? AutoTranslateText(
                      '#${controller.booking.value?.bookingId}',
                      style: AppTypography.body2.copyWith(
                        color: '#6F221E'.toColor().withValues(alpha: 0.7),
                      ),
                    )
                  : null,
            ),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }
                if (controller.errorMessage.isNotEmpty) {
                  return _buildErrorState();
                }
                final booking = controller.booking.value;
                if (booking == null) {
                  return _buildErrorState();
                }
                return RefreshIndicator(
                  onRefresh: controller.refreshBooking,
                  color: AppColors.orangeGradient.colors.first,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Card
                        _buildStatusCard(booking),
                        SizedBox(height: 16.h),
                        // Puja Details
                        _buildPujaSection(booking),
                        // Package Details
                        _buildPackageSection(booking),
                        // Participants
                        if (booking.participants != null &&
                            booking.participants!.isNotEmpty)
                          _buildParticipantsSection(booking),
                        // Sankalp Notes
                        if (booking.sankalpNotes != null &&
                            booking.sankalpNotes!.isNotEmpty)
                          _buildSankalpSection(booking),
                        // Pricing Details
                        _buildPricingSection(booking),
                        // Payment Section
                        _buildPaymentSection(booking),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        // Bottom Pay Now button for pending payment
        bottomNavigationBar: Obx(() {
          if (controller.isPendingPayment) {
            return _buildPayNowButton();
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildPayNowButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          return GestureDetector(
            onTap: controller.isProcessingPayment.value
                ? null
                : controller.onPayPendingBooking,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: controller.isProcessingPayment.value
                    ? LinearGradient(
                        colors: [Colors.grey.shade400, Colors.grey.shade400],
                      )
                    : AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  if (!controller.isProcessingPayment.value)
                    BoxShadow(
                      color: AppColors.saffron.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isProcessingPayment.value) ...[
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    AutoTranslateText(
                      'Processing...',
                      style: AppTypography.body1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.payment_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 10.w),
                    AutoTranslateText(
                      'Pay Pending Amount',
                      style: AppTypography.body1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.orangeGradient.colors.first,
          ),
          SizedBox(height: 16.h),
          AutoTranslateText(
            'Loading details...',
            style: AppTypography.body2.copyWith(color: const Color(0xFF757575)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: const Color(0xFFBDBDBD),
            ),
            SizedBox(height: 16.h),
            AutoTranslateText(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'Booking not found',
              style: AppTypography.body2.copyWith(
                color: const Color(0xFF757575),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: controller.loadBookingDetail,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: AutoTranslateText(
                  'Retry',
                  style: AppTypography.body1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(booking) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.confirmation_number_rounded,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Booking ID',
                  style: AppTypography.label.copyWith(color: Colors.white70),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  booking.bookingId ?? 'N/A',
                  style: AppTypography.h2.copyWith(color: Colors.white),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  booking.formattedDate,
                  style: AppTypography.body2.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: AutoTranslateText(
              booking.formattedStatus,
              style: AppTypography.label.copyWith(
                color: controller.getStatusColor(booking.status),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPujaSection(booking) {
    final puja = booking.puja;
    final pujaSnapshot = booking.pujaSnapshot;
    final temple = puja?.temple;
    final imageUrl = temple?.images?.isNotEmpty == true
        ? temple!.images!.first
        : null;
    return BookingInfoSection(
      title: 'Pooja Details',
      icon: Icons.temple_hindu_rounded,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Temple Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: const Color(0xFFF5F5F5),
                      child: Icon(
                        Icons.temple_hindu,
                        size: 30.sp,
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: const Color(0xFFF5F5F5),
                      child: Icon(
                        Icons.temple_hindu,
                        size: 30.sp,
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                  )
                : Container(
                    width: 80.w,
                    height: 80.w,
                    color: const Color(0xFFF5F5F5),
                    child: Icon(
                      Icons.temple_hindu,
                      size: 30.sp,
                      color: const Color(0xFFBDBDBD),
                    ),
                  ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  puja?.title ?? pujaSnapshot?.name ?? 'Pooja',
                  style: AppTypography.h3.copyWith(
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.sp,
                      color: const Color(0xFF757575),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AutoTranslateText(
                        temple?.name ?? pujaSnapshot?.templeName ?? 'Temple',
                        style: AppTypography.body2.copyWith(
                          color: const Color(0xFF757575),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSection(MyBookingDetailModel booking) {
    final package = booking.packageSnapshot;
    return BookingInfoSection(
      title: 'Package Details',
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [
          BookingDetailRow(
            label: 'Package',
            value: package?.packageName ?? 'N/A',
          ),
          BookingDetailRow(
            label: 'Members',
            value: '${package?.personCount ?? 1}',
          ),
          if (package?.inclusions != null && package!.inclusions!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Inclusions:',
                    style: AppTypography.body2.copyWith(
                      color: const Color(0xFF757575),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: package.inclusions!.map((inclusion) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orangeGradient.colors.first
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: AutoTranslateText(
                          inclusion,
                          style: AppTypography.label.copyWith(
                            color: AppColors.orangeGradient.colors.first,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection(MyBookingDetailModel booking) {
    return BookingInfoSection(
      title: 'Participants (${booking.participants?.length ?? 0})',
      icon: Icons.people_outline_rounded,
      child: Column(
        children: List.generate(
          booking.participants?.length ?? 0,
          (index) => ParticipantCard(
            participant: booking.participants?[index] ?? ParticipantInfo(),
            index: index,
          ),
        ),
      ),
    );
  }

  Widget _buildSankalpSection(booking) {
    return BookingInfoSection(
      title: 'Sankalp Notes',
      icon: Icons.note_alt_outlined,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        ),
        child: AutoTranslateText(
          booking.sankalpNotes ?? '',
          style: AppTypography.body2.copyWith(
            color: const Color(0xFF616161),
            height: 1.5,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection(booking) {
    final pricing = booking.pricing;
    return BookingInfoSection(
      title: 'Price Breakdown',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          BookingDetailRow(
            label: 'Package Price',
            value: '₹${pricing?.packagePrice?.toStringAsFixed(0) ?? '0'}',
          ),
          if (pricing?.discount != null && pricing!.discount! > 0)
            BookingDetailRow(
              label: 'Discount',
              value: '-₹${pricing.discount?.toStringAsFixed(0) ?? '0'}',
              valueColor: const Color(0xFF4CAF50),
            ),
          BookingDetailRow(
            label: 'Subtotal',
            value: '₹${pricing?.subtotal?.toStringAsFixed(0) ?? '0'}',
          ),
          BookingDetailRow(
            label:
                'Tax (GST ${pricing?.taxBreakup?.gstRate?.toStringAsFixed(0) ?? '0'}%)',
            value: '₹${pricing?.tax?.toStringAsFixed(0) ?? '0'}',
          ),
          Container(
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.only(top: 8.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoTranslateText(
                  'Total',
                  style: AppTypography.body1.copyWith(
                    color: const Color(0xFF212121),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AutoTranslateText(
                  '₹${pricing?.total?.toStringAsFixed(0) ?? '0'}',
                  style: AppTypography.h2.copyWith(
                    color: const Color(0xFF5D1C21),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(booking) {
    final payment = booking.payment;
    return BookingInfoSection(
      title: 'Payment Status',
      icon: Icons.payment_outlined,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                'Method',
                style: AppTypography.body2.copyWith(
                  color: const Color(0xFF757575),
                ),
              ),
              SizedBox(height: 4.h),
              AutoTranslateText(
                (payment?.method ?? 'N/A').toUpperCase(),
                style: AppTypography.body1.copyWith(
                  color: const Color(0xFF212121),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: controller
                  .getPaymentStatusColor(payment?.status)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: AutoTranslateText(
              (payment?.status ?? 'Unknown').toUpperCase(),
              style: AppTypography.label.copyWith(
                color: controller.getPaymentStatusColor(payment?.status),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


