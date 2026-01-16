import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ConsultationSliderController.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConsultationSlider extends StatelessWidget {
  final ConsultationSliderController controller = ConsultationSliderController();

  ConsultationSlider({super.key}) {
    controller.startAutoSlide();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ValueListenableBuilder<int>(
        valueListenable: controller.currentPage,
        builder: (context, page, _) {
          return PageView.builder(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.currentPage.value = index;
            },
            itemCount: controller.consultationCards.length,
            itemBuilder: (context, index) {
              final card = controller.consultationCards[index];
              return _buildConsultationCard(
                title: card['title'],
                buttonText: card['buttonText'],
                imagePath: card['image'],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildConsultationCard({
    required String title,
    required String buttonText,
    required String imagePath,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF9C27B0).withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoTranslateText(
                    title,
                    style: AppTypography.h2.copyWith(
                      color: const Color(0xFF5F2221),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8F0),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: AutoTranslateText(
                      buttonText,
                      style: AppTypography.h3.copyWith(
                        color: const Color(0xFF5F2221),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 120.w,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
