import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HoroscopeSignSelectionView extends StatelessWidget {
  const HoroscopeSignSelectionView({super.key});

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
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            const CommonHeader(title: 'Daily Horoscope'),
            // Zodiac signs grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
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
          // Card with Image
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.deepOrange.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepOrange.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child:
                      (imagePath.startsWith('http://') ||
                          imagePath.startsWith('https://'))
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.deepOrange,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.star,
                              size: 40.w,
                              color: AppColors.deepOrange,
                            );
                          },
                        )
                      : Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.star,
                              size: 40.w,
                              color: AppColors.deepOrange,
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
          Spacing.h(4),
          // Zodiac Name below the card
          AutoTranslateText(
            name,
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCB
                .copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                )
                .merge(AppTypography.body2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
