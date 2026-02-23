import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/courses/widgets/learning_journey_dialog.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 360.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildBundleCard(
                  title: 'Personality & Guidance',
                  price: '₹12,999',
                  includes: 'Face Reading + Palmistry + Tarot Reading',
                  target: 'Counselors, Life Coaches, and HR Professionals',
                  image: AppConstant.dESpecializedMasteryBundles3,
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
                  title: 'Grand Master Program',
                  price: '₹39,999',
                  includes:
                      'Vedic + KP + Lal Kitab + Numerology + Vastu + More',
                  target:
                      'Professional Astrologers, Researchers & Future Faculty',
                  image: AppConstant.dESpecializedMasteryBundles4,
                  context: context,
                  onTap: () {
                    Get.dialog(
                      const LearningJourneyDialog(
                        title: 'Grand Master',
                        duration: 'Lifetime Access',
                        description: 'Complete Syllabus',
                        whoItIsFor:
                            'Professional Astrologers, Researchers & Future Faculty',
                        objective:
                            'Comprehensive Knowledge Coverage & Advanced Master-Level Training',
                        icon: Icons.stars,
                        whatYouWillLearn: [
                          'HEADER: 📚 Comprehensive Knowledge Coverage',
                          'Vedic Astrology',
                          'KP Astrology',
                          'Lal Kitab',
                          'Numerology',
                          'Vastu Shastra',
                          'Gemstone / Crystal / Rudraksha Science',
                          'Face Reading',
                          'Palmistry',
                          'Tarot Reading',
                          'Reiki Healing',
                          'Nakshatra Analysis',
                          'Remedies, Yantra, Mantra & Chakra Balancing',
                          'Past Life Regression Theory (PLRT – Conceptual Framework)',
                          'HEADER: 🎓 Advanced Master-Level Training',
                          'Rule-based prediction systems',
                          'Cross-validation (Astrology + Face + Palm + Numbers)',
                          'Complex case audits (career, marriage, health, karma)',
                          'Research-driven interpretation models',
                          'Teaching methodology & mentorship training',
                        ],
                        learningOutcomes: [
                          'Expert-level authority & Faculty eligibility',
                          'Priority Live Q&A (“First-Row Access”)',
                          'Lifetime alumni & professional network',
                          'Recognition as a Modern Occult Scientist',
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 16.w),
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width > 600 ? 230.w : 280.w,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E7), // Beige background
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFD68D3C).withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image at the top (Full Width)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              child: Image.network(
                image,
                height: Get.width > 600 ? 220.h : 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120.h,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image)),
                  );
                },
              ),
            ),
            Spacing.h(12),
            // 2. Title and Price
            Padding(
              padding: AppPaddings.symmetric(h: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: Image.asset(
                          'assets/app/app_icon.png',
                          height: 20.h,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.star, size: 20),
                        ),
                      ), // Placeholder logo
                      SizedBox(width: 8.w),
                      Expanded(
                        child: AutoTranslateText(
                          title,
                          style: AppTypography.h3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5D2E17),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoTranslateText(
                        price,
                        style: AppTypography.h2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3E1212),
                          fontSize: 18,
                        ),
                      ),
                      if (onTap != null) ...[
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.orangeGradient,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: AutoTranslateText(
                                'Learn More',
                                style: AppTypography.label.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Spacing.h(12),
            // 3. Details
            Padding(
              padding: AppPaddings.symmetric(h: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBulletPoint('INCLUDED', includes),
                  Spacing.h(12),
                  _buildBulletPoint('TARGET', target),
                ],
              ),
            ),
          ],
        ),
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
                fontSize: 10,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        AutoTranslateText(
          text,
          style: AppTypography.body2.copyWith(
            color: const Color(0xFF5D2E17),
            fontSize: 12,
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
