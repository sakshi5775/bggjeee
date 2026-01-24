import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_selection/controller/address_selection_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddressCardWidget extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCardWidget({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressSelectionController>();

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.orangeGradient.colors.first
                : const Color(0xFFEEEEEE),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.orangeGradient.colors.first.withValues(
                      alpha: 0.15,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with name, type badge, and selection indicator
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24.w,
                  height: 24.w,
                  margin: EdgeInsets.only(top: 2.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected ? AppColors.orangeGradient : null,
                    color: isSelected ? null : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : const Color(0xFFBDBDBD),
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.orangeGradient.colors.first
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16.sp,
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                // Name and address type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                AutoTranslateText(
                                  controller.getAddressTypeIcon(address.type),
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: AutoTranslateText(
                                    address.fullName ?? 'Unknown',
                                    style: MyTextTheme.mediumBCB.copyWith(
                                      color: const Color(0xFF212121),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Address type badge
                          if (address.type != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getTypeColor(
                                  address.type,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: AutoTranslateText(
                                address.type!.toUpperCase(),
                                style: MyTextTheme.smallBCB.copyWith(
                                  color: _getTypeColor(address.type),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          // Default badge
                          if (address.isDefault == true) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: AutoTranslateText(
                                'DEFAULT',
                                style: MyTextTheme.smallBCB.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Phone number
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 14.sp,
                            color: const Color(0xFF757575),
                          ),
                          SizedBox(width: 6.w),
                          AutoTranslateText(
                            address.phone ?? 'No phone',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: const Color(0xFF757575),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Divider
            Container(height: 1, color: const Color(0xFFF0F0F0)),
            SizedBox(height: 12.h),
            // Full address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18.sp,
                  color: AppColors.orangeGradient.colors.first,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AutoTranslateText(
                    _buildFullAddress(),
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF424242),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            // Landmark if available
            if (address.landmark != null && address.landmark!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.near_me_outlined,
                    size: 16.sp,
                    color: const Color(0xFF9E9E9E),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AutoTranslateText(
                      'Near ${address.landmark}',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(0xFF9E9E9E),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 16.h),
            // Action buttons
            Row(
              children: [
                // Set as Default button (only if not already default)
                if (address.isDefault != true)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.setAsDefaultAddress(address),
                      icon: Icon(
                        Icons.star_outline_rounded,
                        size: 16.sp,
                        color: const Color(0xFF4CAF50),
                      ),
                      label: AutoTranslateText(
                        'Set Default',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: const Color(0xFF4CAF50),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF4CAF50),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    ),
                  ),
                if (address.isDefault != true) SizedBox(width: 8.w),
                // Edit button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 16.sp,
                      color: AppColors.orangeGradient.colors.first,
                    ),
                    label: AutoTranslateText(
                      'Edit',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.orangeGradient.colors.first,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.orangeGradient.colors.first,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Delete button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 16.sp,
                      color: Colors.red,
                    ),
                    label: AutoTranslateText(
                      'Delete',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
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

  String _buildFullAddress() {
    final parts = <String>[];
    if (address.addressLine1 != null && address.addressLine1!.isNotEmpty) {
      parts.add(address.addressLine1!);
    }
    if (address.addressLine2 != null && address.addressLine2!.isNotEmpty) {
      parts.add(address.addressLine2!);
    }
    if (address.city != null && address.city!.isNotEmpty) {
      parts.add(address.city!);
    }
    if (address.state != null && address.state!.isNotEmpty) {
      parts.add(address.state!);
    }
    if (address.pincode != null && address.pincode!.isNotEmpty) {
      parts.add(address.pincode!);
    }
    if (address.country != null && address.country!.isNotEmpty) {
      parts.add(address.country!);
    }
    return parts.join(', ');
  }

  Color _getTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'home':
        return const Color(0xFF4CAF50);
      case 'office':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}
