import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/controller/address_selection_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/widgets/address_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/widgets/address_bottom_bar_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/widgets/empty_address_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddressSelectionView extends BasePage<AddressSelectionController> {
  const AddressSelectionView({super.key});

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
              title: 'Select Address',
              customActions: [
                GestureDetector(
                  onTap: () => controller.onAddNewAddress(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: '#6F221E'.toColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: '#6F221E'.toColor(),
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        AutoTranslateText(
                          'Add New',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: '#6F221E'.toColor(),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
            ),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.addresses.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF38B3B)),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.addresses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64.sp,
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                        SizedBox(height: 16.h),
                        AutoTranslateText(
                          controller.errorMessage.value,
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () => controller.loadAddresses(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF38B3B),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const AutoTranslateText('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.addresses.isEmpty) {
                  return const EmptyAddressWidget();
                }

                return RefreshIndicator(
                  onRefresh: () => controller.loadAddresses(),
                  color: const Color(0xFFF38B3B),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section title
                        Padding(
                          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  gradient: AppColors.orangeGradient,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoTranslateText(
                                      'Saved Addresses',
                                      style: MyTextTheme.mediumBCB.copyWith(
                                        color: const Color(0xFF5D1C21),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    AutoTranslateText(
                                      '${controller.addresses.length} address${controller.addresses.length > 1 ? 'es' : ''} found',
                                      style: MyTextTheme.smallBCN.copyWith(
                                        color: const Color(0xFF757575),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Address cards
                        ...controller.addresses.map((address) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: AddressCardWidget(
                              address: address,
                              isSelected:
                                  controller.selectedAddress.value?.id ==
                                  address.id,
                              onSelect: () => controller.selectAddress(address),
                              onEdit: () => controller.onEditAddress(address),
                              onDelete: () =>
                                  _showDeleteConfirmation(context, address.id!),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
            ),
            // Bottom action bar
            const AddressBottomBarWidget(),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            const Expanded(
              child: AutoTranslateText(
                'Delete Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const AutoTranslateText(
          'Are you sure you want to delete this address? This action cannot be undone.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AutoTranslateText(
              'Cancel',
              style: TextStyle(color: const Color(0xFF757575), fontSize: 14),
            ),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isDeleting.value
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      controller.deleteAddress(addressId);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: controller.isDeleting.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const AutoTranslateText('Delete'),
            ),
          ),
        ],
      ),
    );
  }
}
