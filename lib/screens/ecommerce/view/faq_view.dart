import 'package:astrobharataiuser/screens/ecommerce/widgets/e_commerce_home_widgets/why_shop_with_us_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _faqMaroon = Color(0xFF68171E);
const Color _faqMaroonDark = Color(0xFF4a1015);
const Color _faqMaroonDarker = Color(0xFF3D0C11);
const Color _faqGold = Color(0xFFDFB343);

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final faqs = WhyShopWithUsWidget.allFaqs;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              title: 'Why AstroBharat AI?',
              showBackButton: true,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                children: [
                  ...List.generate(faqs.length, (index) {
                    final faq = faqs[index];
                    final isExpanded = expandedIndex == index;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _FaqTile(
                        question: faq['q']!,
                        answer: faq['a']!,
                        isExpanded: isExpanded,
                        onTap: () {
                          setState(() {
                            expandedIndex = isExpanded ? null : index;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28.w,
                    height: 28.w,
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
                        fontSize: 13.sp,
                        color: _faqMaroon,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
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
                      size: 26.w,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.only(top: 14.h, left: 40.w),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: _faqMaroon.withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      answer,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: _faqMaroon,
                        height: 1.55,
                      ),
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
    );
  }
}
