import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// FAQ section colors (avoid runtime null from hex extension)
const Color _faqMaroon = Color(0xFF68171E);
const Color _faqMaroonDark = Color(0xFF4a1015);
const Color _faqMaroonDarker = Color(0xFF3D0C11);
const Color _faqGold = Color(0xFFDFB343);

/// FAQ data: AstroBharat AI – Trust & Sales FAQs
class WhyShopWithUsWidget extends StatefulWidget {
  const WhyShopWithUsWidget({super.key});

  static const List<Map<String, String>> allFaqs = [
    {
      'q': 'What exactly is AstroBharat AI?',
      'a':
          'AstroBharat AI is a next-generation spiritual-tech platform that combines artificial intelligence with the timeless wisdom of Sanatan Dharma to provide ethical astrology guidance, spiritual insights, and life clarity.',
    },
    {
      'q': 'Who is behind AstroBharat AI?',
      'a':
          'AstroBharat AI is guided by Dr. Kunwar Harshit Rajveer, continuing a 51-year legacy of authentic Jyotish tradition established by Raj Jyotishi Shri Kamlesh Kumar.',
    },
    {
      'q': 'How is AstroBharat AI different from other astrology apps?',
      'a':
          'Most astrology platforms focus only on predictions. AstroBharat AI focuses on awareness, karmic understanding, and ethical guidance, helping users make better life decisions.',
    },
    {
      'q': 'Is AstroBharat AI based on authentic Vedic knowledge?',
      'a':
          'Yes. The platform is deeply rooted in the principles of Sanatan Dharma and the traditional science of Jyotish Shastra, supported by verified astrologers and spiritual experts.',
    },
    {
      'q': 'Can beginners use AstroBharat AI easily?',
      'a':
          'Absolutely. The platform is designed to make ancient wisdom simple, practical, and understandable for modern users.',
    },
    {
      'q': 'Is AstroBharat AI only for India?',
      'a':
          'No. AstroBharat AI is a global platform connecting 5,000+ astrologers and spiritual experts across 150+ countries.',
    },
    {
      'q': 'What kind of guidance can I receive from AstroBharat AI?',
      'a':
          'Users can receive spiritual guidance related to career decisions, relationships, marriage, business growth, financial planning, health awareness, and spiritual development.',
    },
    {
      'q': 'Is my personal information safe on the platform?',
      'a':
          'Yes. AstroBharat AI follows strict privacy standards and ensures that user information remains confidential and ethically handled.',
    },
    {
      'q': 'Why should I trust AstroBharat AI?',
      'a':
          'The platform is built on decades of authentic Jyotish experience, verified astrologers, and a mission to preserve India\'s sacred knowledge responsibly through technology.',
    },
    {
      'q': 'What is the vision of AstroBharat AI?',
      'a':
          'AstroBharat AI aims to transform ancient Indian spiritual wisdom into a modern global life-guidance system, helping millions of people achieve clarity, balance, and conscious living.',
    },
  ];

  @override
  State<WhyShopWithUsWidget> createState() => _WhyShopWithUsWidgetState();
}

class _WhyShopWithUsWidgetState extends State<WhyShopWithUsWidget> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    const int showCount = 5;
    final faqs = WhyShopWithUsWidget.allFaqs;
    final showFaqs = faqs.take(showCount).toList();

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: Text(
                  'Why AstroBharat AI?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.sp,
                    color: _faqMaroon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // FAQ items (first 5)
              ...List.generate(showFaqs.length, (index) {
                final faq = showFaqs[index];
                final isExpanded = expandedIndex == index;
                return _buildFaqTile(
                  question: faq['q']!,
                  answer: faq['a']!,
                  isExpanded: isExpanded,
                  onTap: () {
                    setState(() {
                      expandedIndex = isExpanded ? null : index;
                    });
                  },
                );
              }),
              // View All FAQ button
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      try {
                        if (Get.isRegistered<UserMainController>()) {
                          UserMainController.pushInCurrentTab(AppRoutes.faq);
                        } else {
                          Get.toNamed(AppRoutes.faq);
                        }
                      } catch (_) {
                        Get.toNamed(AppRoutes.faq);
                      }
                    },
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _faqMaroon,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View All FAQ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: _faqMaroon,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18.w,
                            color: _faqMaroon,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqTile({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _faqMaroon,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Q',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: _faqMaroon,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        question,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: _faqMaroon,
                          height: 1.35,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _faqMaroon,
                        size: 24.w,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: EdgeInsets.only(top: 12.h, left: 34.w),
                    child: Text(
                      answer,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: _faqMaroon,
                        height: 1.5,
                      ),
                    ),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
