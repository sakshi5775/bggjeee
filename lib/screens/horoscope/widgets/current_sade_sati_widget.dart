import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CurrentSadeSatiWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const CurrentSadeSatiWidget({
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
      if (controller.isLoadingSadeSati.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(orangeGradient.colors.first),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Sade Sati...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: primaryGradient.colors.first.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.sadeSatiData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Sade Sati data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.7),
            ),
          ),
        );
      }

      final dateConsidered = data['date_considered']?.toString() ?? '--';
      final isSadeSatiPeriod = data['is_sade_sati_period'] as bool? ?? false;
      final shaniPeriodType = data['shani_period_type']?.toString() ?? '--';
      final botResponse = data['bot_response']?.toString() ?? '';
      final description = data['description']?.toString() ?? '';
      final saturnRetrograde = data['saturn_retrograde'] as bool? ?? false;
      final age = data['age']?.toString() ?? '--';
      final remedies = (data['remedies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

      return Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(20),
            _buildStatusCard(isSadeSatiPeriod, shaniPeriodType, dateConsidered, saturnRetrograde, age),
            Spacing.h(20),
            if (botResponse.isNotEmpty) _buildBotResponseCard(botResponse),
            Spacing.h(20),
            if (description.isNotEmpty) _buildDescriptionCard(description),
            if (remedies.isNotEmpty) ...[
              Spacing.h(20),
              _buildRemediesCard(remedies),
            ],
          ],
        ),
        ),
      );
    });
  }

  Widget _buildTitleSection() {
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
              Icons.warning_rounded,
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
                  'Current Sade Sati',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Saturn Period Analysis',
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

  Widget _buildStatusCard(bool isSadeSatiPeriod, String shaniPeriodType, String dateConsidered, bool saturnRetrograde, String age) {
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
                'Status Information',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          _buildInfoRow('Date Considered', dateConsidered),
          _buildDivider(),
          _buildInfoRow('Sade Sati Period', isSadeSatiPeriod ? 'Yes' : 'No'),
          _buildDivider(),
          _buildInfoRow('Shani Period Type', shaniPeriodType),
          _buildDivider(),
          _buildInfoRow('Saturn Retrograde', saturnRetrograde ? 'Yes' : 'No'),
          if (age != '--') ...[
            _buildDivider(),
            _buildInfoRow('Age', age),
          ],
        ],
      ),
    );
  }

  Widget _buildBotResponseCard(String botResponse) {
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
                  Icons.chat_bubble_outline_rounded,
                  color: const Color(0xFFDFB343),
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Response',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            botResponse,
            style: MyTextTheme.smallBCN.copyWith(
              color: primaryGradient.colors.first.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(String description) {
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

  Widget _buildRemediesCard(List<String> remedies) {
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
                  Icons.healing_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Remedies',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: primaryGradient.colors.first,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(16),
          ...remedies.map((remedy) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6.h, right: 12.w),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: orangeGradient.colors.first,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: AutoTranslateText(
                        remedy,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: primaryGradient.colors.first.withOpacity(0.8),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
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

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: primaryGradient.colors.first.withOpacity(0.1),
    );
  }
}










