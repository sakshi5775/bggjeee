import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KeyPointsWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const KeyPointsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingExtendedKundali.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Key Points...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.extendedKundaliData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Key Points data available',
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
            _buildTitleSection(),
            Spacing.h(20),
            
            // Basic Information Card
            _buildBasicInfoCard(data),
            Spacing.h(20),
            
            // Astrological Details Card
            _buildAstrologicalCard(data),
            Spacing.h(20),
            
            // Stones & Lucky Elements Card
            _buildStonesCard(data),
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
              Icons.star_rounded,
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
                  'Key Points',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: Colors.white,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Extended Kundali Information',
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
    final gana = data['gana']?.toString() ?? '--';
    final yoni = data['yoni']?.toString() ?? '--';
    final vasya = data['vasya']?.toString() ?? '--';
    final nadi = data['nadi']?.toString() ?? '--';
    final varna = data['varna']?.toString() ?? '--';
    final paya = data['paya']?.toString() ?? '--';
    final tatva = data['tatva']?.toString() ?? '--';
    
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
                Icons.info_outline_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Basic Information',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          _buildInfoRow('Gana', gana),
          _buildDivider(),
          _buildInfoRow('Yoni', yoni),
          _buildDivider(),
          _buildInfoRow('Vasya', vasya),
          _buildDivider(),
          _buildInfoRow('Nadi', nadi),
          _buildDivider(),
          _buildInfoRow('Varna', varna),
          _buildDivider(),
          _buildInfoRow('Paya', paya),
          _buildDivider(),
          _buildInfoRow('Tatva', tatva),
        ],
      ),
    );
  }

  Widget _buildAstrologicalCard(Map<String, dynamic> data) {
    final ascendantSign = data['ascendant_sign']?.toString() ?? '--';
    final ascendantNakshatra = data['ascendant_nakshatra']?.toString() ?? '--';
    final rasi = data['rasi']?.toString() ?? '--';
    final rasiLord = data['rasi_lord']?.toString() ?? '--';
    final nakshatra = data['nakshatra']?.toString() ?? '--';
    final nakshatraLord = data['nakshatra_lord']?.toString() ?? '--';
    final nakshatraPada = data['nakshatra_pada']?.toString() ?? '--';
    final sunSign = data['sun_sign']?.toString() ?? '--';
    final tithi = data['tithi']?.toString() ?? '--';
    final karana = data['karana']?.toString() ?? '--';
    final yoga = data['yoga']?.toString() ?? '--';
    
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
                'Astrological Details',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          _buildInfoRow('Ascendant Sign', ascendantSign),
          _buildDivider(),
          _buildInfoRow('Ascendant Nakshatra', ascendantNakshatra),
          _buildDivider(),
          _buildInfoRow('Rasi', rasi),
          _buildDivider(),
          _buildInfoRow('Rasi Lord', rasiLord),
          _buildDivider(),
          _buildInfoRow('Nakshatra', nakshatra),
          _buildDivider(),
          _buildInfoRow('Nakshatra Lord', nakshatraLord),
          _buildDivider(),
          _buildInfoRow('Nakshatra Pada', nakshatraPada),
          _buildDivider(),
          _buildInfoRow('Sun Sign', sunSign),
          _buildDivider(),
          _buildInfoRow('Tithi', tithi),
          _buildDivider(),
          _buildInfoRow('Karana', karana),
          _buildDivider(),
          _buildInfoRow('Yoga', yoga),
        ],
      ),
    );
  }

  Widget _buildStonesCard(Map<String, dynamic> data) {
    final lifeStone = data['life_stone']?.toString() ?? '--';
    final luckyStone = data['lucky_stone']?.toString() ?? '--';
    final fortuneStone = data['fortune_stone']?.toString() ?? '--';
    final nameStart = data['name_start']?.toString() ?? '--';
    
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
                Icons.diamond_rounded,
                color: "#ed6f30".toColor(),
                size: 24.w,
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Stones & Lucky Elements',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(20),
          _buildInfoRow('Life Stone', lifeStone),
          _buildDivider(),
          _buildInfoRow('Lucky Stone', luckyStone),
          _buildDivider(),
          _buildInfoRow('Fortune Stone', fortuneStone),
          _buildDivider(),
          _buildInfoRow('Name Start', nameStart),
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










