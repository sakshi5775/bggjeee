import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/remedy_booking_form/controller/remedy_booking_form_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemedyBookingFormView extends BasePage<RemedyBookingFormController> {
  const RemedyBookingFormView({super.key});

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
                  fontSize: 12.sp,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSummaryCard(),
                      SizedBox(height: 20.h),
                      _sectionTitle('Customer Details', Icons.person_outline),
                      SizedBox(height: 10.h),
                      _buildCustomerSection(),
                      SizedBox(height: 20.h),
                      _sectionTitle('Booking Details', Icons.calendar_today),
                      SizedBox(height: 10.h),
                      _buildBookingSection(context),
                      SizedBox(height: 20.h),
                      _sectionTitle('Person Details (for remedy)', Icons.face_rounded),
                      SizedBox(height: 10.h),
                      _buildPersonSection(context),
                      SizedBox(height: 28.h),
                      Obx(
                        () => MyButton(
                          title: controller.isSubmitting.value
                              ? 'Creating...'
                              : (controller.isPaymentInProgress.value
                                  ? 'Opening payment...'
                                  : 'Proceed to Pay'),
                          width: double.infinity,
                          height: 52.h,
                          useGradient: true,
                          onPress: (controller.isSubmitting.value ||
                                  controller.isPaymentInProgress.value)
                              ? null
                              : () => controller.submitBooking(),
                          prefixIcon: (controller.isSubmitting.value ||
                                  controller.isPaymentInProgress.value)
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(Icons.payment_rounded,
                                  color: Colors.white, size: 22.sp),
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

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: Colors.white, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        AutoTranslateText(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3E1212),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 26.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  controller.serviceTitle ?? 'Remedy',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  '₹${controller.price?.toStringAsFixed(0) ?? '0'}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          MyTextField(
            controller: controller.fullNameController,
            hintText: 'Full Name',
            labelText: 'Full Name',
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.emailController,
            hintText: 'Email',
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.phoneController,
            hintText: 'Phone',
            labelText: 'Phone',
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (v.trim().length < 10) return 'Valid 10-digit number';
              return null;
            },
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.alternatePhoneController,
            hintText: 'Alternate Phone (optional)',
            labelText: 'Alternate Phone',
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.addressLine1Controller,
            hintText: 'Address Line 1',
            labelText: 'Address Line 1',
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.addressLine2Controller,
            hintText: 'Address Line 2 (optional)',
            labelText: 'Address Line 2',
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  controller: controller.cityController,
                  hintText: 'City',
                  labelText: 'City',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: MyTextField(
                  controller: controller.stateController,
                  hintText: 'State',
                  labelText: 'State',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.pincodeController,
            hintText: 'Pincode',
            labelText: 'Pincode',
            keyboardType: TextInputType.number,
            maxLength: 6,
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
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
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
                decoration: InputDecoration(
                  labelText: 'Preferred Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  d != null
                      ? '${d.day}/${d.month}/${d.year}'
                      : 'Select date',
                  style: TextStyle(
                    color: d != null ? Colors.black87 : Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 12.h),
          AutoTranslateText('Time Slot', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
          SizedBox(height: 6.h),
          Obx(
            () => Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.timeSlots.map((slot) {
                final selected = controller.preferredTimeSlot.value == slot;
                return ChoiceChip(
                  label: Text(
                    slot.toUpperCase(),
                    style: TextStyle(fontSize: 11.sp),
                  ),
                  selected: selected,
                  onSelected: (_) => controller.setTimeSlot(slot),
                  selectedColor: AppColors.orangeGradient.colors.first,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontSize: 11.sp,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.specialInstructionsController,
            hintText: 'Special instructions (optional)',
            maxLine: 2,
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.purposeController,
            hintText: 'Purpose (optional)',
          ),
        ],
      ),
    );
  }

  Widget _buildPersonSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          MyTextField(
            controller: controller.personNameController,
            hintText: 'Name',
            labelText: 'Name',
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 12.h),
          Obx(() {
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
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  d != null
                      ? '${d.day}/${d.month}/${d.year}'
                      : 'Select DOB',
                  style: TextStyle(
                    color: d != null ? Colors.black87 : Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.birthPlaceController,
            hintText: 'Birth Place (optional)',
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.birthTimeController,
            hintText: 'Birth Time (optional)',
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.gotraController,
            hintText: 'Gotra (optional)',
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.rashiController,
            hintText: 'Rashi (optional)',
          ),
          SizedBox(height: 12.h),
          MyTextField(
            controller: controller.nakshatraController,
            hintText: 'Nakshatra (optional)',
          ),
        ],
      ),
    );
  }
}
