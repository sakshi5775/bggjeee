import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/lal_kitab_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Lal Kitab Kundli â€“ compact table form (Sign #, Sign Name, Planets).
class LalKitabKundliWidget extends StatelessWidget {
  final LalKitabController controller;

  const LalKitabKundliWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingLalKitabHoroscope.value) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      final data = controller.lalKitabHoroscopeData.value;
      final response = data?['data']?['response'] as List<dynamic>?;
      if (response == null || response.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(color: '#6F221E'.toColor().withValues(alpha: 0.6)),
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
              _buildTitleRow('Lal Kitab Kundli', Icons.menu_book_rounded),
              _buildTableHeader(const ['Sign', 'Sign Name', 'Planets']),
              ...response.asMap().entries.map((e) => _buildTableRow(
                    e.value as Map<String, dynamic>,
                    e.key,
                  )),
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
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
        border: Border.all(color: '#ed6f30'.toColor().withValues(alpha: 0.2), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildTitleRow(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: '#ed6f30'.toColor().withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(color: '#ed6f30'.toColor().withValues(alpha: 0.25), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.w, color: '#ed6f30'.toColor()),
          Spacing.w(8),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
              color: '#6F221E'.toColor(),
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> labels) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ['#FF8A3D'.toColor(), '#ed6f30'.toColor()],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: AutoTranslateText(
              labels[0],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              labels[1],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              labels[2],
              style: MyTextTheme.smallBCB.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> sign, int index) {
    final signNum = sign['sign'] as int? ?? 0;
    final signName = sign['sign_name'] as String? ?? '';
    final planetSmall = sign['planet_small'] as List<dynamic>? ?? [];
    final planets = sign['planet'] as List<dynamic>? ?? [];
    final planetText = planetSmall.isNotEmpty
        ? planetSmall.map((e) => e.toString()).join(', ')
        : (planets.isNotEmpty ? planets.map((e) => e.toString()).join(', ') : '-');
    final isEven = index.isEven;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isEven ? '#ed6f30'.toColor().withValues(alpha: 0.04) : Colors.white,
        border: Border(
          bottom: BorderSide(color: '#ed6f30'.toColor().withValues(alpha: 0.12), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: _cell('$signNum')),
          Expanded(flex: 2, child: _cell(signName, isBold: true)),
          Expanded(flex: 2, child: _cell(planetText)),
        ],
      ),
    );
  }

  Widget _cell(String text, {bool isBold = false}) {
    return AutoTranslateText(
      text,
      style: MyTextTheme.smallBCB.copyWith(
        color: '#6F221E'.toColor(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        fontSize: 10.sp,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}

