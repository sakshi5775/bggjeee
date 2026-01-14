import 'dart:ui';

import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/onboarding/controller/onboarding_controller.dart';
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
              _BgImage(img: "assets/images/onboarding_screen1_bgimg.png"),
              _BgImage(img: "assets/images/onboarding_screen2_bgimg.png"),
              _BgImage(img: "assets/images/onboarding_screen3_bgimg.png"),
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

          /// 3️⃣ BOTTOM BLUR (70 HEIGHT)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  height: blurHeight,
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: blurHeight - 10,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: -1, sigmaY: -1),
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
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
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                      onTap: () => controller.back(),
                    ),
                  ),
                ),

                // const Spacer(),
                SizedBox(height: 30),

                /// LOGO + SLOGAN
                Column(
                  children: [
                    const RotatingLogo(),
                    const SizedBox(height: 25),

                    ClipRRect(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        // overlay for text visibility
                        child: const Text(
                          "Get Instant Divine Guidance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

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

                    const SizedBox(height: 12),

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
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 22),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Obx(() {
                        final pageIndex = controller.currentPage.value;

                        return Column(
                          children: List.generate(3, (i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
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

                const Spacer(),

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

                const SizedBox(height: 16),

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

                const SizedBox(height: 25),

                /// PAGE INDICATOR TEXT
                Obx(
                  () => Text(
                    "${controller.currentPage.value + 1} of 3",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 14),
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
    return SizedBox.expand(child: Image.asset(img, fit: BoxFit.cover));
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
