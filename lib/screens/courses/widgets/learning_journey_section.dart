import 'package:astrobharataiuser/screens/courses/widgets/learning_journey_dialog.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LearningJourneySection extends StatelessWidget {
  const LearningJourneySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        children: [
          AutoTranslateText(
            'Your Learning Journey',
            style: AppTypography.h2.copyWith(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildJourneyStep(
                  'Intro Course',
                  '4 WEEKS',
                  '₹2,000 - ₹3,000',
                  Icons.school_outlined,
                ),
                _buildArrow(),
                _buildJourneyStep(
                  'Diploma Program',
                  '8 WEEKS',
                  '₹4,999',
                  Icons.emoji_events_outlined,
                ),
                _buildArrow(),
                _buildJourneyStep(
                  'Bachelor Program',
                  '12 WEEKS',
                  '₹9,999',
                  Icons.workspace_premium_outlined,
                ),
                _buildArrow(),
                _buildJourneyStep(
                  'Master Program',
                  '16 WEEKS',
                  '₹19,999',
                  Icons.history_edu_outlined,
                ),
                _buildArrow(),
                _buildJourneyStep(
                  'Grand Master',
                  'LIFETIME ACCESS',
                  '₹39,999',
                  Icons.stars,
                  isPremium: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Icon(
        Icons.arrow_forward_ios,
        size: 16.w,
        color: const Color(0xFFD68D3C),
      ),
    );
  }

  Widget _buildJourneyStep(
    String title,
    String duration,
    String price,
    IconData icon, {
    bool isPremium = false,
  }) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isPremium ? const Color(0xFF3E1212) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD68D3C).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isPremium
                ? Colors.white.withOpacity(0.2)
                : const Color(0xFFFFF6E5),
            radius: 24.r,
            child: Icon(
              icon,
              color: isPremium ? Colors.white : const Color(0xFFD68D3C),
              size: 24.w,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 40.h, // Fixed height for 2 lines of text
            child: Center(
              child: AutoTranslateText(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: isPremium ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isPremium
                  ? const Color(0xFFFFCC80)
                  : const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: AutoTranslateText(
              duration,
              style: AppTypography.label.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: isPremium
                    ? const Color(0xFF3E1212)
                    : const Color(0xFF666666),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            price,
            style: AppTypography.body2.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isPremium
                  ? const Color(0xFFFFCC80)
                  : const Color(0xFFD68D3C),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              if (title == 'Intro Course') {
                Get.dialog(
                  const LearningJourneyDialog(
                    title: 'Intro Course',
                    duration: '4 Weeks',
                    description: 'Foundations & Awareness',
                    whoItIsFor: 'Beginners, seekers, and curious learners',
                    objective:
                        'Build clarity, remove superstition, and introduce logic-based understanding',
                    icon: Icons.school_outlined,
                    whatYouWillLearn: [
                      'Fundamentals of Core subject mastery (Astrology / Numerology / Vastu / Healing – as selected)',
                      'Basic concepts of planets, numbers, directions, and human energy systems',
                      'Logical explanation of remedies, gemstones, and spiritual practices',
                      'Ethical awareness: what to do and what to avoid',
                    ],
                    learningOutcomes: [
                      'Strong conceptual foundation',
                      'Ability to understand consultations logically',
                      'Confidence to move into professional learning paths',
                    ],
                  ),
                );
              } else if (title == 'Diploma Program') {
                Get.dialog(
                  const LearningJourneyDialog(
                    title: 'Diploma Program',
                    duration: '8 Weeks',
                    description: 'Professional Entry Level',
                    whoItIsFor: 'Aspiring practitioners and serious learners',
                    objective: 'Enable structured practice with confidence',
                    icon: Icons.emoji_events_outlined,
                    whatYouWillLearn: [
                      'Core subject mastery (Astrology / Numerology / Vastu / Healing – as selected)',
                      'Practical tools: charts, grids, layouts, symbols, and indicators',
                      'Introduction to KP logic, Lal Kitab actions, and validation methods',
                      'Case studies and beginner-level consultation report writing',
                    ],
                    learningOutcomes: [
                      'Entry-level professional competency',
                      'Ability to conduct basic client consultations',
                      'Industry-ready certification',
                    ],
                  ),
                );
              } else if (title == 'Bachelor Program') {
                Get.dialog(
                  const LearningJourneyDialog(
                    title: 'Bachelor Program',
                    duration: '12 Weeks',
                    description: 'Career-Focused Specialist',
                    whoItIsFor: 'Learners aiming for consulting as a career',
                    objective: 'Develop depth, accuracy, and specialization',
                    icon: Icons.workspace_premium_outlined,
                    buttonText: 'Build Your Consulting Career',
                    whatYouWillLearn: [
                      'Advanced interpretation techniques and combinations',
                      'Cross-validation (Astrology + Face Reading + Palmistry + Numerology)',
                      'Event timing logic, predictive rules, and situational judgment',
                      'Structured consultation workflows and ethical advisory practices',
                    ],
                    learningOutcomes: [
                      'Specialist-level expertise',
                      'Career-ready consulting skills',
                      'Ability to deliver detailed professional-grade reports',
                    ],
                  ),
                );
              } else if (title == 'Master Program') {
                Get.dialog(
                  const LearningJourneyDialog(
                    title: 'Master Program',
                    duration: '16 Weeks',
                    description: 'Expert, Researcher & Teacher',
                    whoItIsFor: 'Experts, mentors, and future faculty members',
                    objective: 'Create authority, mastery, and leadership',
                    icon: Icons.history_edu_outlined,
                    whatYouWillLearn: [
                      'Rule-based mastery (KP Astrology, Lal Kitab, Nakshatra logic)',
                      'Research-oriented analysis and advanced case audits',
                      'Complex problem-solving (career, health, relationships, karmic patterns)',
                      'Teaching methodology, mentoring skills, and faculty evaluation',
                    ],
                    learningOutcomes: [
                      'Expert-level authority',
                      'Eligibility for Astrobharatai Faculty Panel (post-evaluation)',
                      'Leadership in consultation, research, and education',
                    ],
                  ),
                );
              } else if (title == 'Grand Master') {
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
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                gradient: isPremium
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFCC80), Color(0xFFFFEEDD)],
                      )
                    : AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                'Learn More',
                textAlign: TextAlign.center,
                style: AppTypography.body2.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: isPremium ? const Color(0xFF3E1212) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
