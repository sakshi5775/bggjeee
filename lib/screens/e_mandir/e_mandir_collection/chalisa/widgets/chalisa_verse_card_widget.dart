import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/data_model/chalisa_detail_model.dart';

class ChalisaVerseCardWidget extends StatelessWidget {
  final ChalisaSection section;

  const ChalisaVerseCardWidget({Key? key, required this.section})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDoha = section.type == 'doha';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDoha ? const Color(0xFFFFF8F0) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDoha
              ? const Color(0xFFE3B341).withValues(alpha: 0.4)
              : const Color(0xFF8B1925).withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section title header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDoha
                    ? [
                        const Color(0xFFE3B341).withValues(alpha: 0.2),
                        const Color(0xFFE3B341).withValues(alpha: 0.05),
                      ]
                    : [
                        const Color(0xFF8B1925).withValues(alpha: 0.1),
                        const Color(0xFF8B1925).withValues(alpha: 0.03),
                      ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDoha ? Icons.auto_awesome : Icons.format_quote,
                  color: isDoha
                      ? const Color(0xFFE3B341)
                      : const Color(0xFF8B1925),
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                AutoTranslateText(
                  section.sectionTitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDoha
                        ? const Color(0xFF6B1B1A)
                        : const Color(0xFF8B1925),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  isDoha ? Icons.auto_awesome : Icons.format_quote,
                  color: isDoha
                      ? const Color(0xFFE3B341)
                      : const Color(0xFF8B1925),
                  size: 18.r,
                ),
              ],
            ),
          ),

          // Verses
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: section.verses.map((verse) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    children: [
                      Text(
                        verse.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isDoha ? 16.sp : 15.sp,
                          fontWeight: isDoha
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: const Color(0xFF3D0C11),
                          height: 1.8,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (verse != section.verses.last)
                        Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDot(),
                              SizedBox(width: 8.w),
                              _buildDot(),
                              SizedBox(width: 8.w),
                              _buildDot(),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 4.r,
      height: 4.r,
      decoration: BoxDecoration(
        color: const Color(0xFFE3B341),
        shape: BoxShape.circle,
      ),
    );
  }
}
