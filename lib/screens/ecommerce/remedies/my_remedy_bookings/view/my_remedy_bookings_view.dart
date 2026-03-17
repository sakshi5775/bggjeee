import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/remedy_booking_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/my_remedy_bookings/controller/my_remedy_bookings_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyRemedyBookingsView extends BasePage<MyRemedyBookingsController> {
  const MyRemedyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'My Remedy Bookings'),
            _buildFilters(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => controller.refresh(),
                color: AppColors.orangeGradient.colors.first,
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.bookings.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.deepOrange,
                        strokeWidth: 2,
                      ),
                    );
                  }
                  if (controller.bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 64.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          AutoTranslateText(
                            'No remedy bookings yet',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          AutoTranslateText(
                            'Book a remedy from the Remedies section',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    itemCount: controller.bookings.length +
                        (controller.hasNextPage ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.bookings.length) {
                        controller.loadBookings(reset: false);
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.deepOrange,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      return _buildBookingCard(controller.bookings[index]);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        border: Border(
          bottom: BorderSide(
            color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => _dropdown(
                  context,
                  'Status',
                  controller.statusFilter.value,
                  MyRemedyBookingsController.statusOptions,
                  controller.setStatus,
                )),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(() => _dropdown(
                  context,
                  'Sort',
                  controller.sortBy.value,
                  MyRemedyBookingsController.sortByOptions,
                  controller.setSortBy,
                )),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(() => _dropdown(
                  context,
                  'Order',
                  controller.sortOrder.value,
                  MyRemedyBookingsController.sortOrderOptions,
                  controller.setSortOrder,
                )),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    BuildContext context,
    String label,
    String value,
    List<String> options,
    void Function(String) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      ),
      isExpanded: true,
      items: options.map((opt) {
        return DropdownMenuItem(
          value: opt,
          child: Text(
            opt == 'all' ? 'All' : opt,
            style: TextStyle(fontSize: 12.sp),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _buildBookingCard(RemedyBookingItem item) {
    final snapshot = item.serviceSnapshot;
    final status = item.status ?? 'pending';
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.remedyBookingDetail,
        arguments: {'bookingId': item.id, 'bookingItem': item},
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: snapshot?.image ?? '',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    snapshot?.title ?? 'Remedy',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3E1212),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹${item.pricing?.totalAmount?.toStringAsFixed(0) ?? '0'}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepOrange,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(status),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
