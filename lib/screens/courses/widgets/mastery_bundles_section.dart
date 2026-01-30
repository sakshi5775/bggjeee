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
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 420.h,
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
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
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
