import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/carrot_astrology_model.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/controller/carrot_astrology_controller.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/utils/carrot_astrology_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/core/services/pdf_generator_service.dart';
import 'package:astrobharataiuser/data_model/pdf_metadata.dart';
import 'package:astrobharataiuser/data_model/pdf_section.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class CarrotAstrologyResultsView extends StatelessWidget {
  const CarrotAstrologyResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CarrotAstrologyData? result = Get.arguments?['result'];
    final controller = Get.isRegistered<CarrotAstrologyController>()
        ? Get.find<CarrotAstrologyController>()
        : Get.put(CarrotAstrologyController());
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    if (result == null) {
      return Scaffold(
        backgroundColor: '#F7EFBD'.toColor(),
        body: SafeArea(
          child: Column(
            children: [
              const CommonHeader(title: 'Results'),
              Expanded(
                child: Center(
                  child: AutoTranslateText(
                    'No results found',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: 'Your Carrot Astrology Reading',
              subtitle: AutoTranslateText(
                'Vegetable essence & wellness insights',
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#6F221E'.toColor().withValues(alpha: 0.7),
                ),
              ),
              showWallet: false,
              showLanguage: false,
              showCart: false,
              showSearch: false,
              customActions: [
                IconButton(
                  onPressed: () => _exportToPdf(result),
                  icon: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: '#6F221E'.toColor(),
                    size: 24.w,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.history,
                    color: '#6F221E'.toColor(),
                    size: 24.w,
                  ),
                  onPressed: () =>
                      UserMainController.pushInCurrentTab(AppRoutes.carrotAstrologyHistory),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Zodiac Info Section
                        if (result.zodiacInfo != null) ...[
                          _buildZodiacInfoSection(
                            result.zodiacInfo!,
                            controller,
                          ),
                          Spacing.h(20),
                        ],

                        // Vegetable Match Section
                        if (result.vegetableMatch != null) ...[
                          _buildVegetableMatchSection(result.vegetableMatch!),
                          Spacing.h(20),
                        ],

                        // Remedies Section
                        if (result.remedies != null) ...[
                          _buildRemediesSection(result.remedies!),
                          Spacing.h(20),
                        ],

                        // Overall Reading Section
                        if (result.overallReading != null &&
                            result.overallReading!.isNotEmpty) ...[
                          _buildOverallReadingSection(result.overallReading!),
                          Spacing.h(20),
                        ],

                        // Summary Section
                        if (result.summary != null &&
                            result.summary!.isNotEmpty) ...[
                          _buildSummarySection(result.summary!),
                          Spacing.h(20),
                        ],

                        // Consult an Astrologer Section
                        _buildConsultAstrologerSection(),
                        Spacing.h(20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultAstrologerSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: CarrotAstrologyColors.orangeGradient,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: CarrotAstrologyColors.orangeColorDark.withValues(
                alpha: 0.4,
              ),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
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
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 26.w,
                  ),
                ),
                Spacing.w(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Want More Insights?',
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            )
                            .merge(AppTypography.h2),
                      ),
                      Spacing.h(6),
                      AutoTranslateText(
                        'Consult with our expert astrologers',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.h(20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => UserMainController.pushInCurrentTab(AppRoutes.astrologyServices),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 24.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: CarrotAstrologyColors.orangeColor.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.people,
                            size: 20.w,
                            color: CarrotAstrologyColors.orangeColor,
                          ),
                        ),
                        Spacing.w(10),
                        AutoTranslateText(
                          'Consult an Astrologer',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: CarrotAstrologyColors.orangeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZodiacInfoSection(
    ZodiacInfo zodiacInfo,
    CarrotAstrologyController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: ['#FFF2E8'.toColor(), '#FFE5D4'.toColor()],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CarrotAstrologyColors.orangeColor.withOpacity(
                          0.2,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AutoTranslateText(
                      controller.getZodiacSymbol(zodiacInfo.sign ?? ''),
                      style: AppTypography.h1.copyWith(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Spacing.w(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        zodiacInfo.sign ?? '',
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              color: '#3E2723'.toColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                            )
                            .merge(AppTypography.h2),
                      ),
                      if (zodiacInfo.rulingPlanet != null ||
                          zodiacInfo.element != null) ...[
                        Spacing.h(6),
                        Row(
                          children: [
                            if (zodiacInfo.rulingPlanet != null) ...[
                              Icon(
                                Icons.star,
                                size: 14.w,
                                color: '#DFB343'.toColor(),
                              ),
                              Spacing.w(4),
                              AutoTranslateText(
                                zodiacInfo.rulingPlanet!,
                                style: MyTextTheme.smallBCN
                                    .copyWith(
                                      color: '#666666'.toColor(),
                                      fontSize: 13.sp,
                                    )
                                    .merge(AppTypography.body2),
                              ),
                            ],
                            if (zodiacInfo.rulingPlanet != null &&
                                zodiacInfo.element != null)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Container(
                                  width: 4.w,
                                  height: 4.w,
                                  decoration: BoxDecoration(
                                    color: '#DFB343'.toColor(),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            if (zodiacInfo.element != null) ...[
                              Icon(
                                Icons.water_drop,
                                size: 14.w,
                                color: '#DFB343'.toColor(),
                              ),
                              Spacing.w(4),
                              AutoTranslateText(
                                zodiacInfo.element!,
                                style: MyTextTheme.smallBCN
                                    .copyWith(
                                      color: '#666666'.toColor(),
                                      fontSize: 13.sp,
                                    )
                                    .merge(AppTypography.body2),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (zodiacInfo.traits != null && zodiacInfo.traits!.isNotEmpty) ...[
              Spacing.h(24),
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      gradient: CarrotAstrologyColors.orangeGradient,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Spacing.w(12),
                  AutoTranslateText(
                    'Traits',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
              Spacing.h(16),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: zodiacInfo.traits!.map((trait) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: ['#FFF2E8'.toColor(), '#FFE5D4'.toColor()],
                      ),
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        color: CarrotAstrologyColors.orangeColor.withOpacity(
                          0.4,
                        ),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CarrotAstrologyColors.orangeColor.withOpacity(
                            0.1,
                          ),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: AutoTranslateText(
                      trait,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (zodiacInfo.vegetableEssence != null &&
                zodiacInfo.vegetableEssence!.isNotEmpty) ...[
              Spacing.h(24),
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      gradient: CarrotAstrologyColors.orangeGradient,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Spacing.w(12),
                  AutoTranslateText(
                    'Vegetable Essence',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
              Spacing.h(12),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: '#FFF2E8'.toColor().withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: CarrotAstrologyColors.orangeColor.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: AutoTranslateText(
                  zodiacInfo.vegetableEssence!,
                  style: MyTextTheme.mediumBCN
                      .copyWith(
                        color: '#3E2723'.toColor(),
                        height: 1.7,
                        fontSize: 14.sp,
                      )
                      .merge(AppTypography.body1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVegetableMatchSection(VegetableMatch vegetableMatch) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              '#DFB343'.toColor().withValues(alpha: 0.15),
              '#FCE5AA'.toColor().withValues(alpha: 0.3),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: '#DFB343'.toColor().withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: '#DFB343'.toColor().withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
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
                    gradient: LinearGradient(
                      colors: [
                        '#DFB343'.toColor(),
                        CarrotAstrologyColors.orangeColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: '#DFB343'.toColor().withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.eco, color: Colors.white, size: 24.w),
                ),
                Spacing.w(12),
                Expanded(
                  child: AutoTranslateText(
                    'Your Vegetable Match',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        )
                        .merge(AppTypography.h2),
                  ),
                ),
              ],
            ),
            if (vegetableMatch.name != null &&
                vegetableMatch.name!.isNotEmpty) ...[
              Spacing.h(20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      '#DFB343'.toColor().withValues(alpha: 0.2),
                      '#FFF2E8'.toColor(),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: '#DFB343'.toColor().withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_dining,
                      color: '#DFB343'.toColor(),
                      size: 20.w,
                    ),
                    Spacing.w(10),
                    Expanded(
                      child: AutoTranslateText(
                        vegetableMatch.name!,
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              color: '#3E2723'.toColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            )
                            .merge(AppTypography.h3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (vegetableMatch.essenceDescription != null &&
                vegetableMatch.essenceDescription!.isNotEmpty) ...[
              Spacing.h(16),
              AutoTranslateText(
                vegetableMatch.essenceDescription!,
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      height: 1.7,
                      fontSize: 14.sp,
                    )
                    .merge(AppTypography.body1),
              ),
            ],
            if (vegetableMatch.symbolism != null &&
                vegetableMatch.symbolism!.isNotEmpty) ...[
              Spacing.h(20),
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: '#DFB343'.toColor().withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: '#DFB343'.toColor(),
                          size: 18.w,
                        ),
                        Spacing.w(8),
                        AutoTranslateText(
                          'Symbolism',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(12),
                    AutoTranslateText(
                      vegetableMatch.symbolism!,
                      style: MyTextTheme.mediumBCN
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            height: 1.7,
                            fontSize: 14.sp,
                          )
                          .merge(AppTypography.body1),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRemediesSection(Remedies remedies) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 24.h,
                decoration: BoxDecoration(
                  gradient: CarrotAstrologyColors.orangeGradient,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Spacing.w(12),
              AutoTranslateText(
                'Remedies & Recommendations',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    )
                    .merge(AppTypography.h2),
              ),
            ],
          ),
          Spacing.h(20),
          if (remedies.food != null && remedies.food!.isNotEmpty) ...[
            _buildRemedyCategoryCard(
              icon: Icons.restaurant_menu,
              title: 'Food Remedies',
              items: remedies.food!,
              color: CarrotAstrologyColors.orangeColor,
            ),
            Spacing.h(16),
          ],
          if (remedies.lifestyle != null && remedies.lifestyle!.isNotEmpty) ...[
            _buildRemedyCategoryCard(
              icon: Icons.fitness_center,
              title: 'Lifestyle',
              items: remedies.lifestyle!,
              color: '#4CAF50'.toColor(),
            ),
            Spacing.h(16),
          ],
          if (remedies.meditation != null &&
              remedies.meditation!.isNotEmpty) ...[
            _buildRemedyCategoryCard(
              icon: Icons.self_improvement,
              title: 'Meditation',
              items: remedies.meditation!,
              color: '#9C27B0'.toColor(),
            ),
            Spacing.h(16),
          ],
          if (remedies.colorStone != null &&
              remedies.colorStone!.isNotEmpty) ...[
            _buildRemedyCategoryCard(
              icon: Icons.color_lens,
              title: 'Colors & Stones',
              items: remedies.colorStone!,
              color: '#2196F3'.toColor(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRemedyCategoryCard({
    required IconData icon,
    required String title,
    required List<String> items,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 0,
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
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.2),
                      color.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, color: color, size: 24.w),
              ),
              Spacing.w(14),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                      )
                      .merge(AppTypography.body2),
                ),
              ),
            ],
          ),
          Spacing.h(20),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < items.length - 1 ? 14.h : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8.h),
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Spacing.w(14),
                  Expanded(
                    child: AutoTranslateText(
                      item,
                      style: MyTextTheme.mediumBCN
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            height: 1.7,
                            fontSize: 14.sp,
                          )
                          .merge(AppTypography.body1),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOverallReadingSection(String overallReading) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, '#FFF2E8'.toColor().withValues(alpha: 0.3)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: CarrotAstrologyColors.orangeColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CarrotAstrologyColors.orangeColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 6),
              spreadRadius: 0,
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
                    gradient: CarrotAstrologyColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: CarrotAstrologyColors.orangeColor.withOpacity(
                          0.3,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                Spacing.w(14),
                Expanded(
                  child: AutoTranslateText(
                    'Overall Reading',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        )
                        .merge(AppTypography.h2),
                  ),
                ),
              ],
            ),
            Spacing.h(20),
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: '#FFF2E8'.toColor().withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: CarrotAstrologyColors.orangeColor.withValues(
                    alpha: 0.2,
                  ),
                ),
              ),
              child: AutoTranslateText(
                overallReading,
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      height: 1.7,
                      fontSize: 14.sp,
                    )
                    .merge(AppTypography.body1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(String summary) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              '#DFB343'.toColor().withValues(alpha: 0.15),
              '#FFF2E8'.toColor(),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: '#DFB343'.toColor().withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: '#DFB343'.toColor().withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
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
                    gradient: LinearGradient(
                      colors: [
                        '#DFB343'.toColor(),
                        CarrotAstrologyColors.orangeColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: '#DFB343'.toColor().withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.summarize, color: Colors.white, size: 24.w),
                ),
                Spacing.w(14),
                Expanded(
                  child: AutoTranslateText(
                    'Summary',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
            Spacing.h(18),
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: AutoTranslateText(
                summary,
                style: MyTextTheme.mediumBCN
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      height: 1.7,
                      fontSize: 14.sp,
                    )
                    .merge(AppTypography.body1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPdf(CarrotAstrologyData result) async {
    final List<PdfSection> sections = [];

    // 1. Zodiac Info
    if (result.zodiacInfo != null) {
      final info = result.zodiacInfo!;
      String content = 'Zodiac Sign: ${info.sign ?? 'N/A'}\n';
      if (info.rulingPlanet != null)
        content += 'Ruling Planet: ${info.rulingPlanet}\n';
      if (info.element != null) content += 'Element: ${info.element}\n';

      sections.add(
        PdfSection(
          title: 'Your Zodiac Profile',
          content: content,
          bulletPoints: info.traits,
          type: info.traits != null && info.traits!.isNotEmpty
              ? PdfSectionType.bullet
              : PdfSectionType.text,
        ),
      );

      if (info.vegetableEssence != null) {
        sections.add(
          PdfSection(
            title: 'Your Vegetable Essence',
            content: info.vegetableEssence!,
          ),
        );
      }
    }

    // 2. Vegetable Match
    if (result.vegetableMatch != null) {
      sections.add(
        PdfSection(
          title:
              'Your Vegetable Match: ${result.vegetableMatch!.name ?? 'N/A'}',
          content:
              '${result.vegetableMatch!.essenceDescription ?? ''}\n\nSymbolism: ${result.vegetableMatch!.symbolism ?? ''}',
        ),
      );
    }

    // 3. Remedies & Recommendations
    final remedies = result.remedies;
    if (remedies != null) {
      if (remedies.food != null && remedies.food!.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Food Remedies',
            content: 'Recommended dietary adjustments:',
            bulletPoints: remedies.food,
            type: PdfSectionType.bullet,
          ),
        );
      }
      if (remedies.lifestyle != null && remedies.lifestyle!.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Lifestyle Advice',
            content: 'Habits for better wellness:',
            bulletPoints: remedies.lifestyle,
            type: PdfSectionType.bullet,
          ),
        );
      }
      if (remedies.meditation != null && remedies.meditation!.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Meditation & Mindfulness',
            content: 'Techniques for mental clarity:',
            bulletPoints: remedies.meditation,
            type: PdfSectionType.bullet,
          ),
        );
      }
      if (remedies.colorStone != null && remedies.colorStone!.isNotEmpty) {
        sections.add(
          PdfSection(
            title: 'Colors & Stones',
            content: 'Harmonizing elements:',
            bulletPoints: remedies.colorStone,
            type: PdfSectionType.bullet,
          ),
        );
      }
    }

    // 4. Overall Reading
    if (result.overallReading != null && result.overallReading!.isNotEmpty) {
      sections.add(
        PdfSection(title: 'Overall Reading', content: result.overallReading!),
      );
    }

    // 5. Summary
    if (result.summary != null && result.summary!.isNotEmpty) {
      sections.add(PdfSection(title: 'Summary', content: result.summary!));
    }

    // Get user metadata
    String? userName;
    if (Get.isRegistered<UserDashboardController>()) {
      userName = Get.find<UserDashboardController>().userName.value;
    }

    /*
    showDialog(
      context: Get.context!,
      builder: (context) => PdfLanguageSelectionDialog(
        onLanguageSelected: (language) async {
          await PdfGeneratorService.generateAstrologyReport(
            title: 'Carrot Astrology Report',
            sections: sections,
            metadata: PdfMetadata(
              userName: userName,
              generatedAt: DateTime.now(),
              reportType: PdfReportType.carrot,
            ),
            languageCode: language.code,
          );
        },
      ),
    );
    */

    // English-only for now (Direct Generation)
    await PdfGeneratorService.generateAstrologyReport(
      title: 'Carrot Astrology Report',
      sections: sections,
      metadata: PdfMetadata(
        userName: userName,
        generatedAt: DateTime.now(),
        reportType: PdfReportType.carrot,
      ),
      languageCode: 'en',
    );
  }
}
