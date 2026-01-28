import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VastuTipsView extends StatelessWidget {
  const VastuTipsView({Key? key}) : super(key: key);

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
                      'Vastu Tips',
                      style: MyTextTheme.veryLargeBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h1),
                    ),
                    Spacing.h(8),
                    AutoTranslateText(
                      'Practical tips for harmonious living',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#666666'.toColor(),
                      ).merge(AppTypography.body1),
                    ),
                    Spacing.h(24),
                    _buildTipCard(
                      'Daily Practices',
                      [
                        'Keep entrance area clean and well-lit',
                        'Open windows in morning for fresh energy',
                        'Keep mirrors clean and properly placed',
                        'Remove clutter regularly',
                        'Maintain positive atmosphere with good lighting',
                      ],
                      Icons.wb_sunny,
                    ),
                    Spacing.h(16),
                    _buildTipCard(
                      'Kitchen Tips',
                      [
                        'Cook facing East for positive energy',
                        'Keep gas stove in Southeast corner',
                        'Store grains in Southwest',
                        'Keep kitchen clean and organized',
                        'Avoid placing refrigerator in Northeast',
                      ],
                      Icons.restaurant,
                    ),
                    Spacing.h(16),
                    _buildTipCard(
                      'Bedroom Tips',
                      [
                        'Sleep with head towards South or East',
                        'Avoid mirrors facing bed',
                        'Keep bedroom clutter-free',
                        'Use calming colors like blue or green',
                        'Keep electronic devices away from bed',
                      ],
                      Icons.bed,
                    ),
                    Spacing.h(16),
                    _buildTipCard(
                      'Living Room Tips',
                      [
                        'Place heavy furniture in Southwest',
                        'Keep center area open',
                        'Use bright, positive colors',
                        'Ensure good ventilation',
                        'Place plants in Northeast corner',
                      ],
                      Icons.living,
                    ),
                    Spacing.h(16),
                    _buildTipCard(
                      'Office Tips',
                      [
                        'Face North or East while working',
                        'Keep desk organized and clutter-free',
                        'Place computer in Southeast',
                        'Use green plants for positive energy',
                        'Keep Southwest elevated with heavy items',
                      ],
                      Icons.work,
                    ),
                    Spacing.h(16),
                    _buildTipCard(
                      'Bathroom Tips',
                      [
                        'Keep bathroom door closed always',
                        'Use exhaust fan regularly',
                        'Maintain cleanliness',
                        'Place salt in corners weekly',
                        'Keep bathroom well-ventilated',
                      ],
                      Icons.bathroom,
                    ),
                    Spacing.h(16),
                    _buildTipCard(
                      'Pooja Room Tips',
                      [
                        'Face deity towards East or North',
                        'Keep pooja room clean and sacred',
                        'Light lamp daily in Northeast',
                        'Use white or yellow colors',
                        'Avoid placing below bathroom or bedroom',
                      ],
                      Icons.temple_hindu,
                    ),
                    Spacing.h(16),
                    _buildTipCard(
                      'General Tips',
                      [
                        'Keep Northeast corner light and open',
                        'Place water features in North or Northeast',
                        'Avoid sharp corners pointing at living areas',
                        'Use natural materials when possible',
                        'Maintain balance in all directions',
                      ],
                      Icons.lightbulb,
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

  Widget _buildTipCard(String category, List<String> tips, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#FFF3E0'.toColor(),
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
                  color: '#FFF3E0'.toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: '#F39C12'.toColor(),
                  size: 24.w,
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                category,
                style: MyTextTheme.largeBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h2),
              ),
            ],
          ),
          Spacing.h(16),
          ...tips.map((tip) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: '#F39C12'.toColor(),
                  size: 18.w,
                ),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(
                    tip,
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

