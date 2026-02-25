import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class CompatibilityReportWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic>? formData;
  final bool showProfile;
  final bool showMatchScore;
  final Widget? kundliSection;
  final bool showGunMilan;
  final num? matchScoreTotalOverride;
  final bool showTotalSeparately;
  final num? rawTotal;
  final bool showNavtaraOnly;
  final bool showNavtaraSection;
  final Widget? navtaraWidget;

  const CompatibilityReportWidget({
    super.key,
    required this.data,
    this.formData,
    this.showProfile = true,
    this.showMatchScore = true,
    this.kundliSection,
    this.showGunMilan = true,
    this.matchScoreTotalOverride,
    this.showTotalSeparately = false,
    this.rawTotal,
    this.showNavtaraOnly = false,
    this.showNavtaraSection = true,
    this.navtaraWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Handle response - it can be a String (error) or Map (success)
    final responseValue = data['response'];
    final Map<String, dynamic> response;
    if (responseValue is Map<String, dynamic>) {
      response = responseValue;
    } else if (responseValue is String) {
      // Error case - return error message widget
      return _buildErrorWidget(responseValue);
    } else {
      // Fallback to data itself
      response = data;
    }

    final score = response['score'] as num? ?? 0.0;
    final baseTotal = (matchScoreTotalOverride ?? 36).toDouble();
    final effectiveTotal = rawTotal != null ? rawTotal!.toDouble() : baseTotal;
    // If score is already a percentage (e.g., Western 72/5), use score as percent when score > total
    final percentValue = (score > effectiveTotal && rawTotal != null)
        ? score.round()
        : (effectiveTotal > 0 ? ((score / effectiveTotal) * 100).round() : 0);
    final int finalPercent = percentValue;
    final matchStatus = finalPercent >= 75
        ? 'Good Match'
        : finalPercent >= 50
        ? 'Moderate Match'
        : 'Poor Match';
    final showSeparateTotal =
        showTotalSeparately || (rawTotal != null && score > effectiveTotal);

    // Extract kootas
    final tara = response['tara'] as Map<String, dynamic>?;
    final gana = response['gana'] as Map<String, dynamic>?;
    final yoni = response['yoni'] as Map<String, dynamic>?;
    final bhakoot = response['bhakoot'] as Map<String, dynamic>?;
    final grahamaitri = response['grahamaitri'] as Map<String, dynamic>?;
    final vasya = response['vasya'] as Map<String, dynamic>?;
    final nadi = response['nadi'] as Map<String, dynamic>?;
    final varna = response['varna'] as Map<String, dynamic>?;

    // Extract astro details
    final boyAstroDetails =
        response['boy_astro_details'] as Map<String, dynamic>?;
    final girlAstroDetails =
        response['girl_astro_details'] as Map<String, dynamic>?;

    // Extract bot response
    final botResponse = response['bot_response'] as String? ?? '';

    if (showNavtaraOnly) {
      return navtaraWidget ??
          _buildNavtaraCompatibility(boyAstroDetails, girlAstroDetails);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Section
        if (showProfile) ...[
          _buildProfileSection(boyAstroDetails, girlAstroDetails, response),
          Spacing.h(20),
        ],

        // Match Score
        if (showMatchScore) ...[
          Center(
            child: _buildMatchScore(
              score,
              effectiveTotal,
              finalPercent,
              matchStatus,
              showSeparateTotal,
              rawTotal,
            ),
          ),
          Spacing.h(20),
        ],

        // Navtara Compatibility Section
        if (showNavtaraSection || showNavtaraOnly)
          _buildNavtaraCompatibility(boyAstroDetails, girlAstroDetails),

        Spacing.h(20),

        // Kundli Charts (if provided from parent)
        if (kundliSection != null) ...[kundliSection!, Spacing.h(20)],

        // Strengths and Areas of Attention
        _buildStrengthsAndAttention(response),

        Spacing.h(20),

        // 36 Gun Milan Details
        if (showGunMilan) ...[
          _buildGunMilanDetails(
            tara: tara,
            gana: gana,
            yoni: yoni,
            bhakoot: bhakoot,
            grahamaitri: grahamaitri,
            vasya: vasya,
            nadi: nadi,
            varna: varna,
          ),

          Spacing.h(20),
        ],

        // Manglik Dosha Analysis
        _buildManglikDosha(response),

        Spacing.h(20),

        // AstroBharat AI Conclusion
        if (botResponse.isNotEmpty) _buildAIConclusion(botResponse),
      ],
    );
  }

  Widget _buildProfileSection(
    Map<String, dynamic>? boyDetails,
    Map<String, dynamic>? girlDetails,
    Map<String, dynamic> response,
  ) {
    // Get full response data for planetary details
    final boyPlanetaryDetails =
        response['boy_planetary_details'] as Map<String, dynamic>?;
    final girlPlanetaryDetails =
        response['girl_planetary_details'] as Map<String, dynamic>?;

    // Extract Rashi from bhakoot section (most accurate source)
    final bhakoot = response['bhakoot'] as Map<String, dynamic>?;
    final boyRasiFromBhakoot = bhakoot?['boy_rasi_name'] as String? ?? '';
    final girlRasiFromBhakoot = bhakoot?['girl_rasi_name'] as String? ?? '';

    // Extract data from API response - prefer formData DOB if available
    final boyName = boyDetails?['name'] as String? ?? '';
    // Use formData DOB first, then fallback to API response
    final boyDob =
        formData?['boyDob'] as String? ??
        boyDetails?['dob'] as String? ??
        boyDetails?['birth_dasa_time'] as String? ??
        '';
    // Prefer Rashi from bhakoot, then from astro details
    final boyRasi = boyRasiFromBhakoot.isNotEmpty
        ? boyRasiFromBhakoot
        : (boyDetails?['rasi'] as String? ?? '');
    final boyAscendant =
        boyDetails?['ascendant_sign'] as String? ??
        boyDetails?['ascendant'] as String? ??
        '';

    final girlName = girlDetails?['name'] as String? ?? '';
    // Use formData DOB first, then fallback to API response
    final girlDob =
        formData?['girlDob'] as String? ??
        girlDetails?['dob'] as String? ??
        girlDetails?['birth_dasa_time'] as String? ??
        '';
    // Prefer Rashi from bhakoot, then from astro details
    final girlRasi = girlRasiFromBhakoot.isNotEmpty
        ? girlRasiFromBhakoot
        : (girlDetails?['rasi'] as String? ?? '');
    final girlAscendant =
        girlDetails?['ascendant_sign'] as String? ??
        girlDetails?['ascendant'] as String? ??
        '';

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3E6), // Light beige from image
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Girl Profile (Left)
          Expanded(
            child: Column(
              children: [
                ClipOval(
                  child: Image.network(
                    AppConstant.kundliGirl,
                    width: 70.w,
                    height: 70.w,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.deepOrange.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40.w,
                          color: '#68171E'.toColor(),
                        ),
                      );
                    },
                  ),
                ),
                Spacing.h(8),
                AutoTranslateText(
                  girlName,
                  style: AppTypography.body1.copyWith(
                    color: "#6F221E".toColor(),
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacing.h(4),
                AutoTranslateText(
                  girlDob,
                  style: AppTypography.label.copyWith(
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (girlRasi.isNotEmpty || girlAscendant.isNotEmpty) ...[
                  Spacing.h(8),
                  // Zodiac signs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (girlRasi.isNotEmpty) ...[
                        _buildZodiacIcon(girlRasi),
                        Spacing.w(8),
                      ],
                      if (girlAscendant.isNotEmpty)
                        _buildZodiacIcon(girlAscendant),
                    ],
                  ),
                ],
                Spacing.h(8),
                TextButton(
                  onPressed: () {
                    // Navigate to Girl Full Kundli
                    UserMainController.pushInCurrentTab(
                      AppRoutes.matchMakingFullKundli,
                      arguments: {
                        'isBoy': false,
                        'astroDetails': girlDetails ?? {},
                        'planetaryDetails': girlPlanetaryDetails ?? {},
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: AutoTranslateText(
                    'View Full Kundli',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.deepOrange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Heart Icon (Center)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.favorite, color: Colors.orange, size: 32.w),
            ),
          ),

          // Boy Profile (Right)
          Expanded(
            child: Column(
              children: [
                ClipOval(
                  child: Image.network(
                    AppConstant.kundliBoy,
                    width: 70.w,
                    height: 70.w,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.deepOrange.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40.w,
                          color: '#68171E'.toColor(),
                        ),
                      );
                    },
                  ),
                ),
                Spacing.h(8),
                AutoTranslateText(
                  boyName,
                  style: AppTypography.body1.copyWith(
                    color: "#6F221E".toColor(),
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacing.h(4),
                AutoTranslateText(
                  boyDob,
                  style: AppTypography.label.copyWith(
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (boyRasi.isNotEmpty || boyAscendant.isNotEmpty) ...[
                  Spacing.h(8),
                  // Zodiac signs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (boyRasi.isNotEmpty) ...[
                        _buildZodiacIcon(boyRasi),
                        Spacing.w(8),
                      ],
                      if (boyAscendant.isNotEmpty)
                        _buildZodiacIcon(boyAscendant),
                    ],
                  ),
                ],
                Spacing.h(8),
                TextButton(
                  onPressed: () {
                    // Navigate to Boy Full Kundli
                    UserMainController.pushInCurrentTab(
                      AppRoutes.matchMakingFullKundli,
                      arguments: {
                        'isBoy': true,
                        'astroDetails': boyDetails ?? {},
                        'planetaryDetails': boyPlanetaryDetails ?? {},
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: AutoTranslateText(
                    'View Full Kundli',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.deepOrange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacIcon(String sign) {
    // Map zodiac signs to emoji or icons (handle both lowercase and capitalized)
    final zodiacIcons = {
      'aries': '♈',
      'taurus': '♉',
      'gemini': '♊',
      'cancer': '♋',
      'leo': '♌',
      'virgo': '♍',
      'libra': '♎',
      'scorpio': '♏',
      'sagittarius': '♐',
      'capricorn': '♑',
      'aquarius': '♒',
      'pisces': '♓',
    };

    // Convert to lowercase for lookup
    final signLower = sign.toLowerCase();
    final icon = zodiacIcons[signLower] ?? '⭐';

    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: "#DFB343".toColor().withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(child: AutoTranslateText(icon, style: AppTypography.h3)),
    );
  }

  Widget _buildMatchScore(
    num score,
    num totalScore,
    int percentage,
    String matchStatus,
    bool showSeparateTotal,
    num? rawTotal,
  ) {
    final displayScore = score.toStringAsFixed(0);
    final displayTotal = rawTotal?.toString() ?? totalScore.toStringAsFixed(0);
    final progressValue = totalScore > 0
        ? (score / totalScore).clamp(0, 1).toDouble()
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140.w,
          height: 140.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140.w,
                height: 140.w,
                child: CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 14,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage >= 75
                        ? Colors.green
                        : percentage >= 50
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoTranslateText(
                    showSeparateTotal
                        ? displayScore
                        : '${score.toStringAsFixed(0)}/${totalScore.toInt()}',
                    style: MyTextTheme.largeBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    'Gun Milan',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor().withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacing.h(20),
        AutoTranslateText(
          '$percentage%',
          style: AppTypography.h1.copyWith(
            color: percentage >= 75
                ? Colors.purple
                : percentage >= 50
                ? Colors.orange
                : Colors.red,
          ),
        ),
        Spacing.h(4),
        AutoTranslateText(
          matchStatus,
          style: MyTextTheme.mediumBCB.copyWith(
            color: percentage >= 75
                ? Colors.purple
                : percentage >= 50
                ? Colors.orange
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showSeparateTotal) ...[
          Spacing.h(6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF3E6),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.deepOrange.withValues(alpha: 0.3),
              ),
            ),
            child: AutoTranslateText(
              'Total: $displayTotal',
              style: MyTextTheme.smallBCB.copyWith(color: "#6F221E".toColor()),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGunMilanDetails({
    Map<String, dynamic>? tara,
    Map<String, dynamic>? gana,
    Map<String, dynamic>? yoni,
    Map<String, dynamic>? bhakoot,
    Map<String, dynamic>? grahamaitri,
    Map<String, dynamic>? vasya,
    Map<String, dynamic>? nadi,
    Map<String, dynamic>? varna,
  }) {
    final kootas = [
      if (varna != null)
        _KootaData(
          name: 'Varna',
          displayName: 'Varna',
          score: (varna['varna'] as num? ?? 0).toDouble(),
          fullScore: (varna['full_score'] as num? ?? 1).toDouble(),
          description: varna['description'] as String? ?? '',
          boyInfo: (varna['boy_varna'] ?? '').toString(),
          girlInfo: (varna['girl_varna'] ?? '').toString(),
        ),
      if (vasya != null)
        _KootaData(
          name: 'Vasya',
          displayName: 'Vashya',
          score: (vasya['vasya'] as num? ?? 0).toDouble(),
          fullScore: (vasya['full_score'] as num? ?? 2).toDouble(),
          description: vasya['description'] as String? ?? '',
          boyInfo: (vasya['boy_vasya'] ?? '').toString(),
          girlInfo: (vasya['girl_vasya'] ?? '').toString(),
        ),
      if (tara != null)
        _KootaData(
          name: 'Tara',
          displayName: 'Tara',
          score: (tara['tara'] as num? ?? 0).toDouble(),
          fullScore: (tara['full_score'] as num? ?? 3).toDouble(),
          description: tara['description'] as String? ?? '',
          boyInfo: (tara['boy_tara'] ?? '').toString(),
          girlInfo: (tara['girl_tara'] ?? '').toString(),
        ),
      if (yoni != null)
        _KootaData(
          name: 'Yoni',
          displayName: 'Yoni',
          score: (yoni['yoni'] as num? ?? 0).toDouble(),
          fullScore: (yoni['full_score'] as num? ?? 4).toDouble(),
          description: yoni['description'] as String? ?? '',
          boyInfo: (yoni['boy_yoni'] ?? '').toString(),
          girlInfo: (yoni['girl_yoni'] ?? '').toString(),
        ),
      if (grahamaitri != null)
        _KootaData(
          name: 'Grahamaitri',
          displayName: 'Graha Maitri',
          score: (grahamaitri['grahamaitri'] as num? ?? 0).toDouble(),
          fullScore: (grahamaitri['full_score'] as num? ?? 5).toDouble(),
          description: grahamaitri['description'] as String? ?? '',
          boyInfo: (grahamaitri['boy_lord'] ?? '').toString(),
          girlInfo: (grahamaitri['girl_lord'] ?? '').toString(),
        ),
      if (gana != null)
        _KootaData(
          name: 'Gana',
          displayName: 'Gana',
          score: (gana['gana'] as num? ?? 0).toDouble(),
          fullScore: (gana['full_score'] as num? ?? 6).toDouble(),
          description: gana['description'] as String? ?? '',
          boyInfo: (gana['boy_gana'] ?? '').toString(),
          girlInfo: (gana['girl_gana'] ?? '').toString(),
        ),
      if (bhakoot != null)
        _KootaData(
          name: 'Bhakoot',
          displayName: 'Bhakoot',
          score: (bhakoot['bhakoot'] as num? ?? 0).toDouble(),
          fullScore: (bhakoot['full_score'] as num? ?? 7).toDouble(),
          description: bhakoot['description'] as String? ?? '',
          boyInfo: (bhakoot['boy_rasi_name'] ?? bhakoot['boy_rasi'] ?? '')
              .toString(),
          girlInfo: (bhakoot['girl_rasi_name'] ?? bhakoot['girl_rasi'] ?? '')
              .toString(),
        ),
      if (nadi != null)
        _KootaData(
          name: 'Nadi',
          displayName: 'Nadi',
          score: (nadi['nadi'] as num? ?? 0).toDouble(),
          fullScore: (nadi['full_score'] as num? ?? 8).toDouble(),
          description: nadi['description'] as String? ?? '',
          boyInfo: (nadi['boy_nadi'] ?? '').toString(),
          girlInfo: (nadi['girl_nadi'] ?? '').toString(),
        ),
    ];

    return _ExpandableSection(
      title: '36 Gun Milan Details',
      subtitle: '8 Kootas Analysis',
      icon: Icons.star,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacing.h(12),
          ...kootas.map((koota) => _buildKootaRow(koota)),
        ],
      ),
    );
  }

  Widget _buildKootaRow(_KootaData koota) {
    final isComplete = koota.score >= koota.fullScore;
    final isPartial = koota.score > 0 && koota.score < koota.fullScore;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: "#DFB343".toColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isComplete
                      ? Icons.check_circle
                      : isPartial
                      ? Icons.warning
                      : Icons.cancel,
                  color: isComplete
                      ? Colors.green
                      : isPartial
                      ? Colors.orange
                      : Colors.red,
                  size: 20.w,
                ),
                Spacing.w(12),
                Expanded(
                  child: AutoTranslateText(
                    koota.displayName,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#6F221E".toColor(),
                    ),
                  ),
                ),
                AutoTranslateText(
                  '${koota.score.toInt()}/${koota.fullScore.toInt()}',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: isComplete
                        ? Colors.green
                        : isPartial
                        ? Colors.orange
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(8),
            AutoTranslateText(
              koota.description,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
            Spacing.h(8),
            Row(
              children: [
                Expanded(child: _buildKootaInfoTile('Boy', koota.boyInfo)),
                Spacing.w(8),
                Expanded(child: _buildKootaInfoTile('Girl', koota.girlInfo)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKootaInfoTile(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3E6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(color: "#6F221E".toColor()),
          ),
          Spacing.h(4),
          AutoTranslateText(
            value,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsAndAttention(Map<String, dynamic> response) {
    final strengths = <String>[];
    final attention = <String>[];

    // Analyze kootas for strengths and attention areas
    final gana = response['gana'] as Map<String, dynamic>?;
    final nadi = response['nadi'] as Map<String, dynamic>?;
    final bhakoot = response['bhakoot'] as Map<String, dynamic>?;
    final tara = response['tara'] as Map<String, dynamic>?;

    if (bhakoot != null && (bhakoot['bhakoot'] as num? ?? 0) > 0) {
      strengths.add('Favorable destiny and health aspects');
      strengths.add('Good Bhakoot alignment for prosperity');
    }
    if (tara != null && (tara['tara'] as num? ?? 0) > 0) {
      strengths.add('Strong spiritual and mental compatibility');
    }

    if (gana != null && (gana['gana'] as num? ?? 0) == 0) {
      attention.add('Gana mismatch requires understanding');
    }
    if (nadi != null) {
      final nadiScore = (nadi['nadi'] as num? ?? 0).toDouble();
      final nadiFull = (nadi['full_score'] as num? ?? 8).toDouble();
      if (nadiScore < nadiFull) {
        attention.add('Partial Nadi score suggests health precautions');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (strengths.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Light green
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: AppColors.deepOrange,
                      size: 20.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Strengths',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#68171E'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                ...strengths.map(
                  (strength) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          margin: EdgeInsets.only(top: 6.h, right: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: AutoTranslateText(
                            strength,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: Colors.green,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(16),
        ],
        if (attention.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0), // Light yellow from image
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20.w),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Areas of Attention',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                ...attention.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          margin: EdgeInsets.only(top: 6.h, right: 12.w),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: AutoTranslateText(
                            item,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: Colors.orange,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildManglikDosha(Map<String, dynamic> response) {
    // Check for Manglik Dosha in planetary details from API
    final boyPlanetaryDetails =
        response['boy_planetary_details'] as Map<String, dynamic>?;
    final girlPlanetaryDetails =
        response['girl_planetary_details'] as Map<String, dynamic>?;

    bool boyHasDosh = false;
    bool girlHasDosh = false;
    String boyDoshText = 'Non-Manglik';
    String girlDoshText = 'Non-Manglik';
    String boyDoshDescription =
        'Mars is favorably placed. No Manglik Dosha detected.';
    String girlDoshDescription =
        'Mars is favorably placed. No Manglik Dosha detected.';

    // Check boy's Mars placement
    if (boyPlanetaryDetails != null) {
      final mars = boyPlanetaryDetails['3'] as Map<String, dynamic>?;
      if (mars != null) {
        final house = mars['house'] as int?;
        if (house != null &&
            (house == 1 ||
                house == 4 ||
                house == 7 ||
                house == 8 ||
                house == 12)) {
          boyHasDosh = true;
          if (house == 7) {
            boyDoshText = 'Groom Kundli Dosh';
            boyDoshDescription =
                'Mars in 7th house. Partial Manglik Dosha present.';
          } else {
            boyDoshText = 'Groom Kundli Dosh';
            boyDoshDescription = 'Mars in $house house. Manglik Dosha present.';
          }
        }
      }
    }

    // Check girl's Mars placement
    if (girlPlanetaryDetails != null) {
      final mars = girlPlanetaryDetails['3'] as Map<String, dynamic>?;
      if (mars != null) {
        final house = mars['house'] as int?;
        if (house != null &&
            (house == 1 ||
                house == 4 ||
                house == 7 ||
                house == 8 ||
                house == 12)) {
          girlHasDosh = true;
          if (house == 7) {
            girlDoshText = 'Bride Kundli Dosh';
            girlDoshDescription =
                'Mars in 7th house. Partial Manglik Dosha present.';
          } else {
            girlDoshText = 'Bride Kundli Dosh';
            girlDoshDescription =
                'Mars in $house house. Manglik Dosha present.';
          }
        }
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: AppColors.deepOrange,
                size: 20.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Manglik Dosha Analysis',
                style: MyTextTheme.largeBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacing.h(4),
          AutoTranslateText(
            'Mars placement check',
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.7),
            ),
          ),
          Spacing.h(16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: !boyHasDosh
                        ? const Color(0xFFE8F5E9) // Light green background
                        : const Color(0xFFFFF3E0), // Light orange background
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: !boyHasDosh
                          ? Colors.green.withValues(alpha: 0.3)
                          : Colors.orange.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        boyDoshText,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: !boyHasDosh ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacing.h(8),
                      AutoTranslateText(
                        boyDoshDescription,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: '#68171E'.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacing.w(12),
              Icon(Icons.favorite, color: Colors.red, size: 24.w),
              Spacing.w(12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: !girlHasDosh
                        ? const Color(0xFFE8F5E9) // Light green background
                        : const Color(0xFFFFF3E0), // Light orange background
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: !girlHasDosh
                          ? Colors.green.withValues(alpha: 0.3)
                          : Colors.orange.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        girlDoshText,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: !girlHasDosh ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacing.h(8),
                      AutoTranslateText(
                        girlDoshDescription,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: '#68171E'.toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(16),
          SizedBox(
            width: double.infinity,
            height: 45.h,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to remedies page
                UserMainController.pushInCurrentTab(
                  AppRoutes.dosh,
                  arguments: {
                    'source': 'matchMakingRemedies',
                    'response': response,
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.deepOrange, width: 1.5),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              child: AutoTranslateText(
                'View Recommended Remedies',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: AppColors.deepOrange,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIConclusion(String botResponse) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: AppColors.deepOrange, size: 20.w),
              Spacing.w(8),
              SvgPicture.network(
                'https://astrobharatai.s3.ap-south-1.amazonaws.com/homepageVideos/Frame+1321314931.svg',
                height: 24.h,
                fit: BoxFit.contain,
              ),
              Spacing.w(4),
              Expanded(
                child: AutoTranslateText(
                  'Conclusion',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            botResponse,
            style: MyTextTheme.mediumBCN.copyWith(
              color: '#68171E'.toColor(),
              height: 1.5,
            ),
          ),
          Spacing.h(16),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to astrologers list for marriage expert chat
                UserMainController.pushInCurrentTab(
                  AppRoutes.allAstrologers,
                  arguments: {'source': 'matchMakingChat'},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: '#F38B3B'.toColor().withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: AutoTranslateText(
                        'Chat with Marriage expert Astrologer',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacing.w(8),
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.w, color: Colors.red),
          Spacing.h(16),
          AutoTranslateText(
            'Error',
            style: MyTextTheme.largeBCB.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          AutoTranslateText(
            errorMessage,
            textAlign: TextAlign.center,
            style: MyTextTheme.mediumBCN.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildNavtaraCompatibility(
    Map<String, dynamic>? boyAstro,
    Map<String, dynamic>? girlAstro,
  ) {
    if (!Get.isRegistered<NavtaraController>()) return const SizedBox.shrink();
    final navtaraController = Get.find<NavtaraController>();

    String extract(dynamic data) {
      if (data == null) return '';
      final potentialKeys = [
        'nakshatra',
        'nakshatra_name',
        'nakshtra',
        'nakshtra_name',
        'birth_nakshatra',
      ];

      if (data is Map) {
        for (final key in potentialKeys) {
          if (data.containsKey(key)) {
            final val = data[key];
            if (val is String && val.isNotEmpty && val != '-') return val;
            if (val is Map && val.containsKey('name')) {
              final name = val['name'].toString();
              if (name.isNotEmpty && name != '-') return name;
            }
          }
        }
        // Deep scan if not found in top level
        for (final val in data.values) {
          final res = extract(val);
          if (res.isNotEmpty) return res;
        }
      } else if (data is List) {
        for (final item in data) {
          final res = extract(item);
          if (res.isNotEmpty) return res;
        }
      }
      return '';
    }

    final boyNakshatra = extract(boyAstro);
    final girlNakshatra = extract(girlAstro);

    if (boyNakshatra.isEmpty || girlNakshatra.isEmpty)
      return const SizedBox.shrink();

    // Initialize if not already set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navtaraController.primaryNakshatra.value != boyNakshatra ||
          navtaraController.secondaryNakshatra.value != girlNakshatra) {
        navtaraController.initFromMatching(
          boyName: boyAstro?['name'] ?? 'Boy',
          boyNakshatra: boyNakshatra,
          girlName: girlAstro?['name'] ?? 'Girl',
          girlNakshatra: girlNakshatra,
        );
      }
    });

    return Obx(() {
      final compatibility = navtaraController.compatibility.value;
      if (navtaraController.isLoading.value && compatibility == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (compatibility == null) return const SizedBox.shrink();

      final analysis = compatibility.compatibilityAnalysis;

      return _ExpandableSection(
        title: 'Nakshatra Compatibility (Navtara)',
        subtitle: 'Deeper Nakshatra Analysis',
        icon: Icons.favorite,
        child: Column(
          children: [
            Spacing.h(16),
            // Compatibility Score
            Center(
              child: Column(
                children: [
                  AutoTranslateText(
                    '${analysis.compatibilityScore.toInt()}%',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.deepOrange,
                    ),
                  ),
                  AutoTranslateText(
                    analysis.compatibilityLevel,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.h(20),

            // Categories
            _buildNavtaraCategoryTile('Boy to Girl', analysis.person1ToPerson2),
            Spacing.h(12),
            _buildNavtaraCategoryTile('Girl to Boy', analysis.person2ToPerson1),

            Spacing.h(20),
            _buildCompatibilityList(
              'Strengths',
              analysis.strengths,
              Colors.green,
            ),
            Spacing.h(12),
            _buildCompatibilityList(
              'Challenges',
              analysis.challenges,
              Colors.orange,
            ),

            Spacing.h(20),
            _buildAdviceCard('Advice', analysis.advice),
            Spacing.h(16),
          ],
        ),
      );
    });
  }

  Widget _buildNavtaraCategoryTile(
    String title,
    CompatibilityCategory category,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF3E6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  title,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#6F221E".toColor(),
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  '${category.category} (${category.nature})',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withValues(alpha: 0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.deepOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: AutoTranslateText(
              '${category.favorability}%',
              style: MyTextTheme.smallBCB.copyWith(color: AppColors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityList(
    String title,
    List<String> items,
    Color color,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          title,
          style: MyTextTheme.mediumBCB.copyWith(color: color),
        ),
        Spacing.h(8),
        ...items
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, size: 14.w, color: color),
                    Spacing.w(8),
                    Expanded(
                      child: AutoTranslateText(
                        item,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor().withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildAdviceCard(String title, String advice) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.deepOrange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.deepOrange,
                size: 20.w,
              ),
              Spacing.w(8),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(10),
          AutoTranslateText(
            advice,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor(),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _KootaData {
  final String name;
  final String displayName;
  final double score;
  final double fullScore;
  final String description;
  final String boyInfo;
  final String girlInfo;

  _KootaData({
    required this.name,
    required this.displayName,
    required this.score,
    required this.fullScore,
    required this.description,
    required this.boyInfo,
    required this.girlInfo,
  });
}

class _ExpandableSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  const _ExpandableSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Icon(widget.icon, color: AppColors.deepOrange, size: 20.w),
                Spacing.w(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        widget.title,
                        style: MyTextTheme.largeBCB.copyWith(
                          color: '#68171E'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacing.h(2),
                      AutoTranslateText(
                        widget.subtitle,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: "#6F221E".toColor().withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: "#6F221E".toColor(),
                  size: 24.w,
                ),
              ],
            ),
          ),
          if (_isExpanded) widget.child,
        ],
      ),
    );
  }
}
