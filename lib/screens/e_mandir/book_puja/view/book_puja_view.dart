import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../controller/book_puja_controller.dart';
import '../widgets/book_puja_header_widget.dart';
import '../widgets/category_tabs_widget.dart';
import '../widgets/puja_card_widget.dart';

class BookPujaView extends BasePage<BookPujaController> {
  const BookPujaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 4,
          onPressed: () {
            Get.toNamed(AppRoutes.myBookings);
          },
          child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Container(
              width: 56,
              height: 56,

              alignment: Alignment.center,
              child: Icon(
                Icons.confirmation_number_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),

        body: SafeArea(
          child: Column(
            children: [
              const BookPujaHeaderWidget(),
              const SizedBox(height: 16),
              const CategoryTabsWidget(),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.pujas.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorMessage.value.isNotEmpty &&
                      controller.pujas.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoTranslateText(
                            controller.errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                controller.loadPujas(refresh: true),
                            child: const AutoTranslateText('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.pujas.isEmpty) {
                    return Center(
                      child: AutoTranslateText(
                        'No pujas available',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.loadPujas(refresh: true),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            controller.hasMore.value &&
                            !controller.isLoading.value) {
                          controller.loadPujas();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            controller.pujas.length +
                            (controller.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.pujas.length) {
                            // Load more indicator
                            if (controller.isLoading.value) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }

                          final puja = controller.pujas[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PujaCardWidget(
                              puja: puja,
                              index: index,
                              onBookNow: () => controller.onBookNow(puja),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

