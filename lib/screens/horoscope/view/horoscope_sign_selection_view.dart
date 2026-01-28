import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HoroscopeSignSelectionView extends StatelessWidget {
  const HoroscopeSignSelectionView({super.key});

  // Gradient definitions
  static final LinearGradient gradientBackground = LinearGradient(
    colors: ["#FCE5AA".toColor(), "#FFFCF3".toColor(), "#FFFFFF".toColor()],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // static final LinearGradient primaryGradient = LinearGradient(
  //   colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
  // );

  static LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
  );

  // Zodiac signs with their image paths
  static const List<Map<String, String>> zodiacSigns = [
    {'name': 'Aries', 'image': AppConstant.zodiacAries},
    {'name': 'Taurus', 'image': AppConstant.zodiacTaurus},
    {'name': 'Gemini', 'image': AppConstant.zodiacGemini},
    {'name': 'Cancer', 'image': AppConstant.zodiacCancer},
    {'name': 'Leo', 'image': AppConstant.zodiacLeo},
    {'name': 'Virgo', 'image': AppConstant.zodiacVirgo},
    {'name': 'Libra', 'image': AppConstant.zodiacLibra},
    {'name': 'Scorpio', 'image': AppConstant.zodiacScorpio},
    {'name': 'Sagittarius', 'image': AppConstant.zodiacSagittarius},
    {'name': 'Capricorn', 'image': AppConstant.zodiacCapricorn},
    {'name': 'Aquarius', 'image': AppConstant.zodiacAquarius},
    {'name': 'Pisces', 'image': AppConstant.zodiacPisces},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: const Color(0xFFDFB343),
                          size: 24.w,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      // Title
                      Expanded(
                        child: AutoTranslateText(
                          'Select Your Sign',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: const Color(0xFFDFB343),
                            fontWeight: FontWeight.bold,
                          ).merge(AppTypography.h2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Spacer to balance the back button
                      SizedBox(width: 48.w),
                    ],
                  ),
                ),
              ),
              // Zodiac signs grid
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: zodiacSigns.length,
                    itemBuilder: (context, index) {
                      final sign = zodiacSigns[index];
                      return _buildZodiacCard(sign['name']!, sign['image']!);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZodiacCard(String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Get form data from arguments if available
        final arguments = Get.arguments as Map<String, dynamic>?;
        final formData = arguments?['formData'] as Map<String, dynamic>?;
        
        // Navigate to main horoscope page with selected sign and form data
        Get.toNamed(
          AppRoutes.horoscopeMain,
          arguments: {
            'selectedSign': name,
            if (formData != null) 'formData': formData,
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Card with Image
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  
                  ],
                ),
                child: Padding(
                  
                  padding: EdgeInsets.all(12.w),
                  child: (imagePath.startsWith('http://') || imagePath.startsWith('https://'))
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Failed to load image: $imagePath');
                            debugPrint('Error: $error');
                            return Icon(
                              Icons.star,
                              size: 40.w,
                              color: const Color(0xFFDFB343),
                            );
                          },
                        )
                      : Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Failed to load image: $imagePath');
                            debugPrint('Error: $error');
                            return Icon(
                              Icons.star,
                              size: 40.w,
                              color: const Color(0xFFDFB343),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
          Spacing.h(4),
          // Zodiac Name below the circle
          AutoTranslateText(
            name,
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ).merge(AppTypography.body2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

