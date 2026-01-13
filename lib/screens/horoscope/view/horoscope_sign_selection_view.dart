import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HoroscopeSignSelectionView extends StatelessWidget {
  const HoroscopeSignSelectionView({super.key});

  // Zodiac signs with their symbols
  static const List<Map<String, String>> zodiacSigns = [
    {'name': 'Aries', 'symbol': '♈'},
    {'name': 'Taurus', 'symbol': '♉'},
    {'name': 'Gemini', 'symbol': '♊'},
    {'name': 'Cancer', 'symbol': '♋'},
    {'name': 'Leo', 'symbol': '♌'},
    {'name': 'Virgo', 'symbol': '♍'},
    {'name': 'Libra', 'symbol': '♎'},
    {'name': 'Scorpio', 'symbol': '♏'},
    {'name': 'Sagittarius', 'symbol': '♐'},
    {'name': 'Capricorn', 'symbol': '♑'},
    {'name': 'Aquarius', 'symbol': '♒'},
    {'name': 'Pisces', 'symbol': '♓'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.saffronmix,
            size: 24.w,
          ),
          onPressed: () => Get.back(),
        ),
        title: AutoTranslateText(
          'Select Your Sign',
          style: MyTextTheme.largeBCB.copyWith(
            color: AppColors.saffronmix,
            fontWeight: FontWeight.bold,
          ).merge(AppTypography.h2),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 24.w,
            ),
            onPressed: () {
              // Handle menu
            },
          ),
        ],
      ),
      body: SafeArea(
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
              return _buildZodiacCard(sign['name']!, sign['symbol']!);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildZodiacCard(String name, String symbol) {
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
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.saffron,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: "#DFB343".toColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Zodiac Symbol (Icon) - Larger and more prominent
            AutoTranslateText(
              symbol,
              style: TextStyle(
                color: "#DFB343".toColor(),
                fontWeight: FontWeight.w400,
              ).merge(AppTypography.h1),
            ),
            Spacing.h(8),
            // Zodiac Name
            AutoTranslateText(
              name,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ).merge(AppTypography.body1),
            ),
          ],
        ),
      ),
    );
  }
}

