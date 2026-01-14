import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app_manager/ext/hex_color_ext.dart';
import '../../../app_manager/svg_assets.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/value/dimension.dart';
import '../../../theme/app_typography.dart';
import '../../../utils/app_constant.dart';
import '../../../widgets/auto_translate_text.dart';

class AstrologyToolWidget extends StatelessWidget {
  const AstrologyToolWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Astrology Tools',
                style: AppTypography.h2.copyWith(color: '#8B1925'.toColor()),
              ),
              // AutoTranslateText(
              //   'See All',
              //   style: AppTypography.body1.copyWith(color: '#9D4807'.toColor()),
              // ),
            ],
          ),
          Spacing.h(10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              children: [
                _buildAstrologyTools(
                  title: 'Face\nReading',
                  image: AppConstant.astrologyToolFaceReading,
                ),
                _buildAstrologyTools(
                  title: 'Palm\nReading',
                  image: AppConstant.astrologyToolPalmReading,
                ),
                _buildAstrologyTools(
                  title: 'Vastu\nMatching',
                  image: AppConstant.astrologyToolVastuReading,
                ),
                _buildAstrologyTools(
                  title: 'Ramal\nShastra',
                  image: AppConstant.astrologyToolRamalShastra,
                ),
                _buildAstrologyTools(
                  title: 'Writing\nAstrology',
                  image: AppConstant.astrologyToolWritingAstrology,
                ),
                _buildAstrologyTools(
                  title: 'Prshan\nKundli',
                  image: AppConstant.astrologyToolPrashnKundli,
                ),
                _buildAstrologyTools(
                  title: 'Tarot\nReading',
                  image: AppConstant.astrologyToolTarotReading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologyTools({required String title, required String image}) {
    return Column(
      spacing: 5,
      children: [
        GestureDetector(
          onTap: () {
            switch (title) {
              case 'Face\nReading':
                Get.toNamed(AppRoutes.faceReading);
                break;
              case 'Palm\nReading':
                Get.toNamed(AppRoutes.palmReading);
                break;
              case 'Vastu\nMatching':
                Get.toNamed(AppRoutes.vastuReading);
                break;
              case 'Ramal\nShastra':
                Get.toNamed(AppRoutes.comingSoon);
                break;
              case 'Writing\nAstrology':
                Get.toNamed(AppRoutes.handwritingAstrology);
                break;
              case 'Prshan\nKundli':
                Get.toNamed(AppRoutes.comingSoon);
                break;
              case 'Tarot\nReading':
                Get.toNamed(AppRoutes.tarotReading);
                break;
              default:
                Get.toNamed(AppRoutes.comingSoon);
                break;
            }
          },
          child: Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: AppRadius.all(0),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        AutoTranslateText(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: AppTypography.body2.copyWith(
            color: '#8B1925'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
