import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RudrakshSuggestionWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const RudrakshSuggestionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRudrakshSuggestion.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Rudraksh Suggestion...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.rudrakshSuggestionData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Rudraksh Suggestion data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      final rudraksh = (data['rudraksh'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final name = (data['name'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final qualities = (data['qualities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final howToWear = data['how_to_wear']?.toString() ?? '';
      final timeToWear = data['time_to_wear']?.toString() ?? '';
      final mantra = (data['mantra'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      final personalizedResponse = data['personalized_response']?.toString() ?? '';
      final purification = data['purification']?.toString() ?? '';

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(20),
            if (rudraksh.isNotEmpty) _buildRudrakshListCard(rudraksh, name, qualities, mantra),
            Spacing.h(20),
            if (howToWear.isNotEmpty || timeToWear.isNotEmpty) _buildWearingInfoCard(howToWear, timeToWear),
            Spacing.h(20),
            if (personalizedResponse.isNotEmpty) _buildPersonalizedCard(personalizedResponse),
            Spacing.h(20),
            if (purification.isNotEmpty) _buildPurificationCard(purification),
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#6F221E".toColor(),
            "#6F221E".toColor().withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: "#6F221E".toColor().withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.self_improvement_rounded,
              color: Colors.white,
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Rudraksh Suggestion',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: Colors.white,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Spiritual beads recommendation',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRudrakshListCard(List<String> rudraksh, List<String> name, List<String> qualities, List<String> mantra) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Recommended Rudraksh',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          ...List.generate(rudraksh.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: "#6F221E".toColor().withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: "#6F221E".toColor().withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index < rudraksh.length)
                      AutoTranslateText(
                        rudraksh[index],
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#6F221E".toColor(),
                        ),
                      ),
                    if (index < name.length) ...[
                      Spacing.h(8),
                      AutoTranslateText(
                        name[index],
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor().withOpacity(0.8),
                        ),
                      ),
                    ],
                    if (index < qualities.length) ...[
                      Spacing.h(8),
                      AutoTranslateText(
                        qualities[index],
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor().withOpacity(0.7),
                        ),
                      ),
                    ],
                    if (index < mantra.length) ...[
                      Spacing.h(8),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: "#DFB343".toColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AutoTranslateText(
                          mantra[index],
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6F221E".toColor(),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWearingInfoCard(String howToWear, String timeToWear) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Wearing Information',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          if (howToWear.isNotEmpty) ...[
            _buildInfoRow('How to Wear', howToWear),
            if (timeToWear.isNotEmpty) _buildDivider(),
          ],
          if (timeToWear.isNotEmpty)
            _buildInfoRow('Time to Wear', timeToWear),
        ],
      ),
    );
  }

  Widget _buildPersonalizedCard(String personalizedResponse) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Personalized Response',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            personalizedResponse,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurificationCard(String purification) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cleaning_services_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Purification',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            purification,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Spacing.w(12),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: "#6F221E".toColor().withOpacity(0.1),
    );
  }
}










