import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologersSectionWidget extends StatefulWidget {
  const AstrologersSectionWidget({super.key});

  @override
  State<AstrologersSectionWidget> createState() => _AstrologersSectionWidgetState();
}

class _AstrologersSectionWidgetState extends State<AstrologersSectionWidget> {
  final AstrologerService _astrologerService = AstrologerService();
  final RxList<AstrologerModel> astrologers = <AstrologerModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _loadAstrologers();
  }

  Future<void> _loadAstrologers() async {
    isLoading.value = true;
    try {
      final response = await _astrologerService.getAstrologers(
        page: 1,
        limit: 10,
        // Fetch all astrologers, filter for matchmaking specialists if needed
      );
      if (response != null && mounted) {
        // Filter for matchmaking or take top rated astrologers
        final filtered = response.astrologers.where((astro) {
          return astro.specializations.any((spec) => 
            spec.toUpperCase().contains('MATCH') || 
            spec.toUpperCase().contains('MARRIAGE') ||
            spec.toUpperCase().contains('KUNDALI')
          );
        }).toList();
        astrologers.value = filtered.isNotEmpty 
            ? filtered.take(10).toList()
            : response.astrologers.take(10).toList();
      }
    } catch (e) {
      debugPrint('Error loading astrologers: $e');
    } finally {
      if (mounted) {
        isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: AutoTranslateText(
            'Top Astrologers For Matchmaking',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#DFB343".toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
        ),
        Spacing.h(16),
        Obx(() {
          if (isLoading.value) {
            return SizedBox(
              height: 200.h,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (astrologers.isEmpty) {
            return SizedBox(
              height: 100.h,
              child: Center(
                child: AutoTranslateText(
                  'No astrologers available',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          }
          return SizedBox(
            height: 220.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: astrologers.length,
              itemBuilder: (context, index) {
                final astrologer = astrologers[index];
                return _buildAstrologerCard(astrologer);
              },
            ),
          );
        }),
        Spacing.h(20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  "#DFB343".toColor(),
                  "#DFB343".toColor().withOpacity(0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Give Feedback action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 20.w,
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Give Feedback',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ).merge(AppTypography.h3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAstrologerCard(AstrologerModel astrologer) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: astrologer.profilePicture ?? '',
                  width: 160.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 160.w,
                    height: 100.h,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 50.w,
                      color: Colors.grey[400],
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 160.w,
                    height: 100.h,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 50.w,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6.h,
                left: 6.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: "#DFB343".toColor(),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 11.w,
                      ),
                      Spacing.w(2),
                      AutoTranslateText(
                        astrologer.rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ).merge(AppTypography.label),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoTranslateText(
                    astrologer.displayName,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#6F221E".toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.body2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(3),
                  AutoTranslateText(
                    '${astrologer.experienceYears} yrs exp',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor().withOpacity(0.7),
                    ).merge(AppTypography.label),
                  ),
                  Spacing.h(3),
                  Flexible(
                    child: AutoTranslateText(
                      astrologer.languages.join(', '),
                      style: MyTextTheme.smallBCN.copyWith(
                        color: "#6F221E".toColor().withOpacity(0.7),
                      ).merge(AppTypography.label),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacing.h(8),
                  SizedBox(
                    width: double.infinity,
                    height: 32.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to consult astrologer
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: "#6F221E".toColor(),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        elevation: 0,
                      ),
                      child: AutoTranslateText(
                        'Consult',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ).merge(AppTypography.body2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

