import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_booking_form/controller/puja_booking_form_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PujaBookingFormView extends BasePage<PujaBookingFormController> {
  const PujaBookingFormView({super.key});

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
              title: 'Book Puja',
              subtitle: AutoTranslateText(
                controller.pujaTitle ?? 'Complete your booking',
                style: MyTextTheme.smallWCN.copyWith(
                  color: '#6F221E'.toColor().withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking Summary Card
                      _buildBookingSummaryCard(),
                      SizedBox(height: 20.h),

                      // Selected Address Card
                      _buildSelectedAddressCard(),
                      SizedBox(height: 20.h),

                      // Participants Section Header
                      _buildSectionHeader(
                        'Participant Details',
                        Icons.people_outline_rounded,
                        subtitle:
                            '${controller.personCount} ${controller.personCount > 1 ? 'members' : 'member'} required',
                      ),
                      SizedBox(height: 12.h),

                      // Participant Forms
                      Obx(
                        () => Column(
                          children: List.generate(
                            controller.participantForms.length,
                            (index) => _buildParticipantCard(index),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Sankalp Notes Section
                      _buildSectionHeader(
                        'Sankalp Notes',
                        Icons.note_alt_outlined,
                        subtitle: 'Optional special wishes or prayers',
                      ),
                      SizedBox(height: 12.h),
                      _buildSankalpNotesCard(),

                      SizedBox(height: 32.h),

                      // Book Now Button
                      Obx(
                        () => MyButton(
                          title: controller.isBooking.value
                              ? 'Booking...'
                              : 'Book Now',
                          width: double.infinity,
                          height: 56.h,
                          useGradient: true,
                          onPress: controller.isBooking.value
                              ? null
                              : () => controller.submitBooking(),
                          prefixIcon: controller.isBooking.value
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.white,
                                  size: 22.sp,
                                ),
                        ),
                      ),

                      SizedBox(height: 16.h),
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

  Widget _buildBookingSummaryCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5D1C21).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.temple_hindu_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      controller.pujaTitle ?? 'Puja Booking',
                      style: MyTextTheme.mediumWCB.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: AutoTranslateText(
                        controller.packageName ?? 'Package',
                        style: MyTextTheme.smallWCN.copyWith(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.15)),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Total Amount',
                    style: MyTextTheme.smallWCN.copyWith(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      AutoTranslateText(
                        '₹',
                        style: MyTextTheme.mediumWCB.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AutoTranslateText(
                        controller.price?.toStringAsFixed(0) ?? '0',
                        style: MyTextTheme.mediumWCB.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: const Color(0xFF5D1C21),
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    AutoTranslateText(
                      '${controller.personCount} ${controller.personCount > 1 ? 'Members' : 'Member'}',
                      style: MyTextTheme.smallWCB.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF5D1C21),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAddressCard() {
    final address = controller.selectedAddress;
    if (address == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      'Delivery Address',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(0xFF9E9E9E),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    AutoTranslateText(
                      address.fullName ?? 'Unknown',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: const Color(0xFF212121),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (address.isDefault == true)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: AutoTranslateText(
                    'DEFAULT',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          AutoTranslateText(
            _buildAddressString(address),
            style: MyTextTheme.smallBCN.copyWith(
              color: const Color(0xFF616161),
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14.sp,
                color: const Color(0xFF9E9E9E),
              ),
              SizedBox(width: 6.w),
              AutoTranslateText(
                address.phone ?? 'No phone',
                style: MyTextTheme.smallBCN.copyWith(
                  color: const Color(0xFF757575),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildAddressString(dynamic address) {
    final parts = <String>[];
    if (address.addressLine1 != null) parts.add(address.addressLine1);
    if (address.addressLine2 != null) parts.add(address.addressLine2);
    if (address.city != null) parts.add(address.city);
    if (address.state != null) parts.add(address.state);
    if (address.pincode != null) parts.add(address.pincode);
    return parts.join(', ');
  }

  Widget _buildSectionHeader(String title, IconData icon, {String? subtitle}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.orangeGradient.colors.first.withValues(
                  alpha: 0.3,
                ),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20.sp),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                title,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF5D1C21),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 2.h),
                AutoTranslateText(
                  subtitle,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF9E9E9E),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantCard(int index) {
    final form = controller.participantForms[index];
    final isExpanded = controller.currentExpandedIndex.value == index;
    final memberNumber = index + 1;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isExpanded
              ? AppColors.orangeGradient.colors.first.withValues(alpha: 0.5)
              : const Color(0xFFEEEEEE),
          width: isExpanded ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? AppColors.orangeGradient.colors.first.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: isExpanded ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Collapsible Header
          InkWell(
            onTap: () => controller.toggleExpandedIndex(index),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
              bottom: isExpanded ? Radius.zero : Radius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      gradient: isExpanded ? AppColors.orangeGradient : null,
                      color: isExpanded ? null : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        '$memberNumber',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: isExpanded
                              ? Colors.white
                              : const Color(0xFF757575),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          memberNumber == 1
                              ? 'Primary Member'
                              : 'Family Member $memberNumber',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFF212121),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AutoTranslateText(
                          form.nameController.text.isNotEmpty
                              ? form.nameController.text
                              : 'Tap to add details',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF757575),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isExpanded
                          ? AppColors.orangeGradient.colors.first
                          : const Color(0xFF9E9E9E),
                      size: 28.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildParticipantFormFields(form, index),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantFormFields(ParticipantFormData form, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        children: [
          Container(height: 1, color: const Color(0xFFF0F0F0)),
          SizedBox(height: 16.h),

          // Name
          MyTextField(
            headerText: 'Full Name *',
            hintText: 'Enter participant name',
            controller: form.nameController,
            keyboardType: TextInputType.name,
            prefixIcon: Icon(Icons.person_outline, color: AppColors.saffron),
            validator: (value) => controller.validateRequired(value, 'Name'),
          ),
          SizedBox(height: 14.h),

          // Gotra
          MyTextField(
            headerText: 'Gotra *',
            hintText: 'Enter gotra',
            controller: form.gotraController,
            keyboardType: TextInputType.text,
            prefixIcon: Icon(
              Icons.account_tree_outlined,
              color: AppColors.saffron,
            ),
            validator: (value) => controller.validateRequired(value, 'Gotra'),
          ),
          SizedBox(height: 14.h),

          // Mobile
          MyTextField(
            headerText: 'Mobile Number *',
            hintText: 'Enter 10-digit mobile number',
            controller: form.mobileController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.saffron),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: controller.validatePhone,
            onChanged: (value) {
              if (form.sameAsPhone.value) {
                form.whatsAppController.text = value ?? '';
              }
            },
          ),
          SizedBox(height: 14.h),

          // WhatsApp with same as phone toggle
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        headerText: 'WhatsApp Number',
                        hintText: 'Enter WhatsApp number',
                        controller: form.whatsAppController,
                        keyboardType: TextInputType.phone,
                        enabled: !form.sameAsPhone.value,
                        prefixIcon: Icon(
                          Icons.message_outlined,
                          color: AppColors.saffron,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => controller.toggleSameAsPhone(
                    index,
                    !form.sameAsPhone.value,
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          gradient: form.sameAsPhone.value
                              ? AppColors.orangeGradient
                              : null,
                          color: form.sameAsPhone.value ? null : Colors.white,
                          border: Border.all(
                            color: form.sameAsPhone.value
                                ? Colors.transparent
                                : const Color(0xFFBDBDBD),
                            width: 1.5,
                          ),
                        ),
                        child: form.sameAsPhone.value
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14.sp,
                              )
                            : null,
                      ),
                      SizedBox(width: 10.w),
                      AutoTranslateText(
                        'Same as mobile number',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF616161),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Nakshatra and Rashi row
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  'Nakshatra',
                  form.nakshatraController,
                  controller.nakshatraList,
                  Icons.star_outline_rounded,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDropdownField(
                  'Rashi',
                  form.rashiController,
                  controller.rashiList,
                  Icons.nights_stay_outlined,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Relation
          _buildDropdownField(
            'Relation',
            form.relationController,
            controller.relationList,
            Icons.family_restroom_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    TextEditingController textController,
    List<String> options,
    IconData icon,
  ) {
    return MyTextField(
      headerText: label,
      hintText: 'Select $label',
      controller: textController,
      maxLine: 1,
      readOnly: true,
      prefixIcon: Icon(icon, color: AppColors.saffron),
      suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.saffron),
      onTap: () {
        _showSelectionBottomSheet(label, textController, options);
      },
    );
  }

  void _showSelectionBottomSheet(
    String title,
    TextEditingController textController,
    List<String> options,
  ) {
    Get.bottomSheet(
      Container(
        height: 400.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            AutoTranslateText(
              'Select $title',
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF5D1C21),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = textController.text == option;
                  return ListTile(
                    onTap: () {
                      textController.text = option;
                      Get.back();
                    },
                    leading: isSelected
                        ? Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              gradient: AppColors.orangeGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          )
                        : null,
                    title: AutoTranslateText(
                      option,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: isSelected
                            ? AppColors.orangeGradient.colors.first
                            : const Color(0xFF424242),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.orangeGradient.colors.first,
                            size: 22.sp,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSankalpNotesCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: MyTextField(
        headerText: 'Special Wishes / Prayer Notes',
        hintText: 'Enter your sankalp or special wishes for the puja...',
        controller: controller.sankalpNotesController,
        keyboardType: TextInputType.multiline,
        maxLine: 4,
        minLine: 3,
        prefixIcon: Icon(Icons.edit_note_rounded, color: AppColors.saffron),
      ),
    );
  }
}
