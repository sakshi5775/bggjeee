import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/daily_panchang_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/daily_panchang_button_widget.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/daily_panchang_form_field_widget.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/daily_panchang_header_widget.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/daily_panchang_language_field_widget.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

import '../../../app_manager/my_text_field.dart';

class DailyPanchangView extends BasePage<DailyPanchangController> {
  const DailyPanchangView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#fbe3a7".toColor(),
            "#FFFCF3".toColor(),
            "#fffaee".toColor(),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.8, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header (Dark Maroon Background)
            DailyPanchangHeaderWidget(
              controller: controller,
              onLocationTap: () => _showLocationBottomSheet(),
            ),

            // Form Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.h(20),
                    _buildFormSection(),

                    // Panchang Data Display (White Card)
                    Obx(
                      () => controller.panchangData.value != null
                          ? _buildPanchangData()
                          : const SizedBox.shrink(),
                    ),

                    // Muhurta Timings and Additional Details (Outside Card)
                    Obx(
                      () => controller.panchangData.value != null
                          ? _buildMuhurtaAndAdditionalDetails()
                          : const SizedBox.shrink(),
                    ),
                    Spacing.h(15.33),
                    // View Monthly Calendar Button
                    Obx(
                      () => controller.panchangData.value != null
                          ? _buildViewMonthlyCalendarButton()
                          : const SizedBox.shrink(),
                    ),
                    Spacing.h(15.33),
                    // Have Questions Banner
                    Obx(
                      () => controller.panchangData.value != null
                          ? _buildHaveQuestionsBanner()
                          : const SizedBox.shrink(),
                    ),

