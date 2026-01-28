import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GemSuggestionWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const GemSuggestionWidget({
    super.key,
    required this.controller,
  });

  // Gradient definitions
  static final LinearGradient gradientBackground = LinearGradient(
    colors: ["#FCE5AA".toColor(), "#FFFCF3".toColor(), "#FFFFFF".toColor()],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient primaryGradient = LinearGradient(
    colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
  );

  static LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingGemSuggestion.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(orangeGradient.colors.first),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Gem Suggestion...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: primaryGradient.colors.first.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.gemSuggestionData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Gem Suggestion data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.7),
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(data),
            Spacing.h(20),
            _buildBasicInfoCard(data),
            Spacing.h(20),
            _buildWearingInfoCard(data),
            Spacing.h(20),
            _buildDescriptionCard(data),
            Spacing.h(20),
            _buildGoodResultsCard(data),
            Spacing.h(20),
            _buildDiseasesCureCard(data),
            Spacing.h(20),
            _buildFlawResultsCard(data),
            Spacing.h(20),
            _buildOtherStonesCard(data),
          ],
        ),
        ),
      );
    });
  }

  Widget _buildTitleSection(Map<String, dynamic> data) {
    final name = data['name']?.toString() ?? '--';
    final gem = data['gem']?.toString() ?? '--';
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: primaryGradient.colors.first.withOpacity(0.3),
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
              Icons.diamond_rounded,
              color: const Color(0xFFDFB343),
              size: 28.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  name,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  gem,
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

  Widget _buildBasicInfoCard(Map<String, dynamic> data) {
    final planet = data['planet']?.toString() ?? '--';
    final otherName = data['other_name']?.toString() ?? '--';
    final color = data['color']?.toString() ?? '--';
    final finger = data['finger']?.toString() ?? '--';
    final weight = data['weight']?.toString() ?? '--';
    final day = data['day']?.toString() ?? '--';
    final metal = data['metal']?.toString() ?? '--';
    
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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: const Color(0xFFDFB343),
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Basic Information',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          _buildInfoRow('Planet', planet),
          _buildDivider(),
          _buildInfoRow('Other Name', otherName),
          _buildDivider(),
          _buildInfoRow('Color', color),
          _buildDivider(),
          _buildInfoRow('Finger', finger),
          _buildDivider(),
          _buildInfoRow('Weight', weight),
          _buildDivider(),
          _buildInfoRow('Day', day),
          _buildDivider(),
          _buildInfoRow('Metal', metal),
        ],
      ),
    );
  }

  Widget _buildWearingInfoCard(Map<String, dynamic> data) {
    final timeToWearShort = data['time_to_wear_short']?.toString() ?? '';
    final timeToWear = data['time_to_wear']?.toString() ?? '';
    final methods = data['methods']?.toString() ?? '';
    final mantra = data['mantra']?.toString() ?? '';
    
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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Wearing Information',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          if (timeToWearShort.isNotEmpty) ...[
            _buildInfoRow('Time to Wear', timeToWearShort),
            if (timeToWear.isNotEmpty || methods.isNotEmpty || mantra.isNotEmpty) _buildDivider(),
          ],
          if (timeToWear.isNotEmpty) ...[
            _buildTextSection('Detailed Time', timeToWear),
            if (methods.isNotEmpty || mantra.isNotEmpty) _buildDivider(),
          ],
          if (methods.isNotEmpty) ...[
            _buildTextSection('Methods', methods),
            if (mantra.isNotEmpty) _buildDivider(),
          ],
          if (mantra.isNotEmpty)
            _buildTextSection('Mantra', mantra),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(Map<String, dynamic> data) {
    final description = data['description']?.toString() ?? '';
    if (description.isEmpty) return SizedBox.shrink();
    
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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: const Color(0xFFDFB343),
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Description',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            description,
            style: MyTextTheme.smallBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoodResultsCard(Map<String, dynamic> data) {
    final goodResults = (data['good_results'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    if (goodResults.isEmpty) return SizedBox.shrink();
    
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
                Icons.check_circle_outline_rounded,
                color: Colors.green,
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Good Results',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: goodResults.map((result) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: AutoTranslateText(
                  result,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseasesCureCard(Map<String, dynamic> data) {
    final diseasesCure = (data['diseases_cure'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    if (diseasesCure.isEmpty) return SizedBox.shrink();
    
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
                Icons.healing_rounded,
                color: Colors.blue,
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Diseases Cure',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: diseasesCure.map((disease) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: AutoTranslateText(
                  disease,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: Colors.blue.shade700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFlawResultsCard(Map<String, dynamic> data) {
    final flawResults = data['flaw_results'] as List<dynamic>? ?? [];
    if (flawResults.isEmpty) return SizedBox.shrink();
    
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
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Flaw Results',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          ...flawResults.map((flaw) {
            final flawMap = flaw as Map<String, dynamic>? ?? {};
            final flawType = flawMap['flaw_type']?.toString() ?? '';
            final flawEffects = flawMap['flaw_effects']?.toString() ?? '';
            
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      flawType,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.h(4),
                    AutoTranslateText(
                      flawEffects,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: primaryGradient.colors.first.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOtherStonesCard(Map<String, dynamic> data) {
    final substitute = (data['substitute'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final notToWearWith = (data['not_to_wear_with'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final lifeStone = data['life_stone']?.toString() ?? '';
    final luckyStone = data['lucky_stone']?.toString() ?? '';
    final fortuneStone = data['fortune_stone']?.toString() ?? '';
    
    if (substitute.isEmpty && notToWearWith.isEmpty && lifeStone.isEmpty && luckyStone.isEmpty && fortuneStone.isEmpty) {
      return SizedBox.shrink();
    }
    
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
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.stars_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Other Stones',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          if (lifeStone.isNotEmpty) ...[
            _buildInfoRow('Life Stone', lifeStone),
            _buildDivider(),
          ],
          if (luckyStone.isNotEmpty) ...[
            _buildInfoRow('Lucky Stone', luckyStone),
            _buildDivider(),
          ],
          if (fortuneStone.isNotEmpty) ...[
            _buildInfoRow('Fortune Stone', fortuneStone),
            if (substitute.isNotEmpty || notToWearWith.isNotEmpty) _buildDivider(),
          ],
          if (substitute.isNotEmpty) ...[
            _buildListRow('Substitute', substitute),
            if (notToWearWith.isNotEmpty) _buildDivider(),
          ],
          if (notToWearWith.isNotEmpty)
            _buildListRow('Not to Wear With', notToWearWith),
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
                color: primaryGradient.colors.first.withOpacity(0.7),
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
                color: primaryGradient.colors.first,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSection(String label, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            text,
            style: MyTextTheme.smallBCN.copyWith(
                  color: primaryGradient.colors.first,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRow(String label, List<String> items) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacing.h(8),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: items.map((item) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: orangeGradient.colors.first.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: orangeGradient.colors.first.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: AutoTranslateText(
                  item,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: primaryGradient.colors.first,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: primaryGradient.colors.first.withOpacity(0.1),
    );
  }
}










