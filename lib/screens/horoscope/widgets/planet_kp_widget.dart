import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanetKpWidget extends StatelessWidget {
  final HoroscopeMainController controller;

  const PlanetKpWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPlanetKp.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: "#ed6f30".toColor(),
              ),
              Spacing.h(16),
              AutoTranslateText(
                'Loading Planet KP...',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }

      final data = controller.planetKpData.value;
      if (data == null) {
        return Center(
          child: AutoTranslateText(
            'No Planet KP data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.7),
            ),
          ),
        );
      }

      // Extract planets from data (keys are "0", "1", "2", etc.)
      final planets = <Map<String, dynamic>>[];
      data.forEach((key, value) {
        if (key != 'callsRemaining' && value is Map<String, dynamic>) {
          planets.add(value);
        }
      });

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            Spacing.h(20),
            ...planets.map((planet) => _buildPlanetCard(planet)),
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
              Icons.auto_awesome_rounded,
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
                  'Planet KP',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: Colors.white,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Krishnamurti Paddhati Details',
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

  Widget _buildPlanetCard(Map<String, dynamic> planet) {
    final name = planet['name']?.toString() ?? '--';
    final fullName = planet['full_name']?.toString() ?? '--';
    final localDegree = planet['local_degree']?.toString() ?? '--';
    final globalDegree = planet['global_degree']?.toString() ?? '--';
    final rasiNo = planet['rasi_no']?.toString() ?? '--';
    final zodiac = planet['zodiac']?.toString() ?? '--';
    final house = planet['house']?.toString() ?? '--';
    final pseudoNakshatra = planet['pseudo_nakshatra']?.toString() ?? '--';
    final pseudoNakshatraLord = planet['pseudo_nakshatra_lord']?.toString() ?? '--';
    final pseudoNakshatraPada = planet['pseudo_nakshatra_pada']?.toString() ?? '--';
    final pseudoNakshatraNo = planet['pseudo_nakshatra_no']?.toString() ?? '--';
    final pseudoRasi = planet['pseudo_rasi']?.toString() ?? '--';
    final pseudoRasiNo = planet['pseudo_rasi_no']?.toString() ?? '--';
    final pseudoRasiLord = planet['pseudo_rasi_lord']?.toString() ?? '--';
    final subLord = planet['sub_lord']?.toString() ?? '--';
    final subSubLord = planet['sub_sub_lord']?.toString() ?? '--';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
                  color: "#ed6f30".toColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: "#ed6f30".toColor(),
                  size: 20.w,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      fullName,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.h(2),
                    AutoTranslateText(
                      name,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.h(20),
          _buildInfoRow('Local Degree', localDegree),
          _buildDivider(),
          _buildInfoRow('Global Degree', globalDegree),
          _buildDivider(),
          _buildInfoRow('Rasi No', rasiNo),
          _buildDivider(),
          _buildInfoRow('Zodiac', zodiac),
          _buildDivider(),
          _buildInfoRow('House', house),
          _buildDivider(),
          _buildInfoRow('Pseudo Nakshatra', pseudoNakshatra),
          _buildDivider(),
          _buildInfoRow('Pseudo Nakshatra Lord', pseudoNakshatraLord),
          _buildDivider(),
          _buildInfoRow('Pseudo Nakshatra Pada', pseudoNakshatraPada),
          _buildDivider(),
          _buildInfoRow('Pseudo Nakshatra No', pseudoNakshatraNo),
          _buildDivider(),
          _buildInfoRow('Pseudo Rasi', pseudoRasi),
          _buildDivider(),
          _buildInfoRow('Pseudo Rasi No', pseudoRasiNo),
          _buildDivider(),
          _buildInfoRow('Pseudo Rasi Lord', pseudoRasiLord),
          _buildDivider(),
          _buildInfoRow('Sub Lord', subLord),
          _buildDivider(),
          _buildInfoRow('Sub Sub Lord', subSubLord),
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










