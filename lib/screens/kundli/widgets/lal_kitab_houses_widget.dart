import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LalKitabHousesWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabHousesWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabHouses.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.lalKitabHousesData.value;
      
      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      final response = data['data']?['response'] as List<dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withOpacity(0.6),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...response.map((house) {
              final houseData = house as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildHouseCard(houseData),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildHouseCard(Map<String, dynamic> house) {
    final khanaNumber = house['khana_number'] as int? ?? 0;
    final maalik = house['maalik'] as String? ?? '';
    final pakkaGhar = house['pakka_ghar'] as String? ?? '';
    final kismat = house['kismat'] as String? ?? '';
    final soya = house['soya'] as bool? ?? false;
    final exalt = house['exalt'] as dynamic;
    final debilitated = house['debilitated'] as dynamic;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#ed6f30".toColor().withOpacity(0.1),
            "#ed6f30".toColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#ed6f30".toColor().withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // House Number Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AutoTranslateText(
                  'House $khanaNumber',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h3),
                ),
              ),
              if (soya) ...[
                Spacing.w(8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: AutoTranslateText(
                    'Soya',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.label),
                  ),
                ),
              ],
            ],
          ),
          Spacing.h(16),
          
          // Details Grid
          _buildDetailRow('Maalik', maalik),
          _buildDetailRow('Pakka Ghar', pakkaGhar),
          _buildDetailRow('Kismat', kismat),
          
          // Exalt
          if (exalt != null && exalt != '-') ...[
            Spacing.h(8),
            _buildPlanetList('Exalt', exalt),
          ],
          
          // Debilitated
          if (debilitated != null && debilitated != '-') ...[
            Spacing.h(8),
            _buildPlanetList('Debilitated', debilitated),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withOpacity(0.7),
              ).merge(AppTypography.body2),
            ),
          ),
          Expanded(
            flex: 3,
            child: AutoTranslateText(
              value,
              textAlign: TextAlign.right,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
              ).merge(AppTypography.body2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetList(String label, dynamic planets) {
    List<String> planetList = [];
    if (planets is List) {
      planetList = planets.map((p) => p.toString()).toList();
    } else if (planets is String && planets != '-') {
      planetList = [planets];
    }

    if (planetList.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          label,
          style: MyTextTheme.smallBCB.copyWith(
            color: "#6F221E".toColor().withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ).merge(AppTypography.body2),
        ),
        Spacing.h(8),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: planetList.map((planet) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: label == 'Exalt' 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: label == 'Exalt'
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: AutoTranslateText(
                planet,
                style: MyTextTheme.smallBCB.copyWith(
                  color: label == 'Exalt' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ).merge(AppTypography.body2),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

