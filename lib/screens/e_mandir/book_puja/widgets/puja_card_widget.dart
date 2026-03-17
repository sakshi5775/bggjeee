import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

import '../controller/book_puja_controller.dart';

class PujaCardWidget extends StatelessWidget {
  final PujaModel puja;
  final int index;
  final VoidCallback onBookNow;

  const PujaCardWidget({
    super.key,
    required this.puja,
    required this.index,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookPujaController>();
    final minPrice = controller.getMinPrice(puja);
    final duration = controller.getDuration(puja);
    final rating = puja.stats?.averageRating;
    final totalBookings = puja.stats?.totalBookings;

    return GestureDetector(
      onTap: () {
        if (puja.id != null && puja.id!.isNotEmpty) {
          UserMainController.pushInCurrentTab(
            AppRoutes.pujaDetail,
            arguments: puja.id,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B1925).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Image Section ──
              _buildHeroImage(rating),

              // ── Content Section ──
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    AutoTranslateText(
                      puja.title ?? 'Pooja',
                      style: TextStyle(
                        color: const Color(0xFF2D1810),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),

                    // Description
                    AutoTranslateText(
                      puja.subheading ??
                          puja.longDescription ??
                          'Divine blessings & spiritual fulfillment',
                      style: TextStyle(
                        color: const Color(0xFF8A8A8A),
                        fontSize: 12.sp,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),

                    // Info chips row
                    _buildInfoChips(duration, totalBookings),
                    SizedBox(height: 14.h),

                    // Price & Book Button Row
                    _buildPriceAndBookRow(minPrice),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Large hero image with gradient overlay and badges
  Widget _buildHeroImage(double? rating) {
    return SizedBox(
      height: 160.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          NetworkImageWithLoader(
            url: puja.image ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 160.h,
          ),

          // Bottom gradient for text readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Featured badge (top-left)
          if (puja.isFeatured == true)
            Positioned(
              top: 10.h,
              left: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE3B341), Color(0xFFD4A017)],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE3B341).withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 14.r, color: Colors.white),
                    SizedBox(width: 3.w),
                    Text(
                      'Featured',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Popular badge (top-left, offset if featured)
          if (puja.isPopular == true)
            Positioned(
              top: puja.isFeatured == true ? 38.h : 10.h,
              left: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 14.r,
                      color: Colors.white,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Popular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Rating badge (top-right)
          if (rating != null && rating > 0)
            Positioned(
              top: 10.h,
              right: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.r,
                      color: const Color(0xFFFFC107),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: const Color(0xFF3E2723),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Temple name badge (bottom-left)
          if (puja.temple?.name != null)
            Positioned(
              bottom: 10.h,
              left: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.temple_hindu_rounded,
                      size: 14.r,
                      color: const Color(0xFF8B1925),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      puja.temple!.name!,
                      style: TextStyle(
                        color: const Color(0xFF8B1925),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Info chips (duration, bookings)
  Widget _buildInfoChips(String duration, int? totalBookings) {
    return Row(
      children: [
        // Duration chip
        _buildChip(
          icon: Icons.schedule_rounded,
          label: duration,
          color: const Color(0xFF5C6BC0),
        ),
        SizedBox(width: 8.w),
        // Bookings chip
        if (totalBookings != null && totalBookings > 0)
          _buildChip(
            icon: Icons.people_alt_rounded,
            label: '$totalBookings+ booked',
            color: const Color(0xFF26A69A),
          ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.r, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Price and Book Now button row
  Widget _buildPriceAndBookRow(double? minPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Starts from',
              style: TextStyle(
                color: const Color(0xFFAAAAAA),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              minPrice != null ? '₹${minPrice.toInt()}' : 'Free',
              style: TextStyle(
                color: const Color(0xFF2D1810),
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        // Book Now button
        GestureDetector(
          onTap: () {
            if (puja.id != null && puja.id!.isNotEmpty) {
              UserMainController.pushInCurrentTab(
                AppRoutes.pujaDetail,
                arguments: puja.id,
              );
            } else {
              onBookNow();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 11.h),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.orangeGradient.colors.first.withValues(
                    alpha: 0.35,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoTranslateText(
                  'Book Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16.r,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
