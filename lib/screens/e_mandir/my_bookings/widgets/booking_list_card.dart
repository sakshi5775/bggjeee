import 'package:astrobharataiuser/data_model/my_booking_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingListCard extends StatelessWidget {
  final MyBookingItemModel booking;
  final VoidCallback onTap;
  final Color statusColor;

  const BookingListCard({
    super.key,
    required this.booking,
    required this.onTap,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with temple icon and booking ID
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Temple icon
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.temple_hindu_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                // Puja name and temple
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        booking.pujaSnapshot?.name ?? 'Puja Booking',
                        style: AppTypography.h2.copyWith(
                          color: const Color(0xFF212121),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
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
                              booking.pujaSnapshot?.templeName ?? 'Temple',
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
            SizedBox(height: 14.h),
            // Divider
            Container(height: 1, color: const Color(0xFFF0F0F0)),
            SizedBox(height: 14.h),
            // Booking info row
            Row(
              children: [
                // Booking ID
                _buildInfoChip(
                  icon: Icons.confirmation_number_outlined,
                  label: booking.bookingId ?? 'N/A',
                ),
                SizedBox(width: 12.w),
                // Date
                _buildInfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: booking.formattedDate,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Bottom row with price and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Row(
                  children: [
                    AutoTranslateText(
                      '₹',
                      style: AppTypography.body1.copyWith(
                        color: const Color(0xFF5D1C21),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AutoTranslateText(
                      booking.pricing?.total?.toStringAsFixed(0) ?? '0',
                      style: AppTypography.h2.copyWith(
                        color: const Color(0xFF5D1C21),
                      ),
                    ),
                  ],
                ),
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AutoTranslateText(
                    booking.formattedStatus,
                    style: AppTypography.label.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: const Color(0xFF757575)),
          SizedBox(width: 6.w),
          AutoTranslateText(
            label,
            style: AppTypography.label.copyWith(
              color: const Color(0xFF616161),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
