import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MasteryBundlesSection extends StatelessWidget {
  const MasteryBundlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: AutoTranslateText(
              'Specialized Mastery Bundles',
              style: AppTypography.h2.copyWith(
                color: const Color(0xFF3E1212),
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 380.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildBundleCard(
                  title: 'Astrology Mastery Bundle',
                  price: '₹24,999',
                  includes:
                      'Vedic Astrology + KP Astrology + Lal Kitab + Numerology',
                  target: 'Full-time Professional Astrologers',
                  image: AppConstant.dESpecializedMasteryBundles1,
                  context: context,
                ),
                SizedBox(width: 16.w),
                _buildBundleCard(
                  title: 'Energy & Healing Bundle',
                  price: '₹14,999',
                  includes: 'Gemstone Science + Reiki Healing + Vastu Shastra',
                  target: 'Holistic Wellness & Spiritual Consultants',
                  image: AppConstant.dESpecializedMasteryBundles2,
                  context: context,
                ),
                SizedBox(width: 16.w),
                _buildBundleCard(
                  title: 'Personality & Guidance',
                  price: '₹12,999',
                  includes: 'Face Reading + Palmistry + Tarot Reading',
                  target: 'Counselors, Life Coaches, and HR Professionals',
                  image: AppConstant.dESpecializedMasteryBundles3,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBundleCard({
    required String title,
    required String price,
    required String includes,
    required String target,
    required String image,
    required BuildContext context,
  }) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7), // Beige background
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD68D3C).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/app/app_icon.png',
                      height: 20.h,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.star, size: 20),
                    ), // Placeholder logo
                    SizedBox(width: 8.w),
                    Expanded(
                      child: AutoTranslateText(
                        title,
                        style: AppTypography.h3.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5D2E17),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                AutoTranslateText(
                  price,
                  style: AppTypography.h2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E1212),
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 120.h, // Reduced height to prevent overflow
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image)),
                  );
                },
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Changed to spaceEvenly
                children: [
                  _buildBulletPoint('INCLUDED', includes),
                  // Removed SizedBox(height: 12.h) to rely on spaceEvenly
                  _buildBulletPoint('TARGET', target),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 6.w, color: const Color(0xFFD68D3C)),
            SizedBox(width: 6.w),
            AutoTranslateText(
              label,
              style: AppTypography.label.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5D2E17),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        AutoTranslateText(
          text,
          style: AppTypography.body2.copyWith(
            color: const Color(0xFF5D2E17),
            fontSize: 12.sp,
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
