import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Lal Kitab Houses – compact table form (House, Maalik, Pakka Ghar, Kismat, Soya, Exalt, Debilitated).
class LalKitabHousesWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabHousesWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabHouses.value) {
        return Center(child: CircularProgressIndicator(color: '#ed6f30'.toColor()));
      }
      final data = controller.lalKitabHousesData.value;
      final response = data?['data']?['response'] as List<dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(color: '#6F221E'.toColor().withOpacity(0.6)),
          ),
        );
      }
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: _planetCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleRow('Lal Kitab Houses', Icons.home_rounded),
              _buildTableHeader(const ['House', 'Maalik', 'Pakka', 'Kismat', 'Soya', 'Exalt', 'Debil']),
              ...response.asMap().entries.map((e) => _buildTableRow(e.value as Map<String, dynamic>, e.key)),
            ],
          ),
        ),
      );
    });
  }

  Widget _planetCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
        border: Border.all(color: '#ed6f30'.toColor().withOpacity(0.2), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildTitleRow(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: '#ed6f30'.toColor().withOpacity(0.08),
        border: Border(bottom: BorderSide(color: '#ed6f30'.toColor().withOpacity(0.25), width: 1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.w, color: '#ed6f30'.toColor()),
          Spacing.w(8),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(color: '#6F221E'.toColor(), fontWeight: FontWeight.w600, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> labels) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: ['#FF8A3D'.toColor(), '#ed6f30'.toColor()], begin: Alignment.centerLeft, end: Alignment.centerRight),
      ),
      child: Row(
        children: labels.map((l) => Expanded(
          child: AutoTranslateText(
            l,
            style: MyTextTheme.smallBCB.copyWith(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        )).toList(),
      ),
    );
  }

  String _formatList(dynamic v) {
    if (v == null) return '-';
    if (v is List) return v.isEmpty ? '-' : v.map((e) => e.toString()).join(', ');
    if (v is String && v != '-') return v;
    return '-';
  }

  Widget _buildTableRow(Map<String, dynamic> house, int index) {
    final khanaNumber = house['khana_number'] as int? ?? 0;
    final maalik = house['maalik'] as String? ?? '';
    final pakkaGhar = house['pakka_ghar'] as String? ?? '';
    final kismat = house['kismat'] as String? ?? '';
    final soya = house['soya'] as bool? ?? false;
    final exalt = _formatList(house['exalt']);
    final debilitated = _formatList(house['debilitated']);
    final isEven = index.isEven;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isEven ? '#ed6f30'.toColor().withOpacity(0.04) : Colors.white,
        border: Border(bottom: BorderSide(color: '#ed6f30'.toColor().withOpacity(0.12), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(child: _cell('$khanaNumber')),
          Expanded(child: _cell(maalik)),
          Expanded(child: _cell(pakkaGhar)),
          Expanded(child: _cell(kismat)),
          Expanded(child: _cell(soya ? 'Yes' : 'No')),
          Expanded(child: _cell(exalt)),
          Expanded(child: _cell(debilitated)),
        ],
      ),
    );
  }

  Widget _cell(String text) {
    return AutoTranslateText(
      text,
      style: MyTextTheme.smallBCB.copyWith(color: '#6F221E'.toColor(), fontWeight: FontWeight.w500, fontSize: 9.sp),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}

