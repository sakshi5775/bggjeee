import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:astrobharataiuser/screens/navtara/widgets/navtara_compatibility_widget.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
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
  final bool showDashakootGunMilan;
  final num? matchScoreTotalOverride;
  final bool showTotalSeparately;
  final num? rawTotal;
  final bool showNavtaraOnly;
  final bool showNavtaraSection;
  final Widget? navtaraWidget;
  final String matchLabel;
  final String chartStyleForFullKundli;
  final bool showScoreAsPercentage;

  const CompatibilityReportWidget({
    super.key,
    required this.data,
    this.formData,
    this.showProfile = true,
    this.showMatchScore = true,
    this.kundliSection,
    this.showGunMilan = true,
    this.showDashakootGunMilan = false,
    this.matchScoreTotalOverride,
    this.showTotalSeparately = false,
    this.rawTotal,
    this.showNavtaraOnly = false,
    this.showNavtaraSection = true,
    this.navtaraWidget,
    this.matchLabel = 'Gun Milan',
    this.chartStyleForFullKundli = 'north',
    this.showScoreAsPercentage = false,
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
    // Cap score at total so we never display e.g. 12/10
    final cappedScore = effectiveTotal > 0
        ? score.toDouble().clamp(0.0, effectiveTotal)
        : 0.0;
    // Calculate percentage - cap at 100%
    final percentValue = effectiveTotal > 0
        ? ((cappedScore / effectiveTotal) * 100).round().clamp(0, 100)
        : 0;
    final int finalPercent = percentValue;
    final matchStatus = finalPercent >= 75
        ? 'Good Match'
        : finalPercent >= 50
        ? 'Moderate Match'
        : 'Poor Match';
    final showSeparateTotal =
        showTotalSeparately || (rawTotal != null && score > effectiveTotal);
    final botResponse = response['bot_response'] as String? ?? '';
    final statusText = botResponse.isNotEmpty ? botResponse : matchStatus;

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
              cappedScore,
              effectiveTotal,
              finalPercent,
              statusText,
              showSeparateTotal,
              rawTotal,
              matchLabel,
              showScoreAsPercentage: showScoreAsPercentage,
            ),
          ),
          Spacing.h(20),
        ],

        // Aggregate Match – all API fields
        if (response.containsKey('ashtakoot_score')) ...[
          _buildAggregateDetails(response),
          Spacing.h(20),
        ],

        // Rajju Vedha Details
        if (response.containsKey('is_rajju_dosha_present')) ...[
          _buildRajjuVedhaDetails(response),
          Spacing.h(20),
        ],

        // Papasamaya Match – all API fields
        if (response.containsKey('boy_papa')) ...[
          _buildPapasamayaDetails(response),
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

        // 36 Gun Milan Details (Ashtakoot)
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

        // 10 Gun Milan Details (Dashakoot)
        if (showDashakootGunMilan) ...[
          _buildDashakootGunMilanDetails(response),
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

    // Extract data from API response - prefer formData name/DOB if available
    final boyName =
        formData?['boyName'] as String? ?? boyDetails?['name'] as String? ?? '';
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

    final girlName =
        formData?['girlName'] as String? ??
        girlDetails?['name'] as String? ??
        '';
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
                NetworkImageWithLoader(
                  url: AppConstant.kundliGirl,
                  height: 70.w,
                  width: 70.w,
                  fit: BoxFit.cover,
                  isCircular: true,
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
                    UserMainController.pushInCurrentTab(
                      AppRoutes.matchMakingFullKundli,
                      arguments: {
                        'isBoy': false,
                        'astroDetails': girlDetails ?? {},
                        'planetaryDetails': girlPlanetaryDetails ?? {},
                        'formData': formData,
                        'chartStyle': chartStyleForFullKundli,
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
                NetworkImageWithLoader(
                  url: AppConstant.kundliBoy,
                  width: 70.w,
                  height: 70.w,
                  fit: BoxFit.cover,
                  isCircular: true,
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
                    UserMainController.pushInCurrentTab(
                      AppRoutes.matchMakingFullKundli,
                      arguments: {
                        'isBoy': true,
                        'astroDetails': boyDetails ?? {},
                        'planetaryDetails': boyPlanetaryDetails ?? {},
                        'formData': formData,
                        'chartStyle': chartStyleForFullKundli,
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
    String matchLabel, {
    bool showScoreAsPercentage = false,
  }) {
    // Ensure displayed score never exceeds total (e.g. never 12/10)
    final safeScore = totalScore > 0
        ? score.toDouble().clamp(0.0, totalScore.toDouble())
        : 0.0;
    final displayScore = safeScore.toStringAsFixed(
      safeScore == safeScore.roundToDouble() ? 0 : 1,
    );
    final displayTotal = rawTotal?.toString() ?? totalScore.toStringAsFixed(0);
    final progressValue = totalScore > 0
        ? (safeScore / totalScore).clamp(0.0, 1.0).toDouble()
        : 0.0;

    final centerText = showScoreAsPercentage
        ? '$displayScore%'
        : showSeparateTotal
        ? displayScore
        : '$displayScore/$displayTotal';

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
                    centerText,
                    style: MyTextTheme.largeBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    matchLabel,
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
        if (!showScoreAsPercentage)
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
        if (!showScoreAsPercentage) Spacing.h(4),
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
          maxLines: 3,
          textAlign: TextAlign.center,
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

  Widget _buildDashakootGunMilanDetails(Map<String, dynamic> response) {
    final keys = [
      'dina',
      'gana',
      'mahendra',
      'sthree',
      'yoni',
      'rasi',
      'rasiathi',
      'vasya',
      'rajju',
      'vedha',
    ];
    final kootas = <_KootaData>[];
    for (final key in keys) {
      final m = response[key] as Map<String, dynamic>?;
      if (m == null) continue;
      final score = (m[key] as num? ?? 0).toDouble();
      final fullScore = (m['full_score'] as num? ?? 1).toDouble();
      final description = (m['description'] ?? '').toString();
      final name = (m['name'] ?? key).toString();
      String boyInfo = '';
      String girlInfo = '';
      if (m.containsKey('boy_star')) {
        boyInfo = (m['boy_star'] ?? '').toString();
        girlInfo = (m['girl_star'] ?? '').toString();
      } else if (m.containsKey('boy_gana')) {
        boyInfo = (m['boy_gana'] ?? '').toString();
        girlInfo = (m['girl_gana'] ?? '').toString();
      } else if (m.containsKey('boy_yoni')) {
        boyInfo = (m['boy_yoni'] ?? '').toString();
        girlInfo = (m['girl_yoni'] ?? '').toString();
      } else if (m.containsKey('boy_rasi') && !m.containsKey('boy_lord')) {
        boyInfo = (m['boy_rasi'] ?? '').toString();
        girlInfo = (m['girl_rasi'] ?? '').toString();
      } else if (m.containsKey('boy_lord')) {
        boyInfo = (m['boy_lord'] ?? '').toString();
        girlInfo = (m['girl_lord'] ?? '').toString();
      } else if (m.containsKey('boy_rajju')) {
        boyInfo = (m['boy_rajju'] ?? '').toString();
        girlInfo = (m['girl_rajju'] ?? '').toString();
      }
      kootas.add(
        _KootaData(
          name: key,
          displayName: name,
          score: score,
          fullScore: fullScore,
          description: description,
          boyInfo: boyInfo,
          girlInfo: girlInfo,
        ),
      );
    }
    return _ExpandableSection(
      title: '10 Gun Milan Details (Dashakoot)',
      subtitle: '10 Kootas Analysis',
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

  Widget _buildAggregateDetails(Map<String, dynamic> response) {
    final ashtakoot = response['ashtakoot_score']?.toString() ?? '–';
    final dashkoot = response['dashkoot_score']?.toString() ?? '–';
    final score = response['score']?.toString() ?? '–';
    final extended = response['extended_response']?.toString();
    final items = <_LabelValue>[
      _LabelValue('Ashtakoot Score', ashtakoot),
      _LabelValue('Dashkoot Score', dashkoot),
      _LabelValue('Compatibility Score', '$score/100'),
      _LabelValue(
        'Rajju Dosha',
        (response['rajjudosh'] == true) ? 'Present' : 'Absent',
      ),
      _LabelValue(
        'Vedha Dosha',
        (response['vedhadosh'] == true) ? 'Present' : 'Absent',
      ),
    ];
    final mangaldosh = response['mangaldosh']?.toString();
    if (mangaldosh != null && mangaldosh.isNotEmpty) {
      items.add(_LabelValue('Mangal Dosha', mangaldosh));
      final pts = response['mangaldosh_points'] as Map<String, dynamic>?;
      if (pts != null) {
        items.add(
          _LabelValue('Mangal Dosha (Boy)', pts['boy']?.toString() ?? '–'),
        );
        items.add(
          _LabelValue('Mangal Dosha (Girl)', pts['girl']?.toString() ?? '–'),
        );
      }
    }
    final pitradosh = response['pitradosh']?.toString();
    if (pitradosh != null && pitradosh.isNotEmpty) {
      items.add(_LabelValue('Pitra Dosha', pitradosh));
      final pts = response['pitradosh_points'] as Map<String, dynamic>?;
      if (pts != null) {
        items.add(
          _LabelValue('Pitra Dosha (Boy)', pts['boy'] == true ? 'Yes' : 'No'),
        );
        items.add(
          _LabelValue('Pitra Dosha (Girl)', pts['girl'] == true ? 'Yes' : 'No'),
        );
      }
    }
    final kaalsarp = response['kaalsarpdosh']?.toString();
    if (kaalsarp != null && kaalsarp.isNotEmpty) {
      items.add(_LabelValue('Kaal Sarp Dosha', kaalsarp));
      final pts = response['kaalsarp_points'] as Map<String, dynamic>?;
      if (pts != null) {
        items.add(
          _LabelValue('Kaal Sarp (Boy)', pts['boy'] == true ? 'Yes' : 'No'),
        );
        items.add(
          _LabelValue('Kaal Sarp (Girl)', pts['girl'] == true ? 'Yes' : 'No'),
        );
      }
    }
    final manglikSaturn = response['manglikdosh_saturn']?.toString();
    if (manglikSaturn != null && manglikSaturn.isNotEmpty) {
      items.add(_LabelValue('Manglik Dosha (Saturn)', manglikSaturn));
      final pts =
          response['manglikdosh_saturn_points'] as Map<String, dynamic>?;
      if (pts != null) {
        items.add(
          _LabelValue(
            'Manglik Saturn (Boy)',
            pts['boy'] == true ? 'Yes' : 'No',
          ),
        );
        items.add(
          _LabelValue(
            'Manglik Saturn (Girl)',
            pts['girl'] == true ? 'Yes' : 'No',
          ),
        );
      }
    }
    final manglikRK = response['manglikdosh_rahuketu']?.toString();
    if (manglikRK != null && manglikRK.isNotEmpty) {
      items.add(_LabelValue('Manglik Dosha (Rahu-Ketu)', manglikRK));
      final pts =
          response['manglikdosh_rahuketu_points'] as Map<String, dynamic>?;
      if (pts != null) {
        items.add(
          _LabelValue(
            'Manglik Rahu-Ketu (Boy)',
            pts['boy'] == true ? 'Yes' : 'No',
          ),
        );
        items.add(
          _LabelValue(
            'Manglik Rahu-Ketu (Girl)',
            pts['girl'] == true ? 'Yes' : 'No',
          ),
        );
      }
    }
    if (extended != null && extended.isNotEmpty) {
      items.add(_LabelValue('Extended Response', extended));
    }

    return _ExpandableSection(
      title: 'Aggregate Match Details',
      subtitle: 'Scores and dosha from API',
      icon: Icons.analytics,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h(12),
          ...items.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 160.w,
                    child: AutoTranslateText(
                      e.label,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: "#6F221E".toColor(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      e.value,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRajjuVedhaDetails(Map<String, dynamic> response) {
    final rajju = response['is_rajju_dosha_present'] == true;
    final vedha = response['is_vedha_dosha_present'] == true;
    return _ExpandableSection(
      title: 'Rajju & Vedha Details',
      subtitle: 'From API',
      icon: Icons.info_outline,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h(12),
          _buildKeyValueRow('Rajju Dosha Present', rajju ? 'Yes' : 'No'),
          Spacing.h(8),
          _buildKeyValueRow('Vedha Dosha Present', vedha ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  Widget _buildKeyValueRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160.w,
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(color: "#6F221E".toColor()),
          ),
        ),
        Expanded(
          child: AutoTranslateText(
            value,
            style: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPapasamayaDetails(Map<String, dynamic> response) {
    final boyPapa = response['boy_papa'] as Map<String, dynamic>?;
    final girlPapa = response['girl_papa'] as Map<String, dynamic>?;
    final boyTotal = response['boy_total']?.toString() ?? '–';
    final girlTotal = response['girl_total']?.toString() ?? '–';
    final score = response['score']?.toString() ?? '–';
    final botResponse = response['bot_response']?.toString() ?? '';

    final children = <Widget>[
      Spacing.h(12),
      _buildKeyValueRow('Boy total', boyTotal),
      Spacing.h(8),
      _buildKeyValueRow('Girl total', girlTotal),
      Spacing.h(8),
      _buildKeyValueRow('Score', score),
    ];
    if (boyPapa != null && boyPapa.isNotEmpty) {
      children.add(Spacing.h(12));
      children.add(
        AutoTranslateText(
          'Boy Papa',
          style: MyTextTheme.smallBCB.copyWith(color: "#6F221E".toColor()),
        ),
      );
      for (final e in boyPapa.entries) {
        children.add(
          Padding(
            padding: EdgeInsets.only(left: 12.w, top: 4.h),
            child: _buildKeyValueRow(e.key, e.value?.toString() ?? '–'),
          ),
        );
      }
    }
    if (girlPapa != null && girlPapa.isNotEmpty) {
      children.add(Spacing.h(12));
      children.add(
        AutoTranslateText(
          'Girl Papa',
          style: MyTextTheme.smallBCB.copyWith(color: "#6F221E".toColor()),
        ),
      );
      for (final e in girlPapa.entries) {
        children.add(
          Padding(
            padding: EdgeInsets.only(left: 12.w, top: 4.h),
            child: _buildKeyValueRow(e.key, e.value?.toString() ?? '–'),
          ),
        );
      }
    }
    if (botResponse.isNotEmpty) {
      children.add(Spacing.h(12));
      children.add(
        AutoTranslateText(
          botResponse,
          style: MyTextTheme.smallBCN.copyWith(
            color: "#6F221E".toColor().withValues(alpha: 0.9),
            height: 1.3,
          ),
        ),
      );
    }

    return _ExpandableSection(
      title: 'Papasamaya Match',
      subtitle: 'From API',
      icon: Icons.pie_chart_outline,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildManglikDosha(Map<String, dynamic> response) {
    // Aggregate API: use API strings and points when present
    if (response.containsKey('mangaldosh')) {
      final mangaldosh = response['mangaldosh']?.toString() ?? '';
      final pts = response['mangaldosh_points'] as Map<String, dynamic>?;
      final boyPts = pts?['boy']?.toString() ?? '–';
      final girlPts = pts?['girl']?.toString() ?? '–';
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
            Spacing.h(8),
            AutoTranslateText(
              mangaldosh,
              style: MyTextTheme.smallBCN.copyWith(
                color: "#6F221E".toColor().withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
            Spacing.h(8),
            Row(
              children: [
                Expanded(child: _buildKootaInfoTile('Boy (points)', boyPts)),
                Spacing.w(8),
                Expanded(child: _buildKootaInfoTile('Girl (points)', girlPts)),
              ],
            ),
          ],
        ),
      );
    }

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
                'https://d3c2un7ipdye89.cloudfront.net/homepageVideos/Frame+1321314931.svg',
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
    // Show Navtara compatibility widget if controller is registered and has data
    if (Get.isRegistered<NavtaraController>()) {
      final controller = Get.find<NavtaraController>();
      if (controller.compatibility.value != null) {
        return NavtaraCompatibilityWidget(controller: controller);
      } else if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Center(
          child: AutoTranslateText(
            'Compatibility analysis unavailable.',
            style: MyTextTheme.mediumBCN,
          ),
        );
      }
    }
    return const SizedBox.shrink();
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

class _LabelValue {
  final String label;
  final String value;
  _LabelValue(this.label, this.value);
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
