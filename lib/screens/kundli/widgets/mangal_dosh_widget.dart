import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dosh_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MangalDoshWidget extends StatelessWidget {
  final DoshController controller;

  const MangalDoshWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-tabs for Mangal/Manglik Dosh
        _buildSubTabs(),
        
        // Content based on sub-tab
        Expanded(
          child: Obx(() {
            if (controller.selectedMangalSubTab.value == 0) {
              return _buildClassicalVedicAstrology();
            } else {
              return _buildExtendedModernAnalysis();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildSubTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => _buildSubTab(
              'Classical Vedic Astrology',
              0,
              controller.selectedMangalSubTab.value == 0,
            )),
          ),
          Expanded(
            child: Obx(() => _buildSubTab(
              'Extended / Modern Manglik Analysis',
              1,
              controller.selectedMangalSubTab.value == 1,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTab(String title, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.switchMangalSubTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? "#ed6f30".toColor().withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? "#ed6f30".toColor() : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: AutoTranslateText(
          title,
          textAlign: TextAlign.center,
          style: MyTextTheme.smallBCB.copyWith(
            color: isSelected ? "#ed6f30".toColor() : "#6F221E".toColor().withOpacity(0.6),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildClassicalVedicAstrology() {
    return Obx(() {
      if (controller.isLoadingMangalDosh.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.mangalDoshData.value;
      
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

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null) {
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
            // Bot Response
            if (response['bot_response'] != null)
              _buildBotResponseCard(response['bot_response'] as String),
            
            Spacing.h(16),
            
            // Dosh Status
            _buildStatusCard(response),
            
            Spacing.h(16),
            
            // Score
            if (response['score'] != null)
              _buildScoreCard(_parseScore(response['score'])),
            
            Spacing.h(16),
            
            // Cancellation
            if (response['cancellation'] != null)
              _buildCancellationCard(response['cancellation'] as Map<String, dynamic>),
            
            Spacing.h(16),
            
            // Factors
            if (response['factors'] != null)
              _buildFactorsCard(response['factors'] as Map<String, dynamic>),
          ],
        ),
      );
    });
  }

  Widget _buildExtendedModernAnalysis() {
    return Obx(() {
      if (controller.isLoadingManglikDosh.value) {
        return Center(
          child: CircularProgressIndicator(
            color: "#ed6f30".toColor(),
          ),
        );
      }

      final data = controller.manglikDoshData.value;
      
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

      final response = data['data']?['response'] as Map<String, dynamic>?;
      if (response == null) {
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
            // Bot Response
            if (response['bot_response'] != null)
              _buildBotResponseCard(response['bot_response'] as String),
            
            Spacing.h(16),
            
            // Score
            if (response['score'] != null)
              _buildScoreCard(_parseScore(response['score'])),
            
            Spacing.h(16),
            
            // Manglik Status
            _buildManglikStatusCard(response),
            
            Spacing.h(16),
            
            // Factors
            if (response['factors'] != null && (response['factors'] as List).isNotEmpty)
              _buildFactorsListCard(response['factors'] as List<dynamic>),
            
            Spacing.h(16),
            
            // Aspects
            if (response['aspects'] != null && (response['aspects'] as List).isNotEmpty)
              _buildAspectsCard(response['aspects'] as List<dynamic>),
          ],
        ),
      );
    });
  }

  Widget _buildBotResponseCard(String botResponse) {
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
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: "#ed6f30".toColor(),
            size: 24.w,
          ),
          Spacing.w(12),
          Expanded(
            child: AutoTranslateText(
              botResponse,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> response) {
    final isDoshaPresent = response['is_dosha_present'] as bool? ?? false;
    final isDoshaPresentMarsFromLagna = response['is_dosha_present_mars_from_lagna'] as bool? ?? false;
    final isDoshaPresentMarsFromMoon = response['is_dosha_present_mars_from_moon'] as bool? ?? false;
    final isAnshik = response['is_anshik'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          AutoTranslateText(
            'Dosh Status',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          _buildStatusItem('Dosh Present', isDoshaPresent),
          _buildStatusItem('Dosh from Mars (Lagna)', isDoshaPresentMarsFromLagna),
          _buildStatusItem('Dosh from Mars (Moon)', isDoshaPresentMarsFromMoon),
          _buildStatusItem('Anshik', isAnshik),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, bool value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            label,
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: value 
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: AutoTranslateText(
              value ? 'Yes' : 'No',
              style: MyTextTheme.smallBCB.copyWith(
                color: value ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _parseScore(dynamic score) {
    if (score is int) {
      return score;
    } else if (score is double) {
      return score.toInt();
    }
    return 0;
  }

  Widget _buildScoreCard(int score) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            'Score',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: "#ed6f30".toColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: AutoTranslateText(
              '$score%',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#ed6f30".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationCard(Map<String, dynamic> cancellation) {
    final score = _parseScore(cancellation['cancellationScore'] ?? 0);
    final reasons = cancellation['cancellationReason'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Cancellation',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#6F221E".toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AutoTranslateText(
                  'Score: $score',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: "#ed6f30".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (reasons.isNotEmpty) ...[
            Spacing.h(12),
            ...reasons.map((reason) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: "#ed6f30".toColor(),
                    size: 16.w,
                  ),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      reason.toString(),
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor(),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildFactorsCard(Map<String, dynamic> factors) {
    if (factors.isEmpty) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          AutoTranslateText(
            'Factors',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          ...factors.entries.map((entry) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AutoTranslateText(
                    '${entry.key}: ${entry.value}',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor(),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildManglikStatusCard(Map<String, dynamic> response) {
    final manglikByMars = response['manglik_by_mars'] as bool? ?? false;
    final manglikBySaturn = response['manglik_by_saturn'] as bool? ?? false;
    final manglikByRahuketu = response['manglik_by_rahuketu'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          AutoTranslateText(
            'Manglik Status',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          _buildStatusItem('Manglik by Mars', manglikByMars),
          _buildStatusItem('Manglik by Saturn', manglikBySaturn),
          _buildStatusItem('Manglik by Rahu/Ketu', manglikByRahuketu),
        ],
      ),
    );
  }

  Widget _buildFactorsListCard(List<dynamic> factors) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          AutoTranslateText(
            'Factors',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          ...factors.map((factor) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: "#ed6f30".toColor(),
                  size: 16.w,
                ),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(
                    factor.toString(),
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor(),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAspectsCard(List<dynamic> aspects) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          AutoTranslateText(
            'Aspects',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          ...aspects.map((aspect) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.visibility,
                  color: "#ed6f30".toColor(),
                  size: 16.w,
                ),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(
                    aspect.toString(),
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor(),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}

