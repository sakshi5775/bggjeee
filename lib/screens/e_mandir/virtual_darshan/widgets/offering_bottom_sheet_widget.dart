import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/puja_item_category_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_constant.dart';

class OfferingBottomSheetWidget extends GetView<VirtualDarshanController> {
  final Function(PujaItem) onSelect;

  const OfferingBottomSheetWidget({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Obx(() {
        // Show loading if categories are still loading
        if (controller.isLoadingPujaCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show message if no categories
        if (controller.pujaItemCategories.isEmpty) {
          return const Center(child: Text('No offerings available'));
        }

        // Ensure tab controller is ready
        if (controller.offeringTabController == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
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
              tabs: controller.offeringTabs
                  .map((name) => Tab(text: name))
                  .toList(),
            ),
            Container(height: 1.h, color: Colors.orange.withOpacity(0.2)),
            SizedBox(height: 15.h),
            Expanded(child: _buildCategoryItems()),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryItems() {
    return Obx(() {
      // Show loading for category items
      if (controller.isLoadingCategoryItems.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        );
      }

      final categoryDetail = controller.selectedCategoryDetail.value;
      if (categoryDetail == null || categoryDetail.items.isEmpty) {
        return const Center(child: Text('No items in this category'));
      }

      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.60,
        ),
        itemCount: categoryDetail.items.length,
        itemBuilder: (_, index) {
          final item = categoryDetail.items[index];
          return _buildItemCard(item);
        },
      );
    });
  }

  Widget _buildItemCard(PujaItem item) {
    return InkWell(
      onTap: () => onSelect(item),
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
                Container(
                  height: 48.h,
                  width: 48.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: item.image != null && item.image!.isNotEmpty
                        ? Image.network(
                            item.image!,
                            fit: BoxFit.cover,
                            width: 40.w,
                            height: 40.h,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.local_florist,
                              size: 24.r,
                              color: Colors.orange,
                            ),
                          )
                        : Icon(
                            Icons.local_florist,
                            size: 24.r,
                            color: Colors.orange,
                          ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Column(
            children: [
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
              Spacing.h(3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppConstant.coin, height: 12.h, width: 12.w),
                  AutoTranslateText(
                    (item.coin ?? 0).toString(),
                    style: AppTypography.label.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
