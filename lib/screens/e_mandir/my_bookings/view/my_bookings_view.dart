import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/controller/my_bookings_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/widgets/booking_empty_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/widgets/booking_list_card.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyBookingsView extends BasePage<MyBookingsController> {
  const MyBookingsView({super.key});

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
              title: 'My Bookings',
              subtitle: AutoTranslateText(
                'Your puja booking history',
                style: AppTypography.body2.copyWith(color: Colors.white70),
              ),
            ),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.bookings.isEmpty) {
                  return _buildLoadingState();
                }

                if (controller.errorMessage.isNotEmpty &&
                    controller.bookings.isEmpty) {
                  return _buildErrorState();
                }

                if (controller.bookings.isEmpty) {
                  return BookingEmptyWidget(onBookNow: () => Get.back());
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshBookings,
                  color: AppColors.orangeGradient.colors.first,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    itemCount: controller.bookings.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.bookings.length) {
                        return _buildFooter();
                      }

                      final booking = controller.bookings[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: BookingListCard(
                          booking: booking,
                          statusColor: controller.getStatusColor(
                            booking.status,
                          ),
                          onTap: () => controller.onBookingTap(booking),
                          onPayNow: () =>
                              controller.onPayPendingBooking(booking),
                        ),
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
            'Loading bookings...',
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
              controller.errorMessage.value,
              style: AppTypography.body2.copyWith(
                color: const Color(0xFF757575),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: controller.loadBookings,
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

  Widget _buildFooter() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Center(
            child: SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.orangeGradient.colors.first,
              ),
            ),
          ),
        );
      }

      if (controller.pagination.value?.hasNextPage != true &&
          controller.bookings.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Center(
            child: AutoTranslateText(
              'No more bookings',
              style: AppTypography.label.copyWith(
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
