import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_booking_form/controller/remedy_booking_form_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemedyBookingFormView extends BasePage<RemedyBookingFormController> {
  const RemedyBookingFormView({super.key});

  static const double _cardRadius = 10;
  static const double _sectionSpacing = 12;
  static const double _fieldGap = 6;

  void _showLocationSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: LocationBottomSheetWidget(
          selectedCity: controller.birthPlaceController.text.trim().isEmpty
              ? 'Select birth place'
              : controller.birthPlaceController.text.trim(),
          onCitySelected: (city, state, country, [lat, lng, tz]) {
            final parts = [city, state, country]
                .where((s) => s != null && s.toString().trim().isNotEmpty)
                .toList();
            controller.birthPlaceController.text = parts.join(', ');
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  /// Compact, filled input style so the form looks clearly different from default
  InputDecoration _inputDecoration(
    String label, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF8F6F3),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
      hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.deepOrange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: 'Book Remedy',
              subtitle: AutoTranslateText(
                controller.serviceTitle ?? 'Complete your booking',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSummaryCard(),
                      SizedBox(height: _sectionSpacing.h),
                      _sectionTitle('Customer Details', Icons.person_outline_rounded),
                      SizedBox(height: 5.h),
                      _buildCustomerSection(context),
                      SizedBox(height: _sectionSpacing.h),
                      _sectionTitle('Booking Details', Icons.event_note_rounded),
                      SizedBox(height: 5.h),
                      _buildBookingSection(context),
                      SizedBox(height: _sectionSpacing.h),
                      _sectionTitle('Person (for remedy)', Icons.face_rounded),
                      SizedBox(height: 5.h),
                      _buildPersonSection(context),
                      SizedBox(height: 18.h),
                      Obx(
                        () => MyButton(
                          title: controller.isSubmitting.value
                              ? 'Creating...'
                              : (controller.isPaymentInProgress.value
                                  ? 'Opening payment...'
                                  : 'Proceed to Pay'),
                          width: double.infinity,
                          height: 46.h,
                          useGradient: true,
                          onPress: (controller.isSubmitting.value ||
                                  controller.isPaymentInProgress.value)
                              ? null
                              : () => controller.submitBooking(),
                          prefixIcon: (controller.isSubmitting.value ||
                                  controller.isPaymentInProgress.value)
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(Icons.payment_rounded,
                                  color: Colors.white, size: 18.sp),
                        ),
                      ),
                      SizedBox(height: 10.h),
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

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(6.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.35),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 14.sp),
        ),
        SizedBox(width: 6.w),
        AutoTranslateText(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF3E1212),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(_cardRadius.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoTranslateText(
                  controller.serviceTitle ?? 'Remedy',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  '₹${controller.price?.toStringAsFixed(0) ?? '0'}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardWrapper(Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius.r),
        border: Border(
          left: BorderSide(
            color: AppColors.deepOrange,
            width: 3.w,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCustomerSection(BuildContext context) {
    return _cardWrapper(
      Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.fullNameController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  decoration: _inputDecoration('Full Name'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormField(
                  controller: controller.emailController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Email'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: _fieldGap.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.phoneController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: _inputDecoration('Phone'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 10) return '10 digits';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormField(
                  controller: controller.alternatePhoneController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: _inputDecoration('Alt. Phone'),
                ),
              ),
            ],
          ),
          SizedBox(height: _fieldGap.h),
          TextFormField(
            controller: controller.addressLine1Controller,
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
            ),
            decoration: _inputDecoration('Address Line 1'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: _fieldGap.h),
          TextFormField(
            controller: controller.addressLine2Controller,
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
            ),
            decoration: _inputDecoration('Address Line 2 (optional)'),
          ),
          SizedBox(height: _fieldGap.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.cityController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  decoration: _inputDecoration('City'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormField(
                  controller: controller.stateController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  decoration: _inputDecoration('State'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: _fieldGap.h),
          TextFormField(
            controller: controller.pincodeController,
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: _inputDecoration('Pincode'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (v.trim().length != 6) return '6 digits';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSection(BuildContext context) {
    return _cardWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() {
            final d = controller.preferredDate.value;
            return InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: d ?? DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) controller.setPreferredDate(picked);
              },
              child: InputDecorator(
                decoration: _inputDecoration('Preferred Date'),
                child: Text(
                  d != null ? '${d.day}/${d.month}/${d.year}' : 'Select',
                  style: TextStyle(
                    color: d != null ? Colors.black87 : Colors.grey,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: _fieldGap.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
            child: AutoTranslateText(
              'Time Slot',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Obx(
            () => Row(
              children: controller.timeSlots.map((slot) {
                final selected = controller.preferredTimeSlot.value == slot;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: ChoiceChip(
                      label: Text(
                        slot.toUpperCase(),
                        style: TextStyle(fontSize: 10.sp),
                      ),
                      selected: selected,
                      onSelected: (_) => controller.setTimeSlot(slot),
                      selectedColor: AppColors.orangeGradient.colors.first,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontSize: 10.sp,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 6.h,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: _fieldGap.h),
          TextFormField(
            controller: controller.specialInstructionsController,
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
            ),
            maxLines: 2,
            decoration: _inputDecoration('Special instructions (optional)'),
          ),
          SizedBox(height: _fieldGap.h),
          TextFormField(
            controller: controller.purposeController,
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
            ),
            decoration: _inputDecoration('Purpose (optional)'),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonSection(BuildContext context) {
    return _cardWrapper(
      Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.personNameController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  decoration: _inputDecoration('Name'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Obx(() {
                  final d = controller.personDob.value;
                  return InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: d ?? DateTime(1990, 1, 1),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) controller.setPersonDob(picked);
                    },
                    child: InputDecorator(
                      decoration: _inputDecoration('DOB'),
                      child: Text(
                        d != null
                            ? '${d.day}/${d.month}/${d.year}'
                            : 'Select',
                        style: TextStyle(
                          color: d != null ? Colors.black87 : Colors.grey,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: _fieldGap.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showLocationSheet(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: controller.birthPlaceController,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13.sp,
                      ),
                      decoration: _inputDecoration('Birth Place', hint: 'Tap to select'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormField(
                  controller: controller.birthTimeController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  decoration: _inputDecoration('Birth Time'),
                ),
              ),
            ],
          ),
          SizedBox(height: _fieldGap.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.gotraController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  decoration: _inputDecoration('Gotra'),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormField(
                  controller: controller.rashiController,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  decoration: _inputDecoration('Rashi'),
                ),
              ),
            ],
          ),
          SizedBox(height: _fieldGap.h),
          TextFormField(
            controller: controller.nakshatraController,
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
            ),
            decoration: _inputDecoration('Nakshatra (optional)'),
          ),
        ],
      ),
    );
  }
}
