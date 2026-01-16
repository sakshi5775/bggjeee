import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class AscendantReportWidget extends StatelessWidget {
  final KundliResultController controller;

  const AscendantReportWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading if fetching data
      if (controller.isLoadingAscendantReport.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: "#ed6f30".toColor()),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Ascendant Report...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.ascendantReportData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Ascendant Report data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            _buildTitleSection(data),
            Spacing.h(20),

            // Ascendant Info Card
            _buildAscendantInfoCard(data),
            Spacing.h(20),

            // Predictions Section
            _buildPredictionsSection(data),
            Spacing.h(20),

            // Characteristics Section
            _buildCharacteristicsSection(data),
            Spacing.h(20),

            // Spiritual & Qualities Section
            _buildSpiritualQualitiesSection(data),
          ],
        ),
      );
    });
  }

  Widget _buildTitleSection(Map<String, dynamic> data) {
    final ascendant = data['ascendant']?.toString() ?? '--';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [
        //     "#6F221E".toColor(),
        //     "#6F221E".toColor().withOpacity(0.8),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        color: "#FFFFFF".toColor(),
        border: Border.all(color: "#FF8C42".toColor(), width: 1.0),
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
              // color: Colors.white.withOpacity(0.2),
              gradient: LinearGradient(
                colors: ["#FF8C42".toColor(), "#E63946".toColor()],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.star_rounded, color: Colors.white, size: 28.w),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Ascendant(Lagna) Report',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Ascendant: $ascendant',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: "#6F221E".toColor(),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAscendantInfoCard(Map<String, dynamic> data) {
    final ascendant = data['ascendant']?.toString() ?? '--';
    final ascendantLord = data['ascendant_lord']?.toString() ?? '--';
    final ascendantLordLocation =
        data['ascendant_lord_location']?.toString() ?? '--';
    final ascendantLordHouseLocation =
        data['ascendant_lord_house_location']?.toString() ?? '--';
    final ascendantLordStrength =
        data['ascendant_lord_strength']?.toString() ?? '--';
    final symbol = data['symbol']?.toString() ?? '--';
    final zodiacCharacteristics =
        data['zodiac_characteristics']?.toString() ?? '--';
    final verbalLocation = data['verbal_location']?.toString() ?? '--';

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
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: "#FF8C42".toColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: "#ed6f30".toColor(),
                  size: 24.w,
                ),
              ),
              // Icon(
              //   Icons.info_outline_rounded,
              //   color: "#ed6f30".toColor(),
              //   size: 24.w,
              // ),
              Spacing.w(12),
              AutoTranslateText(
                'Ascendant Information',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          _buildInfoRow('Ascendant', ascendant),
          _buildDivider(),
          _buildInfoRow('Ascendant Lord', ascendantLord),
          _buildDivider(),
          _buildInfoRow('Lord Location', ascendantLordLocation),
          _buildDivider(),
          _buildInfoRow(
            'Lord House Location',
            'House $ascendantLordHouseLocation',
          ),
          _buildDivider(),
          _buildInfoRow('Lord Strength', ascendantLordStrength),
          _buildDivider(),
          _buildInfoRow('Symbol', symbol),
          _buildDivider(),
          _buildInfoRow('Characteristics', zodiacCharacteristics),
          if (verbalLocation.isNotEmpty && verbalLocation != '--') ...[
            _buildDivider(),
            _buildInfoRow('Location', verbalLocation),
          ],
        ],
      ),
    );
  }

  Widget _buildPredictionsSection(Map<String, dynamic> data) {
    final generalPrediction = data['general_prediction']?.toString() ?? '';
    final personalisedPrediction =
        data['personalised_prediction']?.toString() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (generalPrediction.isNotEmpty) ...[
          _buildPredictionCard(
            'General Prediction',
            generalPrediction,
            Icons.auto_awesome_outlined,
            Colors.blue,
          ),
          Spacing.h(16),
        ],
        if (personalisedPrediction.isNotEmpty) ...[
          _buildPredictionCard(
            'Personalised Prediction',
            personalisedPrediction,
            Icons.person_outline_rounded,
            Colors.purple,
          ),
        ],
      ],
    );
  }

  Widget _buildPredictionCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
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
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: color, size: 22.w),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(16),
          AutoTranslateText(
            content,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacteristicsSection(Map<String, dynamic> data) {
    final flagshipQualities = data['flagship_qualities']?.toString() ?? '';
    final goodQualities = data['good_qualities']?.toString() ?? '';
    final badQualities = data['bad_qualities']?.toString() ?? '';

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
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: "#FF8C42".toColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  color: "#ed6f30".toColor(),
                  size: 24.w,
                ),
              ),
              // Icon(
              //   Icons.psychology_outlined,
              //   color: "#ed6f30".toColor(),
              //   size: 24.w,
              // ),
              Spacing.w(12),
              AutoTranslateText(
                'Characteristics',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          if (flagshipQualities.isNotEmpty) ...[
            _buildQualitiesCard(
              'Flagship Qualities',
              flagshipQualities,
              Colors.green,
            ),
            Spacing.h(16),
          ],
          if (goodQualities.isNotEmpty) ...[
            _buildQualitiesCard('Good Qualities', goodQualities, Colors.blue),
            Spacing.h(16),
          ],
          if (badQualities.isNotEmpty) ...[
            _buildQualitiesCard(
              'Areas to Improve',
              badQualities,
              Colors.orange,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQualitiesCard(String title, String content, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            title,
            style: MyTextTheme.smallBCB.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            content,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpiritualQualitiesSection(Map<String, dynamic> data) {
    final spiritualityAdvice = data['spirituality_advice']?.toString() ?? '';
    final luckyGem = data['lucky_gem']?.toString() ?? '';
    final dayForFasting = data['day_for_fasting']?.toString() ?? '';
    final gayatriMantra = data['gayatri_mantra']?.toString() ?? '';

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
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: "#FF8C42".toColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.self_improvement_outlined,
                  color: "#ed6f30".toColor(),
                  size: 24.w,
                ),
              ),
              // Icon(
              //   Icons.self_improvement_outlined,
              //   color: "#ed6f30".toColor(),
              //   size: 24.w,
              // ),
              Spacing.w(12),
              AutoTranslateText(
                'Spiritual & Lucky Elements',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          if (spiritualityAdvice.isNotEmpty) ...[
            _buildSpiritualCard(
              'Spirituality Advice',
              spiritualityAdvice,
              Icons.lightbulb_outline,
            ),
            Spacing.h(16),
          ],
          if (luckyGem.isNotEmpty) ...[
            _buildInfoRow('Lucky Gem', luckyGem),
            _buildDivider(),
          ],
          if (dayForFasting.isNotEmpty) ...[
            _buildInfoRow('Day for Fasting', dayForFasting),
            _buildDivider(),
          ],
          if (gayatriMantra.isNotEmpty) ...[
            _buildMantraCard('Gayatri Mantra', gayatriMantra),
          ],
        ],
      ),
    );
  }

  Widget _buildSpiritualCard(String title, String content, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
          Row(
            children: [
              Icon(icon, color: "#DFB343".toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                title,
                style: MyTextTheme.smallBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            content,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMantraCard(String title, String mantra) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [
        //     "#6F221E".toColor().withOpacity(0.1),
        //     "#6F221E".toColor().withOpacity(0.05),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: "#6F221E".toColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.book_outlined, color: "#6F221E".toColor(), size: 18.w),
              // Icon(
              //   Icons.mantra_outlined,
              //   color: "#6F221E".toColor(),
              //   size: 24.w,
              // ),
              Spacing.w(12),
              AutoTranslateText(
                title,
                style: MyTextTheme.smallBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // AutoTranslateText(
          //   title,
          //   style: MyTextTheme.smallBCB.copyWith(
          //     color: "#6F221E".toColor(),
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          Spacing.h(12),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AutoTranslateText(
              mantra,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor(),
                height: 1.8,
                fontStyle: FontStyle.italic,
              ),
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
              style: MyTextTheme.smallBCN.copyWith(color: "#6F221E".toColor()),
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
