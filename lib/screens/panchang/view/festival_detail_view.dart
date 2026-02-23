import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/festival_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class FestivalDetailView extends BasePage<FestivalDetailController> {
  const FestivalDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: "#DFB343".toColor()),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
                const CommonHeader(
                  title: 'Festival Details',
                  subtitle: AutoTranslateText(
                    'Traditional Indian Calendar System',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0x666F221E),
                    ),
                  ),
                ),

                // Content
                _buildContent(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent() {
    final festival = controller.festival.value;
    final date = controller.date.value;

    if (festival == null) {
      return Padding(
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: AutoTranslateText(
            'Festival data not available',
            style: MyTextTheme.mediumBCN.copyWith(color: "#6F221E".toColor()),
          ),
        ),
      );
    }

    // Parse date
    DateTime? dateTime;
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        dateTime = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (e) {
      // Use current date if parsing fails
      dateTime = DateTime.now();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.h(20.05),

        // Date Card
        _buildDateCard(dateTime ?? DateTime.now()),

        Spacing.h(20.05),

        // Festival Name
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: AutoTranslateText(
            festival['name']?.toString() ?? 'Festival',
            style: MyTextTheme.veryLarge20.copyWith(
              fontWeight: FontWeight.w500,
              color: "#6B1B1A".toColor(), // 1st-maroon
            ),
          ),
        ),

        Spacing.h(20.05),

        // Muhurat Section
        if (controller.panchangData.value != null) _buildMuhuratSection(),
        Spacing.h(15),
        // Description Section
        if (festival['description'] != null)
          _buildDescriptionSection(festival['description']?.toString() ?? ''),
        Spacing.h(15),
        // Puja Vidhi Section (if available)
        if (controller.pujaVidhi.isNotEmpty) _buildPujaVidhiSection(),

        Spacing.h(20),
      ],
    );
  }

  Widget _buildDateCard(DateTime date) {
    final formattedDate = DateFormat('MMMM dd, yyyy').format(date);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: AppPaddings.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF38B3B), // rgba(243, 139, 59, 1)
            Color(0xFFDD2914), // rgba(221, 41, 20, 1)
          ],
        ),
        borderRadius: BorderRadius.circular(14.04.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15.04,
            offset: const Offset(0, 3.01),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date text
          Container(
            height: 32.09,
            alignment: Alignment.center,
            child: AutoTranslateText(
              formattedDate,
              style: MyTextTheme.largeBCB.copyWith(
                fontSize: 24.07,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.33,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Spacing.h(4.01),
          // Calendar type text
          Container(
            height: 20.06.h,
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.9,
              child: AutoTranslateText(
                'Gregorian Calendar',
                style: MyTextTheme.mediumBCN.copyWith(
                  fontSize: 14.04,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.43,
                  letterSpacing: -0.15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuhuratSection() {
    final panchangData = controller.panchangData.value;
    if (panchangData == null) return const SizedBox.shrink();

    final tithi = panchangData['tithi'] as Map<String, dynamic>?;
    final location = controller.location.value;
    final festivalName = controller.festival.value?['name'] ?? 'Festival';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Color.fromRGBO(227, 179, 65, 0.2), // stroke_AWQI7Y
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          AutoTranslateText(
            '$festivalName Muhurat For $location',
            style: MyTextTheme.largeBCB.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: "#6B1B1A".toColor(), // 1st-maroon
              height: 1.5,
              letterSpacing: -0.44,
            ),
          ),
          Spacing.h(11.99),
          // List items
          if (tithi != null) ...[
            _buildMuhuratItem(
              'Festival Tithi Begins at ${_formatDateTime(tithi['start']?.toString())}',
            ),
            Spacing.h(7.99),
            _buildMuhuratItem(
              'Festival Tithi Ends at ${_formatDateTime(tithi['end']?.toString())}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMuhuratItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkmark
        Container(
          width: 11.98.w,
          height: 20.h,
          alignment: Alignment.topCenter,
          child: AutoTranslateText(
            '✓',
            style: MyTextTheme.mediumBCN.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFE3B341), // 2nd-gold
              height: 1.43,
              letterSpacing: -0.15,
            ),
          ),
        ),
        Spacing.w(7.99),
        // Text
        Expanded(
          child: AutoTranslateText(
            text,
            style: MyTextTheme.mediumBCN.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(107, 27, 26, 0.7), // fill_SNGR5O
              height: 1.67,
              letterSpacing: -0.15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(String description) {
    final festivalName = controller.festival.value?['name'] ?? 'Festival';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Color.fromRGBO(227, 179, 65, 0.2), // stroke_AWQI7Y
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          AutoTranslateText(
            festivalName,
            style: MyTextTheme.largeBCB.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: "#6B1B1A".toColor(), // 1st-maroon
              height: 1.5,
              letterSpacing: -0.44,
            ),
          ),
          Spacing.h(11.99),
          // Description with checkmark
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkmark
              Container(
                width: 11.98.w,
                height: 20.h,
                alignment: Alignment.topCenter,
                child: AutoTranslateText(
                  '✓',
                  style: MyTextTheme.mediumBCN.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFE3B341), // 2nd-gold
                    height: 1.43,
                    letterSpacing: -0.15,
                  ),
                ),
              ),
              Spacing.w(7.99),
              // Description text
              Expanded(
                child: AutoTranslateText(
                  description,
                  style: MyTextTheme.mediumBCN.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(107, 27, 26, 0.7), // fill_SNGR5O
                    height: 1.67,
                    letterSpacing: -0.15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPujaVidhiSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
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
          AutoTranslateText(
            '${controller.festival.value?['name']} Pooja Vidhi',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          AutoTranslateText(
            'By fasting and worshipping the Gods and Goddesses on this festival, a person is blessed with happiness and prosperity. Following are the Vrat rituals that one should perform while fasting on ${controller.festival.value?['name']}:',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor(),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          Spacing.h(16),
          ...controller.pujaVidhi.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    '• ',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: "#6F221E".toColor(),
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      item,
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: "#6F221E".toColor(),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '--';
    try {
      // Parse format like "Tue, Dec 16, 2025 11:32:27 PM"
      final dateTime = DateFormat(
        'EEE, MMM dd, yyyy hh:mm:ss a',
      ).parse(dateTimeStr);
      return DateFormat('hh:mm:ss a on MMMM dd, yyyy').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }
}