                    Spacing.h(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          AutoTranslateText(
            'Enter Details',
            style: MyTextTheme.largeBCB.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: "#8B1925".toColor(), // 1st-maroon
            ),
          ),
          Spacing.h(20),
          // Date field
          DailyPanchangFormFieldWidget(
            label: 'Date (dd/mm/yyyy)',
            hintText: 'DD/MM/YYYY',
            controller: controller.dateController,
            suffixIcon: Icons.calendar_today,
            readOnly: true,
            onTap: controller.selectDate,
          ),
          Spacing.h(15.33),
          // Time field
          DailyPanchangFormFieldWidget(
            label: 'Time(HH:mm)',
            hintText: 'HH:MM',
            controller: controller.timeController,
            suffixIcon: Icons.access_time,
            readOnly: true,
            onTap: controller.selectTime,
          ),
          Spacing.h(15.33),
          // Latitude and Longitude row
          Container(
            padding: AppPaddings.all(16),
            decoration: BoxDecoration(
              color: "#FFFFFF".toColor(),
              borderRadius: BorderRadius.circular(14.04.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    headerText: 'Latitude',
                    controller: controller.latitudeController,
                    hintText: '00.000000',
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                Spacing.w(8.02),
                Expanded(
                  child: MyTextField(
                    headerText: 'Longitude',
                    hintText: '00.000000',
                    controller: controller.longitudeController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(15.33),
          // Get Current Location button
          Obx(
            () => DailyPanchangButtonWidget(
              text: controller.isFetchingLocation.value
                  ? 'Getting Location...'
                  : 'Get Current Location',
              icon: Icons.location_on_outlined,
              onPressed: controller.isFetchingLocation.value
                  ? null
                  : controller.getCurrentLocation,
              isLoading: controller.isFetchingLocation.value,
              isPrimary: false, // White with orange border
            ),
          ),
          Spacing.h(15.33),
          // Timezone and Language row
          Container(
            padding: AppPaddings.all(16),
            decoration: BoxDecoration(
              color: "#FFFFFF".toColor(),
              borderRadius: BorderRadius.circular(14.04.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    headerText: 'Timezone',
                    controller: controller.timezoneController,
                    hintText: '0.0',
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                Spacing.w(8.02),
                Expanded(
                  child: DailyPanchangLanguageFieldWidget(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: DailyPanchangFormFieldWidget(
          //         label: 'Timezone',
          //         hintText: '0.0',
          //         controller: controller.timezoneController,
          //         suffixIcon: Icons.access_time,
          //         keyboardType: TextInputType.numberWithOptions(decimal: true),
          //       ),
          //     ),
          //     Spacing.w(8.02),
          //     Expanded(
          //       child: DailyPanchangLanguageFieldWidget(controller: controller),
          //     ),
          //   ],
          // ),
          Spacing.h(15.33),
          // Get Panchang button
          Obx(
            () => DailyPanchangButtonWidget(
              text: ' Get Panchang',
              onPressed: controller.isLoading.value
                  ? null
                  : controller.fetchPanchang,
              isLoading: controller.isLoading.value,
              isPrimary: true, // Orange gradient
            ),
          ),
          Spacing.h(20),
        ],
      ),
    );
  }

  Widget _buildPanchangData() {
    final data = controller.panchangData.value;
    if (data == null) return const SizedBox.shrink();

    final advancedDetails = data['advanced_details'] as Map<String, dynamic>?;
    final masa = advancedDetails?['masa'] as Map<String, dynamic>?;
    final years = advancedDetails?['years'] as Map<String, dynamic>?;
    final tithi = data['tithi'] as Map<String, dynamic>?;
    final nakshatra = data['nakshatra'] as Map<String, dynamic>?;
    final karana = data['karana'] as Map<String, dynamic>?;
    final yoga = data['yoga'] as Map<String, dynamic>?;

    // Format date
    final dateStr = controller.dateController.text;
    final formattedDate = _formatDateForDisplay(dateStr);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h(20),
          // Single Main Card with all data
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: "#FFFFFF".toColor(),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: Color.fromRGBO(227, 179, 65, 0.2),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Location Header
                _buildDateLocationHeader(formattedDate),
                Spacing.h(20),

                // Celestial Times Section
                _buildCelestialTimes(advancedDetails),
                Spacing.h(20),

                // Tithi, Nakshatra, Yoga, Karana Section
                _buildAstrologicalDetails(tithi, nakshatra, yoga, karana, data),
                Spacing.h(20),

                // Vaar Details Section
                _buildVaarDetails(data, masa, years, advancedDetails),
              ],
            ),
          ),
          Spacing.h(20),
        ],
      ),
    );
  }

  Widget _buildMuhurtaAndAdditionalDetails() {
    final data = controller.panchangData.value;
    if (data == null) return const SizedBox.shrink();

    final advancedDetails = data['advanced_details'] as Map<String, dynamic>?;
    final masa = advancedDetails?['masa'] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Muhurta Timings
        _buildMuhurtaTimings(advancedDetails, data),
        Spacing.h(15),
        // Additional Details
        _buildAdditionalDetails(data, advancedDetails, masa),
      ],
    );
  }

  Widget _buildViewMonthlyCalendarButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.monthlyCalendar),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6B1B1A), Color(0xFF8B1925)],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month,
                color: const Color(0xFFDFB343),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'View Monthly Calendar',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFFDFB343),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHaveQuestionsBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF38B3B), Color(0xFFDD2914)],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                Spacing.w(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Have Questions?',
                        style: MyTextTheme.largeBCB.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        'Get personalized guidance from expert astrologers',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.h(16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.astrologyServices);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: AutoTranslateText(
                  'Ask an Astrologer',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Color(0xFFDD2914),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildDateLocationHeader(String formattedDate) {
    final data = controller.panchangData.value;
    final apiDate = data?['date']?.toString() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          formattedDate,
          style: MyTextTheme.largeBCB.copyWith(
            color: "#6B1B1A".toColor(),
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.44,
          ),
        ),
        if (apiDate.isNotEmpty) ...[
          Spacing.h(4),
          AutoTranslateText(
            'Date: $apiDate',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6B1B1A".toColor().withOpacity(0.6),
              fontSize: 12.sp,
            ),
          ),
        ],
        Spacing.h(8),
        Row(
          children: [
            Icon(Icons.location_on, size: 16.w, color: "#DFB343".toColor()),
            Spacing.w(4),
            Expanded(
              child: AutoTranslateText(
                'Lat: ${controller.latitudeController.text}, Lon: ${controller.longitudeController.text}',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6B1B1A".toColor().withOpacity(0.7),
                  fontSize: 12.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCelestialTimes(Map<String, dynamic>? advancedDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Celestial Times',
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6B1B1A".toColor(),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: -0.44,
          ),
        ),
        Spacing.h(12),
        Row(
          children: [
            Expanded(
              child: _buildTimeItem(
                Icons.wb_sunny,
                'Sunrise',
                advancedDetails?['sun_rise']?.toString() ?? '--',
              ),
            ),
            Spacing.w(12),
            Expanded(
              child: _buildTimeItem(
                Icons.wb_twilight,
                'Sunset',
                advancedDetails?['sun_set']?.toString() ?? '--',
              ),
            ),
          ],
        ),
        Spacing.h(12),
        Row(
          children: [
            Expanded(
              child: _buildTimeItem(
                Icons.nightlight_round,
                'Moonrise',
                advancedDetails?['moon_rise']?.toString() ?? '--',
              ),
            ),
            Spacing.w(12),
            Expanded(
              child: _buildTimeItem(
                Icons.brightness_2,
                'Moonset',
                advancedDetails?['moon_set']?.toString() ?? '--',
              ),
            ),
          ],
        ),
        if (advancedDetails?['solar_noon'] != null) ...[
          Spacing.h(12),
          _buildTimeItem(
            Icons.access_time,
            'Solar Noon',
            advancedDetails?['solar_noon']?.toString() ?? '--',
          ),
        ],
      ],
    );
  }

  Widget _buildTimeItem(IconData icon, String label, String value) {
    // Handle NaN values in time strings
    String displayValue = value;
    if (value.contains('NaN') || value == '--' || value.isEmpty) {
      displayValue = 'Not Available';
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: "#FAF6F0".toColor(),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          // Icon(icon, size: 20.w, color: "#DFB343".toColor()),
          // Spacing.w(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  label,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6B1B1A".toColor().withOpacity(0.7),
                    fontSize: 11.sp,
                  ),
                ),
                Spacing.h(2),
                AutoTranslateText(
                  displayValue,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: "#6B1B1A".toColor(),

                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologicalDetails(
    Map<String, dynamic>? tithi,
    Map<String, dynamic>? nakshatra,
    Map<String, dynamic>? yoga,
    Map<String, dynamic>? karana,
    Map<String, dynamic> data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tithi
        _buildAstroItem(
          Icons.access_time,
          'Tithi',
          tithi?['name']?.toString() ?? '--',
          '${_formatDateTime(tithi?['start'])} → ${_formatDateTime(tithi?['end'])}',
          details: {
            'Type': tithi?['type']?.toString(),
            'Number': tithi?['number']?.toString(),
            'Diety': tithi?['diety']?.toString(),
            'Next Tithi': tithi?['next_tithi']?.toString(),
            'Meaning': tithi?['meaning']?.toString(),
            'Special': tithi?['special']?.toString(),
          },
        ),
        Spacing.h(16),
        // Nakshatra
        _buildAstroItem(
          Icons.star,
          'Nakshatra',
          nakshatra?['name']?.toString() ?? '--',
          '${_formatDateTime(nakshatra?['start'])} → ${_formatDateTime(nakshatra?['end'])}',
          details: {
            'Lord': nakshatra?['lord']?.toString(),
            'Diety': nakshatra?['diety']?.toString(),
            'Number': nakshatra?['number']?.toString(),
            'Pada': nakshatra?['pada']?.toString(),
            'Next Nakshatra': nakshatra?['next_nakshatra']?.toString(),
            'Meaning': nakshatra?['meaning']?.toString(),
            'Special': nakshatra?['special']?.toString(),
            'Summary': nakshatra?['summary']?.toString(),
            'Words': nakshatra?['words']?.toString(),
          },
        ),
        Spacing.h(16),
        // Yoga
        _buildAstroItem(
          Icons.my_location,
          'Yoga',
          yoga?['name']?.toString() ?? '--',
          '${_formatDateTime(yoga?['start'])} → ${_formatDateTime(yoga?['end'])}',
          details: {
            'Number': yoga?['number']?.toString(),
            'Next Yoga': yoga?['next_yoga']?.toString(),
            'Meaning': yoga?['meaning']?.toString(),
            'Special': yoga?['special']?.toString(),
          },
        ),
        Spacing.h(16),
        // Karana
        _buildAstroItem(
          Icons.grid_view,
          'Karana',
          karana?['name']?.toString() ?? '--',
          '${_formatDateTime(karana?['start'])} → ${_formatDateTime(karana?['end'])}',
          details: {
            'Type': karana?['type']?.toString(),
            'Lord': karana?['lord']?.toString(),
            'Diety': karana?['diety']?.toString(),
            'Number': karana?['number']?.toString(),
            'Next Karana': karana?['next_karana']?.toString(),
            'Special': karana?['special']?.toString(),
          },
        ),
      ],
    );
  }

  Widget _buildAstroItem(
    IconData icon,
    String label,
    String value,
    String timeRange, {
    Map<String, String?>? details,
  }) {
    return _ExpandableAstroItem(
      icon: icon,
      label: label,
      value: value,
      timeRange: timeRange,
      details: details ?? {},
    );
  }

  Widget _buildVaarDetails(
    Map<String, dynamic> data,
    Map<String, dynamic>? masa,
    Map<String, dynamic>? years,
    Map<String, dynamic>? advancedDetails,
  ) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: "#FAF6F0".toColor(),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.dark_mode_outlined,
                size: 20.w,
                color: "#DFB343".toColor(),
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Vaar Details',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6B1B1A".toColor(),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: -0.44,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          _buildVaarRow(
            'Day of Week',
            data['day']?['name']?.toString() ?? '--',
          ),
          if (masa?['paksha'] != null) ...[
            Spacing.h(12),
            Row(
              children: [
                Expanded(
                  child: _buildVaarRow(
                    'Paksha',
                    masa?['paksha']?.toString() ?? '--',
                  ),
                ),
                Spacing.w(8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: AutoTranslateText(
                    masa?['paksha']?.toString() ?? '',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          // Masa fields
          if (masa?['amanta_name'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Lunar Month (Amanta)',
              masa?['amanta_name']?.toString() ?? '--',
            ),
          ],
          if (masa?['purnimanta_name'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Lunar Month (Purnimanta)',
              masa?['purnimanta_name']?.toString() ?? '--',
            ),
          ],
          if (masa?['alternate_amanta_name'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Alternate Month Name',
              masa?['alternate_amanta_name']?.toString() ?? '--',
            ),
          ],
          if (masa?['adhik_maasa'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Adhik Maasa',
              masa?['adhik_maasa']?.toString() ?? '--',
            ),
          ],
          if (masa?['tamil_month'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Tamil Month',
              masa?['tamil_month']?.toString() ?? '--',
            ),
          ],
          if (masa?['tamil_month_num'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Tamil Month Number',
              masa?['tamil_month_num']?.toString() ?? '--',
            ),
          ],
          if (masa?['tamil_day'] != null) ...[
            Spacing.h(12),
            _buildVaarRow('Tamil Day', masa?['tamil_day']?.toString() ?? '--'),
          ],
          // Years fields
          if (years?['vikram_samvaat'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Vikram Samvat',
              years?['vikram_samvaat']?.toString() ?? '--',
            ),
          ],
          if (years?['vikram_samvaat_name'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Vikram Samvat Name',
              years?['vikram_samvaat_name']?.toString() ?? '--',
            ),
          ],
          if (years?['vikram_samvaat_number'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Vikram Samvat Number',
              years?['vikram_samvaat_number']?.toString() ?? '--',
            ),
          ],
          if (years?['saka'] != null) ...[
            Spacing.h(12),
            _buildVaarRow('Shaka Samvat', years?['saka']?.toString() ?? '--'),
          ],
          if (years?['saka_samvaat_name'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Shaka Samvat Name',
              years?['saka_samvaat_name']?.toString() ?? '--',
            ),
          ],
          if (years?['saka_samvaat_number'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Shaka Samvat Number',
              years?['saka_samvaat_number']?.toString() ?? '--',
            ),
          ],
          if (years?['kali'] != null) ...[
            Spacing.h(12),
            _buildVaarRow('Kali Yuga', years?['kali']?.toString() ?? '--'),
          ],
          if (years?['kali_samvaat_name'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Kali Samvat Name',
              years?['kali_samvaat_name']?.toString() ?? '--',
            ),
          ],
          if (years?['kali_samvaat_number'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Kali Samvat Number',
              years?['kali_samvaat_number']?.toString() ?? '--',
            ),
          ],
          // Ritu and Ayana
          if (masa?['ritu'] != null) ...[
            Spacing.h(12),
            _buildVaarRow('Ritu', masa?['ritu']?.toString() ?? '--'),
          ],
          if (masa?['ritu_tamil'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Ritu (Tamil)',
              masa?['ritu_tamil']?.toString() ?? '--',
            ),
          ],
          if (masa?['ayana'] != null) ...[
            Spacing.h(12),
            _buildVaarRow('Ayana', masa?['ayana']?.toString() ?? '--'),
          ],
          // Vaara from advanced_details
          if (advancedDetails?['vaara'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Vaara',
              advancedDetails?['vaara']?.toString() ?? '--',
            ),
          ],
          // Ayanamsa and Rasi
          if (data['ayanamsa']?['name'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Ayanamsa',
              data['ayanamsa']?['name']?.toString() ?? '--',
            ),
          ],
          if (data['rasi']?['name'] != null) ...[
            Spacing.h(12),
            _buildVaarRow(
              'Moon Sign',
              data['rasi']?['name']?.toString() ?? '--',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVaarRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6B1B1A".toColor().withOpacity(0.7),
              fontSize: 13.sp,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacing.w(8),
        Flexible(
          flex: 3,
          child: AutoTranslateText(
            value,
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6B1B1A".toColor(),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMuhurtaTimings(
    Map<String, dynamic>? advancedDetails,
    Map<String, dynamic> data,
  ) {
    // Check if any inauspicious timing has valid data (not empty and not just NaN)
    final hasRahukaal =
        data['rahukaal'] != null &&
        data['rahukaal'].toString().isNotEmpty &&
        !data['rahukaal'].toString().contains('NaN');
    final hasGulika =
        data['gulika'] != null &&
        data['gulika'].toString().isNotEmpty &&
        !data['gulika'].toString().contains('NaN');
    final hasYamakanta =
        data['yamakanta'] != null &&
        data['yamakanta'].toString().isNotEmpty &&
        !data['yamakanta'].toString().contains('NaN');
    final hasBhadrakaal =
        data['bhadrakaal'] != null && data['bhadrakaal'].toString().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card 1: Abhijit Muhurta (Green Card)
          if (advancedDetails?['abhijitMuhurta'] != null) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18.w, color: Colors.green),
                  Spacing.w(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'Abhijit Muhurta',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: "#6B1B1A".toColor(),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacing.h(2),
                        AutoTranslateText(
                          _formatMuhurtaTime(
                            advancedDetails?['abhijitMuhurta']?['start']
                                    ?.toString() ??
                                '',
                            advancedDetails?['abhijitMuhurta']?['end']
                                    ?.toString() ??
                                '',
                          ),
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6B1B1A".toColor(),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(12),
          ],
          // Card 2: Inauspicious Timings (Red Card)
          if (hasRahukaal || hasGulika || hasYamakanta || hasBhadrakaal) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.red, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, size: 18.w, color: Colors.red),
                      Spacing.w(8),
                      AutoTranslateText(
                        'Inauspicious Timings',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: "#6B1B1A".toColor(),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (hasRahukaal) ...[
                    Spacing.h(8),
                    _buildInauspiciousTimingRow(
                      'Rahu Kaal',
                      data['rahukaal']?.toString() ?? '',
                    ),
                  ],
                  if (hasGulika) ...[
                    Spacing.h(8),
                    _buildInauspiciousTimingRow(
                      'Gulika Kaal',
                      data['gulika']?.toString() ?? '',
                    ),
                  ],
                  if (hasYamakanta) ...[
                    Spacing.h(8),
                    _buildInauspiciousTimingRow(
                      'Yamakanta',
                      data['yamakanta']?.toString() ?? '',
                    ),
                  ],
                  if (hasBhadrakaal) ...[
                    Spacing.h(8),
                    _buildInauspiciousTimingRow(
                      'Bhadrakaal',
                      data['bhadrakaal']?.toString() ?? '',
                    ),
                  ],
                ],
              ),
            ),
            Spacing.h(12),
          ],
          // Card 3: Disha Shoola (Beige/White Card)
          if (advancedDetails?['disha_shool'] != null) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: "#FF9802".toColor(), width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.compass_calibration,
                    size: 18.w,
                    color: "#DFB343".toColor(),
                  ),
                  Spacing.w(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          'Disha Shoola',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: "#6B1B1A".toColor(),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacing.h(2),
                        AutoTranslateText(
                          advancedDetails?['disha_shool']?.toString() ?? '--',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6B1B1A".toColor(),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInauspiciousTimingRow(String label, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6B1B1A".toColor(),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacing.w(8),
        Flexible(
          flex: 3,
          child: AutoTranslateText(
            time,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6B1B1A".toColor(),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalDetails(
    Map<String, dynamic> data,
    Map<String, dynamic>? advancedDetails,
    Map<String, dynamic>? masa,
  ) {
    final hasAdditionalData =
        advancedDetails?['moon_yogini_nivas'] != null ||
        advancedDetails?['ahargana'] != null ||
        masa?['moon_phase'] != null ||
        advancedDetails?['next_full_moon'] != null ||
        advancedDetails?['next_new_moon'] != null ||
        (data['sankranti'] != null &&
            data['sankranti'].toString().isNotEmpty &&
            (data['sankranti'] as Map).isNotEmpty);

    if (!hasAdditionalData) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Additional Details',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6B1B1A".toColor(),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
              letterSpacing: -0.44,
            ),
          ),
          Spacing.h(12),
          Container(
            padding: EdgeInsets.all(12.w),

            child: Column(
              children: [
                if (masa?['moon_phase'] != null)
                  _buildVaarRow(
                    'Moon Phase',
                    masa?['moon_phase']?.toString() ?? '--',
                  ),
                if (advancedDetails?['moon_yogini_nivas'] != null) ...[
                  Spacing.h(12),
                  _buildVaarRow(
                    'Moon Yogini Nivas',
                    advancedDetails?['moon_yogini_nivas']?.toString() ?? '--',
                  ),
                ],
                if (advancedDetails?['ahargana'] != null) ...[
                  Spacing.h(12),
                  _buildVaarRow(
                    'Ahargana',
                    advancedDetails?['ahargana']?.toString() ?? '--',
                  ),
                ],
                if (advancedDetails?['next_full_moon'] != null) ...[
                  Spacing.h(12),
                  _buildVaarRow(
                    'Next Full Moon',
                    advancedDetails?['next_full_moon']?.toString() ?? '--',
                  ),
                ],
                if (advancedDetails?['next_new_moon'] != null) ...[
                  Spacing.h(12),
                  _buildVaarRow(
                    'Next New Moon',
                    advancedDetails?['next_new_moon']?.toString() ?? '--',
                  ),
                ],
                // Sankranti
                if (data['sankranti'] != null &&
                    data['sankranti'].toString().isNotEmpty) ...[
                  Spacing.h(12),
                  _buildSankrantiSection(
                    data['sankranti'] as Map<String, dynamic>?,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSankrantiSection(Map<String, dynamic>? sankranti) {
    if (sankranti == null || sankranti.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Sankranti',
          style: MyTextTheme.mediumBCB.copyWith(
            color: "#6B1B1A".toColor(),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacing.h(8),
        ...sankranti.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildVaarRow(
              entry.key
                  .replaceAll('_', ' ')
                  .split(' ')
                  .map(
                    (word) => word.isEmpty
                        ? ''
                        : word[0].toUpperCase() + word.substring(1),
                  )
                  .join(' '),
              entry.value?.toString() ?? '--',
            ),
          );
        }).toList(),
      ],
    );
  }

  String _formatDateForDisplay(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = parts[0];
        final month = int.parse(parts[1]);
        final year = parts[2];
        final monthNames = [
          '',
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        final dayNames = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ];
        final date = DateTime(int.parse(year), month, int.parse(day));
        final dayName = dayNames[date.weekday - 1];
        return '$dayName, $day ${monthNames[month]} $year';
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  String? _formatDateTime(dynamic dateTime) {
    if (dateTime == null) return null;
    try {
      // Try to parse the date string
      final dateStr = dateTime.toString();
      // Format: "Tue, Dec 16, 2025 11:32:27 PM"
      // Extract time part
      if (dateStr.contains('PM') || dateStr.contains('AM')) {
        final parts = dateStr.split(' ');
        if (parts.length >= 2) {
          return '${parts[parts.length - 2]} ${parts[parts.length - 1]}';
        }
      }
      return dateStr;
    } catch (e) {
      return dateTime.toString();
    }
  }

  String _formatMuhurtaTime(String start, String end) {
    final startTime = start.contains('NaN') ? 'Not Available' : start;
    final endTime = end.contains('NaN') ? 'Not Available' : end;

    if (startTime == 'Not Available' && endTime == 'Not Available') {
      return 'Not Available';
    }
    return '$startTime - $endTime';
  }
}

// LocationBottomSheetWidget is now in lib/screens/panchang/widgets/location_bottom_sheet_widget.dart

class _ExpandableAstroItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String timeRange;
  final Map<String, String?> details;

  const _ExpandableAstroItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.timeRange,
    required this.details,
  });

  @override
  State<_ExpandableAstroItem> createState() => _ExpandableAstroItemState();
}

class _ExpandableAstroItemState extends State<_ExpandableAstroItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: "#DFB343".toColor().withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#DFB343".toColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_border_outlined,
                      size: 20.w,
                      color: "#FFFFFF".toColor(),
                    ),
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoTranslateText(
                          widget.label,
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6B1B1A".toColor().withOpacity(0.7),
                            fontSize: 12.sp,
                          ),
                        ),
                        Spacing.h(4),
                        AutoTranslateText(
                          widget.value,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#6B1B1A".toColor(),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.timeRange.isNotEmpty) ...[
                          Spacing.h(2),
                          AutoTranslateText(
                            widget.timeRange,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: "#6B1B1A".toColor().withOpacity(0.6),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: "#6B1B1A".toColor(),
                    size: 24.w,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded && widget.details.isNotEmpty)
            Container(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.details.entries
                    .where(
                      (entry) => entry.value != null && entry.value!.isNotEmpty,
                    )
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: AutoTranslateText(
                                '${entry.key}:',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: "#6B1B1A".toColor().withOpacity(0.7),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: AutoTranslateText(
                                entry.value!,
                                textAlign: TextAlign.right,
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: "#6B1B1A".toColor(),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
