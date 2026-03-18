import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/controller/address_selection_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddressBottomBarWidget extends StatelessWidget {
  const AddressBottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressSelectionController>();

    return Obx(() {
      final hasSelection = controller.selectedAddress.value != null;
      final selectedAddress = controller.selectedAddress.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            children: [
              // Selected address info
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: hasSelection ? 1.0 : 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'DELIVER TO',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF9E9E9E),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      if (hasSelection && selectedAddress != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getTypeIcon(selectedAddress.type),
                                  size: 16.sp,
                                  color: const Color(0xFF5D1C21),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: AutoTranslateText(
                                    selectedAddress.fullName ?? 'Unknown',
                                    style: MyTextTheme.mediumBCB.copyWith(
                                      color: const Color(0xFF212121),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            AutoTranslateText(
                              '${selectedAddress.city ?? ''}, ${selectedAddress.state ?? ''} - ${selectedAddress.pincode ?? ''}',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: const Color(0xFF757575),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      else
                        AutoTranslateText(
                          'Select an address',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF9E9E9E),
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Continue button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52.h,
                constraints: BoxConstraints(minWidth: 140.w),
                decoration: BoxDecoration(
                  gradient: hasSelection
                      ? AppColors.orangeGradient
                      : LinearGradient(
                          colors: [
                            const Color(0xFFE0E0E0),
                            const Color(0xFFBDBDBD),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(26.r),
                  boxShadow: hasSelection
                      ? [
                          BoxShadow(
                            color: AppColors.orangeGradient.colors.first
                                .withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: hasSelection
                        ? () => controller.onProceedToPayment()
                        : null,
                    borderRadius: BorderRadius.circular(26.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AutoTranslateText(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  IconData _getTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'office':
        return Icons.business_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}
