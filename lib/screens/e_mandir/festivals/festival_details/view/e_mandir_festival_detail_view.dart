import 'package:astrobharataiuser/screens/e_mandir/festivals/festival_details/controller/festival_detail_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/core/services/share_service.dart';

import '../../../../../app_manager/network_image.dart';

class EMandirFestivalDetailView extends GetView<FestivalDetailController> {
  const EMandirFestivalDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final festival = controller.festival;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Header with share button ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CommonHeader(
                  title: festival.title,
                  showDrawer: false,
                  customActions: [
                    GestureDetector(
                      onTap: () => _shareFestival(
                        festival.title,
                        festival.shortDescription,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.share_rounded,
                          color: AppColors.deepOrange,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Scrollable body ──
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),

                        // ── Hero image ──
                        Hero(
                          tag: 'festival_image_${festival.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: NetworkImageWithLoader(
                              url: festival.image,
                              width: double.infinity,
                              height: 220.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // ── Title ──
                        AutoTranslateText(
                          festival.title,
                          style: AppTypography.h2.copyWith(
                            color: AppColors.textColorMaroon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // ── Upcoming badge ──
                        if (festival.isUpcoming)
                          Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.shade400,
                                  Colors.deepOrange.shade400,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.event_rounded,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 6.w),
                                AutoTranslateText(
                                  'Upcoming Festival',
                                  style: AppTypography.body2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ── Short description ──
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.orange.shade100),
                          ),
                          child: AutoTranslateText(
                            festival.shortDescription,
                            style: AppTypography.body1.copyWith(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // ── Long description header ──
                        AutoTranslateText(
                          'About the Festival',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textColorMaroon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // ── Long description body ──
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.orange.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: AutoTranslateText(
                            festival.longDescription,
                            style: AppTypography.body1.copyWith(
                              color: Colors.grey.shade800,
                              height: 1.6,
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),
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

  void _shareFestival(String title, String description) {
    ShareService.shareFestival(
      festivalId: controller.festival.id,
      festivalName: title,
    );
  }
}
