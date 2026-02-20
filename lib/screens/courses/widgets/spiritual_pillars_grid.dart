import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class SpiritualPillarsGrid extends StatelessWidget {
  SpiritualPillarsGrid({super.key});

  final List<Map<String, String>> _pillars = [
    {
      'name': 'Vedic\nAstrology',
      'image': AppConstant.dESpriritualPillarsVedicAstrology,
    },
    {
      'name': 'KP\nAstrology',
      'image': AppConstant.dESpriritualPillarsKPAstrology,
    },
    {
      'name': 'Gemstone\nScience',
      'image': AppConstant.dESpriritualPillarsGemstoneScience,
    },
    {'name': 'Numerology', 'image': AppConstant.dESpriritualPillarsNumerology},
    {
      'name': 'Vastu\nShastra',
      'image': AppConstant.dESpriritualPillarsVaastuShastra,
    },
    {'name': 'Lal Kitab', 'image': AppConstant.dESpriritualPillarsLalKitab},
    {
      'name': 'Face\nReading',
      'image': AppConstant.dESpriritualPillarsFaceReading,
    },
    {
      'name': 'Reiki\nHealing',
      'image': AppConstant.dESpriritualPillarsReikiHealing,
    },
    {
      'name': 'Tarot\nReading',
      'image': AppConstant.dESpriritualPillarsTarotReading,
    },
    {'name': 'Nakshatra', 'image': AppConstant.dESpriritualPillarsNakshatra},
    {
      'name': 'Crystal/\nRudraksha',
      'image': AppConstant.dESpriritualPillarsRudrakshScience,
    },
    {'name': 'Palmistry', 'image': AppConstant.dESpriritualPillarsPalmistry},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: const BoxDecoration(
        color: Color(0xFF3E1212), // Dark Brown Background
        // gradient: AppColors.primaryGradient, // Or use gradient if preferred match
      ),
      child: Column(
        children: [
          AutoTranslateText(
            'Our 12 Spiritual Pillars',
            style: AppTypography.h2.copyWith(
              color: const Color(0xFFFFCC80), // Gold text
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Get.width > 600 ? 4 : 3,
              childAspectRatio: 0.75, // Adjusted aspect ratio
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemCount: _pillars.length,
            itemBuilder: (context, index) {
              final pillar = _pillars[index];
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFF8B5E3C),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.network(
                          pillar['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white54,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 32.h, // Fixed height for text area
                    child: Center(
                      child: AutoTranslateText(
                        pillar['name']!,
                        textAlign: TextAlign.center,
                        style: AppTypography.body2.copyWith(
                          color: const Color(0xFFFFCC80), // Gold/Beige
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
