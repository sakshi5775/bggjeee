import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/jain_calendar_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class JainCalendarView extends BasePage<JainCalendarController> {
  const JainCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Tabs Section
            _buildTabsSection(),
            
            // Content
            Expanded(
              child: Obx(() => _buildTabContent()),
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
                'Jain Calendar',
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

  Widget _buildTabsSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(() => Row(
        children: controller.tabs.map((tab) {
          final tabId = tab['id'] as String;
          final title = tab['title'] as String;
          final isSelected = controller.selectedTab.value == tabId;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectTab(tabId),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? "#DFB343".toColor() 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  title,
                  textAlign: TextAlign.center,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: isSelected 
                        ? Colors.white 
                        : "#6F221E".toColor(),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  Widget _buildTabContent() {
    if (controller.selectedTab.value == 'navkarshi') {
      return _buildNavkarshiContent();
    } else {
      return _buildKalyanakContent();
    }
  }

  Widget _buildNavkarshiContent() {
    return Obx(() {
      if (controller.isLoadingNavkarshi.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#DFB343".toColor(),
          ),
        );
      }

      final data = controller.navkarshiData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location and Date Info
              Container(
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
                  children: [
                    Icon(
                      Icons.location_on,
                      color: "#DFB343".toColor(),
                      size: 20.w,
                    ),
                    Spacing.w(8),
                    Expanded(
                      child: AutoTranslateText(
                        controller.selectedLocation.value,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#6F221E".toColor(),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      DateFormat('dd MMM yyyy').format(controller.selectedDate.value),
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.7),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h(16),
              // Navkarshi Times
              AutoTranslateText(
                'Navkarshi Timings',
                style: MyTextTheme.largeBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.h(12),
              // Times Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 2.8,
                children: [
                  _buildTimeCard('Sunrise', data['Sunrise'] ?? '--'),
                  _buildTimeCard('Navkarshi', data['Navkarshi'] ?? '--'),
                  _buildTimeCard('Porshi', data['Porshi'] ?? '--'),
                  _buildTimeCard('SadhPorshi', data['SadhPorshi'] ?? '--'),
                  _buildTimeCard('Purimaddha', data['Purimaddha'] ?? '--'),
                  _buildTimeCard('Avaddha', data['Avaddha'] ?? '--'),
                  _buildTimeCard('Sunset', data['Sunset'] ?? '--'),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTimeCard(String label, String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#DFB343".toColor().withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
              fontSize: 10.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacing.h(3),
          Flexible(
            child: AutoTranslateText(
              time,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKalyanakContent() {
    return Obx(() {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Selector (Digambar/Shvetambar)
              AutoTranslateText(
                'Select Section',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.h(12),
              Row(
                children: [
                  Expanded(
                    child: _buildSectionButton('Digambar', 'digambar'),
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: _buildSectionButton('Shvetambar', 'shvetambar'),
                  ),
                ],
              ),
              Spacing.h(20),
              // Month and Year Selector
              Row(
                children: [
                  Expanded(
                    child: _buildMonthYearSelector(),
                  ),
                ],
              ),
              Spacing.h(20),
              // Kalyanak Events List
              if (controller.isLoadingKalyanak.value)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.h),
                    child: CircularProgressIndicator(
                      color: "#DFB343".toColor(),
                    ),
                  ),
                )
              else if (controller.kalyanakData.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.h),
                    child: AutoTranslateText(
                      'No Kalyanak events found for this month',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.7),
                      ),
                    ),
                  ),
                )
              else
                ...controller.kalyanakData.map((event) => _buildKalyanakCard(event)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSectionButton(String title, String section) {
    return Obx(() {
      final isSelected = controller.selectedSection.value == section;
      return GestureDetector(
        onTap: () => controller.selectSection(section),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected 
                ? "#DFB343".toColor() 
                : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected 
                  ? "#DFB343".toColor() 
                  : "#DFB343".toColor().withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AutoTranslateText(
            title,
            textAlign: TextAlign.center,
            style: MyTextTheme.mediumBCB.copyWith(
              color: isSelected 
                  ? Colors.white 
                  : "#6F221E".toColor(),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMonthYearSelector() {
    return Obx(() => Container(
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
            onTap: () => _showMonthYearPicker(),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: "#DFB343".toColor(),
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  '${_getMonthName(controller.selectedMonth.value)} ${controller.selectedYear.value}',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  String _getMonthName(int month) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  void _showMonthYearPicker() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: AutoTranslateText(
          'Select Month & Year',
          style: MyTextTheme.largeBCB.copyWith(
            color: "#6F221E".toColor(),
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Year Picker
              AutoTranslateText(
                'Year',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                ),
              ),
              Spacing.h(8),
              SizedBox(
                height: 200.h,
                child: YearPicker(
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  selectedDate: DateTime(controller.selectedYear.value),
                  onChanged: (date) {
                    controller.selectYear(date.year);
                  },
                ),
              ),
              Spacing.h(16),
              // Month Picker
              AutoTranslateText(
                'Month',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                ),
              ),
              Spacing.h(8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: List.generate(12, (index) {
                  final month = index + 1;
                  final isSelected = controller.selectedMonth.value == month;
                  return GestureDetector(
                    onTap: () {
                      controller.selectMonth(month);
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.all(4.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? "#DFB343".toColor() 
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected 
                              ? "#DFB343".toColor() 
                              : "#DFB343".toColor().withOpacity(0.3),
                        ),
                      ),
                      child: AutoTranslateText(
                        _getMonthName(month).substring(0, 3),
                        textAlign: TextAlign.center,
                        style: MyTextTheme.smallBCB.copyWith(
                          color: isSelected 
                              ? Colors.white 
                              : "#6F221E".toColor(),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKalyanakCard(Map<String, dynamic> event) {
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
          // Date
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: "#DFB343".toColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  event['date'] ?? '--',
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
          // Tithi
          if (event['tithi'] != null)
            AutoTranslateText(
              'Tithi: ${event['tithi']}',
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontSize: 12.sp,
              ),
            ),
          Spacing.h(8),
          // Tirthankar
          AutoTranslateText(
            event['tirthankar'] ?? '--',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(4),
          // Kalyanak
          AutoTranslateText(
            event['kalyanak'] ?? '--',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#DFB343".toColor(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
