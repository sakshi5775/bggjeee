import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/consult_astrologer_card.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';

class BirthDetailsWidget extends StatelessWidget {
  final KundliResultController controller;

  const BirthDetailsWidget({super.key, required this.controller});

  static const _details = [
    ('Name', _name),
    ('Date', _date),
    ('Time', _time),
    ('Place', _place),
    ('Gender', _gender),
    ('Ayanamsa', _ayanamsa),
    ('DST', _dst),
    ('Mangal Dosh', _mangalDosh),
    ('Rashi', _rashi),
    ('Nakshatra', _nakshatra),
    ('Age', _age),
    ('Bal. Dasa', _balDasa),
  ];

  static String _name(KundliResultController c) => c.getName();
  static String _date(KundliResultController c) => c.getDate();
  static String _time(KundliResultController c) => c.getTime();
  static String _place(KundliResultController c) => c.getPlace();
  static String _gender(KundliResultController c) => c.getGender();
  static String _ayanamsa(KundliResultController c) => c.getAyanamsa();
  static String _dst(KundliResultController c) => c.getDST();
  static String _mangalDosh(KundliResultController c) => c.getMangalDosh();
  static String _rashi(KundliResultController c) => c.getRashi();
  static String _nakshatra(KundliResultController c) => c.getNakshatra();
  static String _age(KundliResultController c) => c.getAge();
  static String _balDasa(KundliResultController c) => c.getBalDasa();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPlanetDetails.value ||
          controller.isLoadingMangalDosh.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28.w,
                height: 28.w,
                child: CircularProgressIndicator(
                  color: "#ed6f30".toColor(),
                  strokeWidth: 2,
                ),
              ),
              Spacing.h(10),
              AutoTranslateText(
                'Loading birth details...',
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#6F221E".toColor().withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: "#ed6f30".toColor().withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description_rounded,
                          size: 18.w,
                          color: Colors.white,
                        ),
                        Spacing.w(8),
                        AutoTranslateText(
                          'Birth Details',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < _details.length; i++) ...[
                          if (i > 0)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: "#6F221E".toColor().withValues(alpha: 0.1),
                            ),
                          _buildDetailRow(
                            _details[i].$1,
                            _details[i].$2(controller),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(12),
            const ConsultAstrologerCard(),
            Spacing.h(30),
          ],
        ),
      );
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCB.copyWith(
                color: "#6F221E".toColor().withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
          ),
          Spacing.w(8),
          Expanded(
            child: AutoTranslateText(
              value,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor(),
                fontSize: 11.sp,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
