import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PujaPackageSelectionBottomSheet extends StatelessWidget {
  const PujaPackageSelectionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PujaPackageSelectionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PujaDetailController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Header
              _buildHeader(context),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
                  child: Obx(() {
                    final puja = controller.puja.value;
                    if (puja == null) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Package count indicator
                        if (puja.packages != null && puja.packages!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(left: 4.w, bottom: 16.h),
                            child: AutoTranslateText(
                              '${puja.packages!.length} ${puja.packages!.length == 1 ? 'Package' : 'Packages'} Available',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: const Color(0xFF757575),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        // Package cards
                        if (puja.packages != null && puja.packages!.isNotEmpty)
                          ...puja.packages!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final package = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildPackageCard(
                                context,
                                controller,
                                package,
                                index,
                              ),
                            );
                          }),
                      ],
                    );
                  }),
                ),
              ),
              // Bottom action bar
              _buildBottomActionBar(context, controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoTranslateText(
                  'Select Package',
                  style: MyTextTheme.veryLargeBCB.copyWith(
                    color: const Color(0xFF212121),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                AutoTranslateText(
                  'Choose the perfect package for your puja',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: const Color(0xFF757575),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.close_rounded,
                    color: const Color(0xFF757575),
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(
    BuildContext context,
    PujaDetailController controller,
    PujaPackage package,
    int index,
  ) {
    return Obx(() {
      final isSelected = controller.selectedPackageId.value == package.id;

      return GestureDetector(
        onTap: () => controller.selectPackage(package.id ?? ''),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.orangeGradient.colors.first
                  : const Color(0xFFEEEEEE),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.orangeGradient.colors.first.withValues(
                        alpha: 0.15,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selection indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24.w,
                    height: 24.w,
                    margin: EdgeInsets.only(top: 2.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected ? AppColors.orangeGradient : null,
                      color: isSelected ? null : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : const Color(0xFFBDBDBD),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.orangeGradient.colors.first
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16.sp,
                          )
                        : null,
                  ),
                  SizedBox(width: 14.w),
                  // Package details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Package name with badge
                        Row(
                          children: [
                            Expanded(
                              child: AutoTranslateText(
                                package.packageName == 'Single Package'
                                    ? 'व्यक्तिगत पूजा'
                                    : package.packageName ?? 'Package',
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: const Color(0xFF212121),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (index == 0) ...[
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.orangeGradient.colors.first,
                                      AppColors.orangeGradient.colors.last,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: AutoTranslateText(
                                  'Popular',
                                  style: MyTextTheme.smallBCB.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 12.h),
                        // Person count with icon
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.orangeGradient.colors.first
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.orangeGradient.colors.first
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people_rounded,
                                color: AppColors.orangeGradient.colors.first,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              AutoTranslateText(
                                '${package.personCount ?? 1} ${(package.personCount ?? 1) == 1 ? 'Person' : 'Persons'}',
                                style: MyTextTheme.smallBCB.copyWith(
                                  color: AppColors.orangeGradient.colors.first,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),
                        // Price section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AutoTranslateText(
                              '₹${(package.price ?? 0).toInt()}',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: AppColors.orangeGradient.colors.first,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                height: 1,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: AutoTranslateText(
                                'Total',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: const Color(0xFF9E9E9E),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    PujaDetailController controller,
  ) {
    return Obx(() {
      final selectedPackage = controller.getSelectedPackage();
      final price = selectedPackage?.price;
      final hasSelection = selectedPackage != null;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            children: [
              // Selected package info
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: hasSelection ? 1.0 : 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        'Total Amount',
                        style: MyTextTheme.smallBCN.copyWith(
                          color: const Color(0xFF9E9E9E),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      if (price != null && selectedPackage != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoTranslateText(
                              '₹${price.toInt()}',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: const Color(0xFF212121),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            AutoTranslateText(
                              selectedPackage.packageName ?? 'Package',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: const Color(0xFF757575),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      else
                        AutoTranslateText(
                          'Select a package',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF9E9E9E),
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Proceed button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52.h,
                constraints: BoxConstraints(minWidth: 140.w),
                decoration: BoxDecoration(
                  gradient: hasSelection
                      ? AppColors.orangeGradient
                      : LinearGradient(
                          colors: [
                            const Color(0xFFE0E0E0),
                            const Color(0xFFBDBDBD),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(26.r),
                  boxShadow: hasSelection
                      ? [
                          BoxShadow(
                            color: AppColors.orangeGradient.colors.first
                                .withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: hasSelection
                        ? () {
                            Navigator.of(context).pop();
                            controller.onProceedToBook();
                          }
                        : null,
                    borderRadius: BorderRadius.circular(26.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AutoTranslateText(
                            'Proceed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20.sp,
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
      );
    });
  }
}
