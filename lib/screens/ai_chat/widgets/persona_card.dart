import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

import '../../../app_manager/ext/hex_color_ext.dart';

class PersonaCard extends StatelessWidget {
  final PersonaModel persona;
  final VoidCallback onTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onChatTap;

  const PersonaCard({
    super.key,
    required this.persona,
    required this.onTap,
    this.onCallTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive dimensions based on available space
          final availableHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : 400.h; // Fallback for unbounded constraints

          // Dynamically adjust image height (40-45% of available height)
          // Ensure image doesn't take more than 45% and leaves enough space for content
          final maxImageHeight = ((availableHeight * 0.45).clamp(
            0,
            availableHeight * 0.5,
          )).toDouble();
          final minImageHeight = ((availableHeight * 0.35).clamp(
            70.h,
            90.h,
          )).toDouble();
          final imageHeight = ((availableHeight * 0.42).clamp(
            minImageHeight,
            maxImageHeight,
          )).toDouble();

          // Calculate remaining space for content (ensure at least minimum)
          final contentHeight = ((availableHeight - imageHeight).clamp(
            100.h,
            availableHeight,
          )).toDouble();

          // Adjust padding based on available space
          final horizontalPadding = (8.w).clamp(6.w, 10.w);
          final verticalPadding = contentHeight > 120.h
              ? 6.h
              : (contentHeight > 100.h ? 4.h : 2.h);

          // Adjust spacing between elements
          final textSpacing = contentHeight > 120.h ? 2.h : 1.h;
          final sectionSpacing = contentHeight > 120.h ? 4.h : 2.h;
          final buttonSpacing = contentHeight > 120.h ? 6.h : 4.h;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: const Color(0xFFF5F5F5),
                    child: persona.image != null && persona.image!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: persona.image!,
                            width: double.infinity,
                            height: imageHeight,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFFF5F5F5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.saffron,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                _buildPlaceholderImage(height: imageHeight),
                          )
                        : _buildPlaceholderImage(height: imageHeight),
                  ),
                ),
                // Content - Flexible to prevent overflow
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Name
                        AutoTranslateText(
                          persona.displayName,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFF68171E),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: textSpacing),
                        // Specialization
                        AutoTranslateText(
                          persona.specializations.isNotEmpty
                              ? persona.specializations
                                    .map(
                                      (s) =>
                                          s.replaceAll('_', ' ').toLowerCase(),
                                    )
                                    .join(', ')
                              : 'Vedic astrology',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF666666),
                            fontSize: (10.sp).clamp(9.sp, 11.sp),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: textSpacing),
                        // Languages
                        AutoTranslateText(
                          persona.languages.isNotEmpty
                              ? persona.languages.take(2).join(', ')
                              : 'English, Hindi',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: const Color(0xFF666666),
                            fontSize: (10.sp).clamp(9.sp, 11.sp),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: sectionSpacing),
                        // Rating and Price in same row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Rating
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppColors.saffron,
                                    size: (12.w).clamp(10.w, 14.w),
                                  ),
                                  SizedBox(width: (2.w).clamp(1.w, 3.w)),
                                  Flexible(
                                    child: AutoTranslateText(
                                      persona.rating != null
                                          ? '${persona.rating!.toStringAsFixed(1)}(${persona.totalRatings})'
                                          : '0.0(0)',
                                      style: MyTextTheme.smallBCN.copyWith(
                                        color: const Color(0xFF333333),
                                        fontSize: (10.sp).clamp(9.sp, 11.sp),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: (4.w).clamp(2.w, 6.w)),
                            // Price from API (chat/call per min)
                            Flexible(
                              flex: 2,
                              child: _buildPriceText(persona),
                            ),
                          ],
                        ),
                        SizedBox(height: buttonSpacing),
                        // Call and Chat buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                label: 'Call',
                                onTap: onCallTap ?? () {},
                                useGradient: true,
                                textColor: Colors.white,
                                maxHeight: contentHeight > 100.h ? 32.h : 28.h,
                              ),
                            ),
                            SizedBox(width: (6.w).clamp(4.w, 8.w)),
                            Expanded(
                              child: _buildActionButton(
                                label: 'Chat',
                                onTap: onChatTap ?? onTap,
                                useGradient: true,
                                textColor: Colors.white,
                                maxHeight: contentHeight > 100.h ? 32.h : 28.h,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderImage({double? height}) {
    final imageHeight = height ?? 120.h;
    return Container(
      width: double.infinity,
      height: imageHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5F2221).withValues(alpha: 0.1),
            AppColors.saffron.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          color: AppColors.deepOrange.withValues(alpha: 0.5),
          size: 32.w,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    Color? backgroundColor,
    required Color textColor,
    double? maxHeight,
    bool useGradient = false,
  }) {
    final buttonHeight = maxHeight ?? (32.h).clamp(26.h, 36.h);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: (4.w).clamp(2.w, 6.w)),
        decoration: BoxDecoration(
          gradient: useGradient ? AppColors.orangeGradient : null,
          color: useGradient ? null : backgroundColor,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: useGradient
              ? [
                  BoxShadow(
                    color: '#F38B3B'.toColor().withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: textColor,
              fontSize: (11.sp).clamp(9.sp, 12.sp),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceText(PersonaModel persona) {
    final chat = persona.chatPricePerMinute ?? persona.pricePerMin ?? persona.price;
    final call = persona.callPricePerMinute;
    final chatFree = chat == null || chat == 0;
    final callFree = call == null || call == 0;
    if (chatFree && callFree) {
      return AutoTranslateText(
        'Free',
        style: MyTextTheme.smallBCN.copyWith(
          color: const Color(0xFF999999),
          fontSize: (9.sp).clamp(8.sp, 10.sp),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
      );
    }
    final parts = <String>[];
    if (!chatFree) parts.add('Chat ₹${chat.toInt()}/min');
    if (!callFree) parts.add('Call ₹${call.toInt()}/min');
    return AutoTranslateText(
      parts.join(' · '),
      style: MyTextTheme.smallBCB.copyWith(
        color: AppColors.saffron,
        fontSize: (9.sp).clamp(8.sp, 10.sp),
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.right,
    );
  }
}
