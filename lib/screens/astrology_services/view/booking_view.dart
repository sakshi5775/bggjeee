import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/astrology_services/controller/booking_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BookingView extends StatelessWidget {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());

    // If it's a chat, show loader (auto-redirecting)
    if (controller.callType == CallType.chat) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFFDFB343)),
              const SizedBox(height: 16),
              Text(
                'Starting Chat...',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF5F2221),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              CommonHeader(
                title: 'Booking',
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      controller.getHeaderIcon(),
                      color: const Color(0xFF6F221E),
                      size: 16.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      controller.getHeaderTitle(),
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: const Color(0xFF6F221E),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card
                      _buildProfileCard(controller),
                      Spacing.h(24),

                      // Choose Time Slot Section
                      _buildTimeSlotSection(controller),
                      Spacing.h(24),

                      // Estimated Duration Section
                      _buildDurationSection(controller),
                      Spacing.h(24),

                      // Cost Summary Section
                      _buildCostSummary(controller),
                      Spacing.h(24),

                      // Payment Method Section
                      _buildPaymentMethodSection(controller),
                      Spacing.h(100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Fixed Bottom Button
        bottomNavigationBar: _buildConfirmButton(controller),
      ),
    );
  }

  Widget _buildProfileCard(BookingController controller) {
    final astrologer = controller.astrologer;
    final isOnline = astrologer.isOnline;
    final rating = astrologer.rating;
    final pricePerMin = controller.getPricePerMinute();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0), // Light beige
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDFB343), width: 2),
                ),
                child: ClipOval(
                  child: _buildImage(astrologer.profilePicture, size: 70),
                ),
              ),
              // Online indicator
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 18.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          Spacing.w(12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name with verified badge
                Row(
                  children: [
                    Expanded(
                      child: AutoTranslateText(
                        astrologer.displayName,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: const Color(0xFF5F2221),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.verified, color: Colors.blue, size: 18.w),
                  ],
                ),
                Spacing.h(8),
                // Rating
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFB343).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFFDFB343),
                        size: 14.w,
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        rating.toStringAsFixed(1),
                        style: MyTextTheme.smallBCB.copyWith(
                          color: const Color(0xFF5F2221),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.h(8),
                // Price
                AutoTranslateText(
                  '₹ ${pricePerMin.toStringAsFixed(0)}/min',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: const Color(0xFF5F2221),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSection(BookingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, color: const Color(0xFF5F2221), size: 20.w),
            Spacing.w(8),
            AutoTranslateText(
              'Choose Time Slot',
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF5F2221),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Spacing.h(12),
        // Two buttons per row
        Column(
          children: [
            // First row: First 2 buttons
            Row(
              children: [
                Expanded(
                  child: _buildTimeSlotButton(
                    controller,
                    controller.timeSlots[0],
                    isDisabled: false,
                  ),
                ),
                Spacing.w(8),
                Expanded(
                  child: _buildTimeSlotButton(
                    controller,
                    controller.timeSlots[1],
                    isDisabled: false,
                  ),
                ),
              ],
            ),
            Spacing.h(8),
            // Second row: Last 2 buttons
            Row(
              children: [
                Expanded(
                  child: _buildTimeSlotButton(
                    controller,
                    controller.timeSlots[2],
                    isDisabled: false,
                  ),
                ),
                Spacing.w(8),
                Expanded(
                  child: _buildTimeSlotButton(
                    controller,
                    controller.timeSlots[3],
                    isDisabled: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationSection(BookingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Estimated Duration',
          style: MyTextTheme.mediumBCB.copyWith(
            color: const Color(0xFF5F2221),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(12),
        Row(
          children: controller.durations.map((duration) {
            return Expanded(
              child: Obx(() {
                final isSelected =
                    controller.selectedDuration.value == duration;
                return GestureDetector(
                  onTap: () => controller.setDuration(duration),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: duration != controller.durations.last ? 8.w : 0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFDFB343).withOpacity(
                              0.3,
                            ) // Light yellow/beige when selected
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFDFB343)
                            : const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        '$duration min',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF5F2221),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCostSummary(BookingController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0), // Light beige
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AutoTranslateText(
                '₹',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF5F2221),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.w(4),
              AutoTranslateText(
                'Cost Summary',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF5F2221),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          Obx(
            () => Column(
              children: [
                _buildCostRow(
                  'Rate per minute',
                  '₹${controller.getPricePerMinute().toStringAsFixed(0)}',
                ),
                Spacing.h(12),
                _buildCostRow(
                  'Duration',
                  '${controller.selectedDuration.value} minutes',
                ),
                Spacing.h(12),
                _buildCostRow(
                  'Subtotal',
                  '₹${controller.getSubtotal().toStringAsFixed(0)}',
                ),
                Spacing.h(12),
                _buildCostRow(
                  'First session discount (10%)',
                  '-₹${controller.getDiscount().toStringAsFixed(0)}',
                  isDiscount: true,
                ),
                Spacing.h(12),
                Divider(color: const Color(0xFFE0E0E0), height: 1),
                Spacing.h(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoTranslateText(
                      'Total Amount',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: const Color(0xFF5F2221),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoTranslateText(
                      '₹${controller.getTotal().toStringAsFixed(0)}',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: const Color(0xFFDFB343),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotButton(
    BookingController controller,
    String slot, {
    bool isDisabled = false,
  }) {
    return Obx(() {
      final isSelected = controller.selectedTimeSlot.value == slot;
      return GestureDetector(
        onTap: isDisabled ? null : () => controller.setTimeSlot(slot),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFDFB343).withOpacity(
                    0.3,
                  ) // Light yellow/beige when selected
                : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFDFB343)
                  : const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                Icon(Icons.check, color: const Color(0xFF5F2221), size: 16.w),
              if (isSelected) Spacing.w(4),
              Flexible(
                child: AutoTranslateText(
                  slot,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: isDisabled
                        ? const Color(0xFF999999)
                        : const Color(0xFF5F2221),
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCostRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCN.copyWith(color: const Color(0xFF5F2221)),
        ),
        AutoTranslateText(
          value,
          style: MyTextTheme.smallBCN.copyWith(
            color: isDiscount
                ? const Color(0xFF4CAF50)
                : const Color(0xFF5F2221),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(BookingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Payment Method',
          style: MyTextTheme.mediumBCB.copyWith(
            color: const Color(0xFF5F2221),
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.h(12),
        ...controller.paymentMethods.map((method) {
          return Obx(() {
            final isSelected =
                controller.selectedPaymentMethod.value ==
                method['name'] as String;
            // For Wallet, show dynamic balance
            final balanceText =
                method['name'] == 'Wallet' && controller.isLoadingWallet.value
                ? 'Loading...'
                : (method['balance'] != null
                      ? 'Balance: ${method['balance']}'
                      : null);
            return GestureDetector(
              onTap: () =>
                  controller.setPaymentMethod(method['name'] as String),
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : const Color(
                          0xFFf8f0be,
                        ), // Light yellow/cream when not selected
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(
                            0xFF42A5F5,
                          ) // Light blue border when selected (as per image)
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: method['color'] as Color,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        method['icon'] as IconData,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                    Spacing.w(12),
                    // AutoTranslateText
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            method['name'] as String,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: const Color(0xFF5F2221),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (balanceText != null) ...[
                            Spacing.h(4),
                            AutoTranslateText(
                              balanceText,
                              style: MyTextTheme.smallBCN.copyWith(
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }),
      ],
    );
  }

  Widget _buildConfirmButton(BookingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFf8f0be),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => controller.confirmBooking(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D1C21), // Dark maroon
                padding: EdgeInsets.symmetric(vertical: 16.h),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: const Color(0xFFDFB343), // Yellow checkmark
                    size: 20.w,
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    controller.getConfirmButtonText(),
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'By confirming, you agree to our Terms of Service',
              style: MyTextTheme.smallBCN
                  .copyWith(color: const Color(0xFF666666))
                  .merge(AppTypography.label),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, {double size = 70}) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'placeholder_url') {
      return Container(
        width: size.w,
        height: size.h,
        color: Colors.grey.withValues(alpha: 0.3),
        child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withValues(alpha: 0.3),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFFDFB343),
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size.w,
            height: size.h,
            color: Colors.grey.withValues(alpha: 0.3),
            child: Icon(Icons.person, size: (size / 2).w, color: Colors.grey),
          );
        },
      );
    }
  }
}
