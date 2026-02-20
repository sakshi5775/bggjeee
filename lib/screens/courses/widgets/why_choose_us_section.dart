import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          AutoTranslateText(
            'Why Choose AstroBharatAI?',
            style: AppTypography.h2.copyWith(
              color: const Color(0xFF3E1212),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildCard(
                  icon: Icons.spa_outlined, // Plant/Growth icon
                  title: 'Structured Growth',
                  description: 'Clear pathways for every stage of learning',
                ),
                SizedBox(width: 16.w),
                _buildCard(
                  icon: Icons.science_outlined, // Modern/Telescope icon
                  title: 'Modern Curriculum',
                  description: 'Energy-centric, logic-based online education',
                ),
                SizedBox(width: 16.w),
                _buildCard(
                  icon: Icons.play_circle_outline, // Play icon
                  title: 'Free Previews',
                  description: 'Watch introductory classes at no cost',
                ),
                SizedBox(width: 16.w),
                _buildCard(
                  icon: Icons.currency_rupee, // Pricing icon
                  title: 'Transparent Pricing',
                  description: 'Clear fees, no hidden extra charges',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final double circleSize = 70.h;
    final double cardTopMargin = 35.h;

    return SizedBox(
      width: 170.w,
      height: 225.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Main Card
          Container(
            margin: EdgeInsets.only(top: cardTopMargin),
            padding: EdgeInsets.fromLTRB(
              10.w,
              cardTopMargin + 6.w,
              10.w,
              12.w,
            ), // Compact padding
            decoration: BoxDecoration(
              color: const Color(0xFF3E1212), // Dark Brown
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 36.h, // Reduced title height container
                  child: Center(
                    child: AutoTranslateText(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.digitalEducationTextColor,
                        fontSize: 13, // Slightly smaller font
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 6.h), // Reduced spacing
                Container(
                  width: 30.w,
                  height: 2.h,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                SizedBox(height: 6.h), // Reduced spacing
                Expanded(
                  child: Center(
                    child: AutoTranslateText(
                      description,
                      textAlign: TextAlign.center,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.digitalEducationTextColor.withValues(
                          alpha: 0.5,
                        ),
                        fontSize: 11,
                        height: 1.2,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Icon
          Positioned(
            top: 0,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF3E1212), size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

