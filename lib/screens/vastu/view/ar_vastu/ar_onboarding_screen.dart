import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:get_storage/get_storage.dart';

class AROnboardingScreen extends StatefulWidget {
  const AROnboardingScreen({Key? key}) : super(key: key);

  @override
  State<AROnboardingScreen> createState() => _AROnboardingScreenState();
}

class _AROnboardingScreenState extends State<AROnboardingScreen> {
  final PageController _pageController = PageController();
  GetStorage get _storage => GetStorage();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'AR Vastu Mode',
      'description':
          'Experience Vastu guidance through your camera. See directions and energy zones in real-time.',
      'icon': Icons.view_in_ar,
      'color': '#9C27B0',
    },
    {
      'title': 'Accurate Compass',
      'description':
          'Our intelligent compass uses multiple sensors for precise direction detection. Calibrate by moving your device in a figure-8 motion.',
      'icon': Icons.explore,
      'color': '#F38B3B',
    },
    {
      'title': 'Room-Aware Intelligence',
      'description':
          'Get personalized Vastu guidance based on your room type. Each space has unique energy requirements.',
      'icon': Icons.home,
      'color': '#4A90E2',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Check if onboarding already shown
    if (_storage.read<bool>('ar_onboarding_shown') == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(AppRoutes.arVastu);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    _storage.write('ar_onboarding_shown', true);
    Get.offNamed(AppRoutes.arVastu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: AutoTranslateText(
                    'Skip',
                    style: MyTextTheme.mediumBCN
                        .copyWith(color: '#666666'.toColor())
                        .merge(AppTypography.body1),
                  ),
                ),
              ),
            ),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index]);
                },
              ),
            ),
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  width: _currentPage == index ? 24.w : 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? "#F38B3B".toColor()
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),

            Spacing.h(32),

            // Next/Get Started button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: "#F38B3B".toColor().withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: '#ffffff'.toColor(),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 24.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: AutoTranslateText(
                      _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                      style: MyTextTheme.mediumBCB
                          .copyWith(
                            color: '#ffffff'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.body1),
                    ),
                  ),
                ),
              ),
            ),
            Spacing.h(16),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, dynamic> page) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: page['color'].toString().toColor().withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page['icon'] as IconData,
              size: 60.w,
              color: page['color'].toString().toColor(),
            ),
          ),
          Spacing.h(32),
          AutoTranslateText(
            page['title'] as String,
            style: MyTextTheme.veryLargeBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h1),
            textAlign: TextAlign.center,
          ),
          Spacing.h(16),
          AutoTranslateText(
            page['description'] as String,
            style: MyTextTheme.mediumBCN
                .copyWith(color: '#666666'.toColor(), height: 1.5)
                .merge(AppTypography.body1),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
