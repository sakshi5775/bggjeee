import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/controller/address_selection_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EmptyAddressWidget extends StatelessWidget {
  const EmptyAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressSelectionController>();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration container
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.orangeGradient.colors.first.withValues(
                      alpha: 0.1,
                    ),
                    AppColors.orangeGradient.colors.last.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.location_off_rounded,
                  size: 56.sp,
                  color: AppColors.orangeGradient.colors.first.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // Title
            AutoTranslateText(
              'No Saved Addresses',
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF5D1C21),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            // Description
            AutoTranslateText(
              'You haven\'t added any delivery address yet.\nAdd a new address to proceed with your puja booking.',
              style: MyTextTheme.smallBCN.copyWith(
                color: const Color(0xFF757575),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            // Add address button
            Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(27.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orangeGradient.colors.first.withValues(
                      alpha: 0.4,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.onAddNewAddress(),
                  borderRadius: BorderRadius.circular(27.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_location_alt_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      AutoTranslateText(
                        'Add New Address',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
