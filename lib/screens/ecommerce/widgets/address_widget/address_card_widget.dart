import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

enum AddressListAction { edit, setDefault, delete }

class AddressCardWidget extends StatelessWidget {
  final AddressModel address;
  final bool isDefault;
  final DateFormat dateFormat;
  final Function(AddressListAction, AddressModel) onAction;

  const AddressCardWidget({
    super.key,
    required this.address,
    required this.isDefault,
    required this.dateFormat,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final addressType = (address.type ?? 'home').toUpperCase();
    final updatedDate =
        address.updatedAt ??
        address.createdAt ??
        DateTime.now().toIso8601String();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white,
            '#FEF6C3'.toColor().withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDefault
              ? '#E3B341'.toColor().withValues(alpha: 0.4)
              : '#68171E'.toColor().withValues(alpha: 0.15),
          width: isDefault ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: '#68171E'.toColor().withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Icon
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: '#68171E'.toColor().withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getAddressTypeIcon(address.type ?? 'home'),
                        color: '#E3B341'.toColor(),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Address Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          AutoTranslateText(
                            address.fullName ?? '',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              color: '#68171E'.toColor(),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Address Lines
                          _AddressInfoRow(
                            icon: Icons.location_on_rounded,
                            text:
                                '${address.addressLine1 ?? ''}${address.addressLine2 != null ? ', ${address.addressLine2}' : ''}',
                          ),
                          SizedBox(height: 4.h),
                          _AddressInfoRow(
                            icon: Icons.public_rounded,
                            text:
                                '${address.city ?? ''}, ${address.state ?? ''}${address.pincode != null ? ' - ${address.pincode}' : ''}',
                          ),
                          if (address.landmark != null &&
                              address.landmark!.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            _AddressInfoRow(
                              icon: Icons.place_rounded,
                              text: 'Landmark: ${address.landmark}',
                            ),
                          ],
                          SizedBox(height: 8.h),
                          // Contact Info
                          _AddressInfoRow(
                            icon: Icons.phone_rounded,
                            text: address.phone ?? '',
                          ),
                          if (address.email != null &&
                              address.email!.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            _AddressInfoRow(
                              icon: Icons.mail_rounded,
                              text: address.email!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Badges
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _AddressBadge(
                      label: addressType,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.saffron.withValues(alpha: 0.2),
                          AppColors.saffron.withValues(alpha: 0.1),
                        ],
                      ),
                      textColor: AppColors.saffron,
                      icon: _getAddressTypeIcon(address.type ?? 'home'),
                    ),
                    if (isDefault)
                      _AddressBadge(
                        label: 'DEFAULT',
                        gradient: LinearGradient(
                          colors: [
                            '#E3B341'.toColor().withValues(alpha: 0.2),
                            '#E3B341'.toColor().withValues(alpha: 0.1),
                          ],
                        ),
                        textColor: '#E3B341'.toColor(),
                        icon: Icons.star_rounded,
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Updated Date
                AutoTranslateText(
                  'Updated on ${dateFormat.format(DateTime.parse(updatedDate))}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Action Menu Button
          Positioned(
            top: 12.h,
            right: 12.w,
            child: PopupMenuButton<AddressListAction>(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: '#68171E'.toColor().withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.more_vert_rounded,
                  size: 18.sp,
                  color: '#68171E'.toColor(),
                ),
              ),
              onSelected: (action) => onAction(action, address),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: AddressListAction.edit,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_rounded,
                        size: 18.sp,
                        color: '#68171E'.toColor(),
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'Edit',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isDefault)
                  PopupMenuItem(
                    value: AddressListAction.setDefault,
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_outline_rounded,
                          size: 18.sp,
                          color: AppColors.saffron,
                        ),
                        SizedBox(width: 8.w),
                        AutoTranslateText(
                          'Set as default',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: '#68171E'.toColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: AddressListAction.delete,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: 18.sp,
                        color: AppColors.sacredRed,
                      ),
                      SizedBox(width: 8.w),
                      AutoTranslateText(
                        'Delete',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: AppColors.sacredRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAddressTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'other':
        return Icons.location_city_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}

class _AddressInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AddressInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: AppColors.textSecondary),
        SizedBox(width: 8.w),
        Expanded(
          child: AutoTranslateText(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressBadge extends StatelessWidget {
  final String label;
  final Gradient gradient;
  final Color textColor;
  final IconData icon;

  const _AddressBadge({
    required this.label,
    required this.gradient,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: textColor),
          SizedBox(width: 6.w),
          AutoTranslateText(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
