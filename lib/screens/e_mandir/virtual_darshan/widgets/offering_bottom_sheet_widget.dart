import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/offering_item.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OfferingBottomSheetWidget extends GetView<VirtualDarshanController> {
  final Function(OfferingItem) onSelect;

  const OfferingBottomSheetWidget({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 12.h),
          TabBar(
            controller: controller.offeringTabController,
            isScrollable: true,
            labelColor: AppColors.deepOrange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.deepOrange,
            indicatorWeight: 2,
            dividerColor: Colors.transparent,
            tabs: controller.offeringTabs.map((e) => Tab(text: e)).toList(),
          ),
          Container(height: 1.h, color: Colors.orange.withOpacity(0.2)),
          SizedBox(height: 15.h),
          Expanded(
            child: TabBarView(
              controller: controller.offeringTabController,
              children: controller.offeringTabs
                  .map((tabName) => _gridItems(tabName))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridItems(String category) {
    final items = offeringData[category] ?? [];

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        final isLocked = item.isLocked;

        return InkWell(
          onTap: () {
            if (!isLocked) {
              onSelect(item);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60.h,
                width: 60.w,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    if (isLocked)
                      CustomPaint(
                        painter: DashedCirclePainter(
                          color: const Color(0xFF8D6E63),
                          strokeWidth: 1.0,
                          gap: 2,
                        ),
                        child: SizedBox(width: 48.w, height: 48.h),
                      ),
                    Container(
                      height: 40.h,
                      width: 40.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(item.imagePath, fit: BoxFit.contain),
                    ),
                    if (isLocked)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppColors.deepOrange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Icon(
                            Icons.lock,
                            size: 8.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              SizedBox(
                height: 14.h,
                child: AutoTranslateText(
                  item.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.label.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D4037),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double circumference = 2 * 3.14159 * radius;
    final double dashWidth = 4.0;
    final int dashCount = (circumference / (dashWidth + gap)).floor();
    final double adjustedGap =
        (circumference - (dashCount * dashWidth)) / dashCount;

    final Path path = Path();
    for (int i = 0; i < dashCount; i++) {
      double startAngle = (i * (dashWidth + adjustedGap)) / radius;
      double sweepAngle = dashWidth / radius;
      path.addArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
