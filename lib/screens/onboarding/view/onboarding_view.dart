import 'dart:ui';

import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/onboarding/controller/onboarding_controller.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/glass_button.dart';
import 'widget/rotating_logo.dart';

class OnboardingView extends BasePage<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double blurHeight = screenHeight * 0.7;

    return Scaffold(
      body: Stack(
        children: [
          /// 1️⃣ BACKGROUND IMAGE
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: const [
              _BgImage(img: AppConstant.onboardingScreen1Bgimg),
              _BgImage(img: AppConstant.onboardingScreen2Bgimg),
              _BgImage(img: AppConstant.onboardingScreen3Bgimg),
            ],
          ),

          /// 2️⃣ TOP LINEAR GRADIENT
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: screenHeight * 0.3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFE9A00).withOpacity(0.75),
                    const Color(0xFF6900).withOpacity(0.55),
                    const Color(0xFFE7000B).withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// 3️⃣ BOTTOM GRADIENT OVERLAY (70% HEIGHT)
          /// Note: BackdropFilter causes rendering issues on Flutter Web with CanvasKit
          /// Using gradient overlay instead for better compatibility
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: blurHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),

          /// 4️⃣ CONTENT
          SafeArea(
            child: Column(
              children: [
                /// BACK ICON
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                      onTap: () => controller.back(),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                /// LOGO + SLOGAN
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const RotatingLogo(),
                      const SizedBox(height: 16),

                      ClipRRect(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),

                          // overlay for text visibility
                          child: const Text(
                            "Get Instant Divine Guidance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 60, height: 2, color: Colors.white),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          Container(width: 60, height: 2, color: Colors.white),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Obx(() {
                        // Har page ke liye description
                        final descriptions = [
                          "Chat with our AI astrologer 24/7 or connect with verified expert pandits through video calls and live chat.",
                          "Chat with our AI astrologer 24/7 or connect with verified expert pandits through video calls and live chat.",
                          "Chat with our AI astrologer 24/7 or connect with verified expert pandits through video calls and live chat.",
                        ];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            descriptions[controller.currentPage.value],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 13,
                              height: 1.4,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 8.0,
                        ),
                        child: Obx(() {
                          final pageIndex = controller.currentPage.value;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: StaggeredSlideFade(
                                  index: i,
                                  currentPage: pageIndex,
                                  child: GlassMenuButton(
                                    title: controller.pageButtons[pageIndex][i],
                                    icon: i == 0
                                        ? Icons.chat_bubble_outline
                                        : i == 1
                                        ? Icons.video_call_outlined
                                        : Icons.person_outline,
                                    onTap: () {},
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                /// CIRCLE PAGE INDICATOR (ABOVE BUTTONS)
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 8,
                        width: controller.currentPage.value == index ? 22 : 8,
                        decoration: BoxDecoration(
                          color: controller.currentPage.value == index
                              ? Colors.white
                              : Colors.white38,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// BUTTONS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _btn(
                          text: "Skip",
                          onTap: controller.skip,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFf07c35), Color(0xFFE0391B)],
                          ),
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _btn(
                          text: "Next  >",
                          gradient: const LinearGradient(
                            colors: [Colors.white, Colors.white],
                          ),
                          textColor: const Color(0xFFFF6A00),
                          onTap: controller.nextPage,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// PAGE INDICATOR TEXT
                Obx(
                  () => Text(
                    "${controller.currentPage.value + 1} of 3",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//image
class _BgImage extends StatelessWidget {
  final String img;
  const _BgImage({required this.img});

  @override
  Widget build(BuildContext context) {
    // Check if img is a URL (starts with http) or local asset
    if (img.startsWith('http://') || img.startsWith('https://')) {
      return SizedBox.expand(
        child: Image.network(
          img,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
          },
        ),
      );
    } else {
      return SizedBox.expand(child: Image.asset(img, fit: BoxFit.cover));
    }
  }
}

//button
Widget _btn({
  required String text,
  required VoidCallback onTap,
  Gradient? gradient,
  Color textColor = Colors.white,
}) {
  return SizedBox(
    height: 50,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient:
            gradient ??
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF8A00), // orange
                Color(0xFFFF3D00), // deep orange
              ],
            ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
