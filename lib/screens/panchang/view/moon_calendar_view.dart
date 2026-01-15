import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/moon_calendar_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class MoonCalendarView extends BasePage<MoonCalendarController> {
  const MoonCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Date and Location Selector
            _buildDateLocationSelector(),
            
            Spacing.h(16),
            
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.moonCalendarData.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: "#DFB343".toColor(),
                    ),
                  );
                }
                
                return _buildMoonCalendarList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: "#6F221E".toColor(),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFFDFB343),
                size: 24.w,
              ),
            ),
            Spacing.w(16),
            // Title
            Expanded(
              child: AutoTranslateText(
                'Moon Calendar',
                style: MyTextTheme.largeBCB.copyWith(
                  color: const Color(0xFFDFB343),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateLocationSelector() {
    return Obx(() => Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _showDatePicker(),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: "#DFB343".toColor(),
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  DateFormat('dd MMM yyyy').format(controller.selectedDate.value),
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Location
          GestureDetector(
            onTap: () => _showLocationBottomSheet(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  color: "#DFB343".toColor(),
                  size: 18.w,
                ),
                Spacing.w(4),
                Flexible(
                  child: AutoTranslateText(
                    controller.selectedLocation.value,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor().withOpacity(0.7),
                      fontSize: 12.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildMoonCalendarList() {
    return Obx(() {
      if (controller.moonCalendarData.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No moon calendar data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.moonCalendarData.length,
        itemBuilder: (context, index) {
          final data = controller.moonCalendarData[index];
          return _buildMoonPhaseCard(data);
        },
      );
    });
  }

  Widget _buildMoonPhaseCard(Map<String, dynamic> data) {
    final dateStr = data['date']?.toString() ?? '';
    final state = data['state']?.toString() ?? '';
    final paksha = data['paksha']?.toString() ?? '';
    final luminance = data['luminance']?.toString() ?? '';
    final phase = data['phase']?.toString() ?? '';
    
    // Parse date
    DateTime? date;
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      }
    } catch (e) {
      date = null;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Day
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (date != null)
                    AutoTranslateText(
                      DateFormat('dd MMM yyyy').format(date),
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#6F221E".toColor(),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (date != null) ...[
                    Spacing.h(4),
                    AutoTranslateText(
                      DateFormat('EEEE').format(date),
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.7),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
              // Moon Icon
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: "#DFB343".toColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.nightlight_round,
                  color: "#DFB343".toColor(),
                  size: 28.w,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          // Moon State
          AutoTranslateText(
            state,
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          // Paksha
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: "#DFB343".toColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  paksha,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          // Luminance and Phase
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('Luminance', luminance),
              _buildInfoItem('Phase', phase),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCN.copyWith(
            color: "#6F221E".toColor().withOpacity(0.7),
            fontSize: 11.sp,
          ),
        ),
        Spacing.h(4),
        AutoTranslateText(
          value,
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6F221E".toColor(),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: "#DFB343".toColor(),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: "#6F221E".toColor(),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null) {
      controller.selectDate(pickedDate);
    }
  }

  void _showLocationBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: LocationBottomSheetWidget(
          onCitySelected: (city, state, country, [latitude, longitude, timezone]) {
            controller.selectCity(city, state, country);
            Get.back();
          },
          selectedCity: controller.selectedLocation.value,
          onUseCurrentLocation: () => controller.getCurrentLocation(),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}


