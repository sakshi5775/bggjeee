import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_manager/ext/hex_color_ext.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/login_guard.dart';
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
    Future<void> _requireLogin(
      Future<void> Function() action, {
      String? message,
    }) async {
      final ok = await LoginGuard.ensureLoggedIn(
        message: message ?? 'Please login to continue.',
      );
      if (ok) {
        await action();
      }
    }

    return Column(
      spacing: 5,
      children: [
        GestureDetector(
          onTap: () {
            switch (title) {
              case 'Face\nReading':
                _requireLogin(
                  () async => Get.toNamed(AppRoutes.faceReading),
                  message: 'Login to start face reading.',
                );
                break;
              case 'Palm\nReading':
                _requireLogin(
                  () async => Get.toNamed(AppRoutes.palmReading),
                  message: 'Login to start palm reading.',
                );
                break;
              case 'Vastu\nMatching':
                _requireLogin(
                  () async => Get.toNamed(AppRoutes.vastuDashboard),
                  message: 'Login to explore Vastu services.',
                );
                break;
              case 'Ramal\nShastra':
                _requireLogin(
                  () async => Get.toNamed(AppRoutes.ramalShastra),
                  message: 'Login to explore Ramal Shastra.',
                );
                break;
              case 'Writing\nAstrology':
                _requireLogin(
                  () async => Get.toNamed(AppRoutes.handwritingAstrology),
                  message: 'Login to use handwriting astrology.',
                );
                break;
              case 'Prshan\nKundli':
                _requireLogin(
                  () async => Get.toNamed(AppRoutes.prashnaKundali),
                  message: 'Login to use Prashna Kundli.',
                );
                break;
              case 'Tarot\nReading':
                _requireLogin(
                  () async => Get.toNamed(AppRoutes.tarotReading),
                  message: 'Login to explore tarot reading.',
                );
                break;
              default:
                _requireLogin(
                  () async => Get.toNamed(AppRoutes.comingSoon),
                );
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
