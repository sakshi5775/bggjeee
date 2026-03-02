import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/chalisa_detail_controller.dart';
import '../widgets/chalisa_verse_card_widget.dart';

class ChalisaDetailView extends BasePage<ChalisaDetailController> {
  const ChalisaDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE3B341)),
            );
          }

          final chalisa = controller.chalisa.value;
          if (chalisa == null) {
            return Center(
              child: AutoTranslateText(
                controller.errorMessage,
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Collapsible app bar with cover image
              SliverAppBar(
                expandedHeight: 260.h,
                pinned: true,
                backgroundColor: const Color(0xFF8B1925),
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    chalisa.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: chalisa.godCategory?.godImage ?? "",
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            Container(color: const Color(0xFF8B1925)),
                      ),
                      // Gradient overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFF8B1925).withValues(alpha: 0.7),
                              const Color(0xFF8B1925),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                      // God category info
                      if (chalisa.godCategory != null)
                        Positioned(
                          bottom: 60.h,
                          left: 16.w,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFE3B341),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: chalisa.godCategory!.godImage,
                                    width: 36.r,
                                    height: 36.r,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Container(
                                      width: 36.r,
                                      height: 36.r,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chalisa.godCategory!.godName,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFE3B341),
                                    ),
                                  ),
                                  if (chalisa.description.isNotEmpty)
                                    SizedBox(
                                      width: 200.w,
                                      child: Text(
                                        chalisa.description,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.white70,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // OM divider
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLine(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          'ॐ',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: const Color(0xFFE3B341),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildLine(),
                    ],
                  ),
                ),
              ),

              // Sections (doha, chopai, etc.)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final section = chalisa.sections[index];
                  return ChalisaVerseCardWidget(section: section);
                }, childCount: chalisa.sections.length),
              ),

              // Bottom spacing
              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: 60.w,
      height: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFE3B341),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
