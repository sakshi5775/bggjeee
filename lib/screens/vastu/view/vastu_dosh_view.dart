import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VastuDoshView extends StatelessWidget {
  const VastuDoshView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Vastu Dosh',
                      style: MyTextTheme.veryLargeBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h1),
                    ),
                    Spacing.h(8),
                    AutoTranslateText(
                      'Common Vastu defects and their remedies',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#666666'.toColor(),
                      ).merge(AppTypography.body1),
                    ),
                    Spacing.h(24),
                    _buildDoshCard(
                      'Kitchen in Northeast',
                      'Kitchen in Northeast direction creates major Vastu dosh as it conflicts with the sacred zone.',
                      [
                        'Relocate kitchen to Southeast if possible',
                        'If relocation not possible, place gas stove in Southeast corner',
                        'Keep Northeast corner clean and use light colors',
                        'Place copper vessel with water in Northeast',
                      ],
                      Icons.kitchen,
                    ),
                    Spacing.h(16),
                    _buildDoshCard(
                      'Bathroom in Northeast',
                      'Bathroom in Northeast is considered highly inauspicious and affects health and prosperity.',
                      [
                        'Relocate bathroom to Northwest or West',
                        'Keep bathroom door closed always',
                        'Use exhaust fan regularly',
                        'Place salt in corners to neutralize negative energy',
                      ],
                      Icons.bathroom,
                    ),
                    Spacing.h(16),
                    _buildDoshCard(
                      'Bedroom in Northeast',
                      'Bedroom in Northeast affects sleep quality and may cause health issues.',
                      [
                        'Move bedroom to Southwest or South',
                        'If not possible, sleep with head towards South',
                        'Use calming colors like blue or green',
                        'Keep Northeast corner of bedroom empty',
                      ],
                      Icons.bed,
                    ),
                    Spacing.h(16),
                    _buildDoshCard(
                      'Staircase in Center',
                      'Staircase in center of house creates energy imbalance and affects all directions.',
                      [
                        'Relocate staircase to West or South',
                        'Ensure stairs are clockwise from top view',
                        'Avoid spiral or circular stairs',
                        'Keep center area open and well-lit',
                      ],
                      Icons.stairs,
                    ),
                    Spacing.h(16),
                    _buildDoshCard(
                      'Toilet in Northeast',
                      'Toilet in Northeast is extremely inauspicious and affects prosperity and health.',
                      [
                        'Immediate relocation to Northwest or West',
                        'Keep toilet seat closed',
                        'Use proper ventilation',
                        'Place Vastu pyramid or crystal in Northeast',
                      ],
                      Icons.wc,
                    ),
                    Spacing.h(16),
                    _buildDoshCard(
                      'Main Door Facing South',
                      'Main entrance facing South may bring negative energy and affect relationships.',
                      [
                        'If possible, change entrance to North or East',
                        'Place auspicious symbols near entrance',
                        'Use bright lighting at entrance',
                        'Keep entrance area clean and clutter-free',
                      ],
                      Icons.home,
                    ),
                    Spacing.h(16),
                    _buildDoshCard(
                      'Water Tank in Southwest',
                      'Water tank in Southwest affects stability and may cause financial issues.',
                      [
                        'Relocate water tank to Northeast or North',
                        'Keep Southwest elevated and dry',
                        'Use Southwest for heavy furniture or master bedroom',
                        'Place water features in Northeast',
                      ],
                      Icons.water_drop,
                    ),
                    Spacing.h(16),
                    _buildDoshCard(
                      'Pooja Room in South',
                      'Pooja room in South direction may affect spiritual energy and peace.',
                      [
                        'Relocate to Northeast or East',
                        'If not possible, face deity towards East',
                        'Keep pooja room clean and well-lit',
                        'Avoid placing pooja room below bathroom',
                      ],
                      Icons.temple_hindu,
                    ),
                    Spacing.h(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: '#ffffff'.toColor(),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: '#3E2723'.toColor(),
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshCard(String title, String description, List<String> remedies, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#FFEBEE'.toColor(),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                  color: '#FFEBEE'.toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: '#E53935'.toColor(),
                  size: 24.w,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h2),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            description,
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#666666'.toColor(),
            ).merge(AppTypography.body1),
          ),
          Spacing.h(16),
          AutoTranslateText(
            'Remedies:',
            style: MyTextTheme.mediumBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h3),
          ),
          Spacing.h(8),
          ...remedies.map((remedy) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: '#4CAF50'.toColor(),
                  size: 18.w,
                ),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(
                    remedy,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: '#666666'.toColor(),
                    ).merge(AppTypography.body2),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

