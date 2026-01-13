import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonaListCard extends StatelessWidget {
  final PersonaModel persona;
  final VoidCallback onTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onChatTap;

  const PersonaListCard({
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: Container(
                width: 120.w,
                height: 140.h,
                color: const Color(0xFFF5F5F5),
                child: persona.image != null && persona.image!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: persona.image!,
                        width: 120.w,
                        height: 140.h,
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
                        errorWidget: (context, url, error) => _buildPlaceholderImage(),
                      )
                    : _buildPlaceholderImage(),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name
                    AutoTranslateText(
                      persona.displayName,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: const Color(0xFF5F2221),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // Specialization
                    AutoTranslateText(
                      persona.specializations.isNotEmpty
                          ? persona.specializations
                              .map((s) => s.replaceAll('_', ' ').toLowerCase())
                              .join(', ')
                          : 'Vedic astrology',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(0xFF666666),
                      ).merge(AppTypography.body2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // Languages
                    AutoTranslateText(
                      persona.languages.isNotEmpty
                          ? persona.languages.take(2).join(', ')
                          : 'English, Hindi',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: const Color(0xFF666666),
                      ).merge(AppTypography.body2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    // Rating and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rating
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.saffron,
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            AutoTranslateText(
                              persona.rating != null
                                  ? '${persona.rating!.toStringAsFixed(1)}(${persona.totalRatings})'
                                  : '0.0(0)',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: const Color(0xFF333333),
                              ).merge(AppTypography.body2),
                            ),
                          ],
                        ),
                        // Price
                        AutoTranslateText(
                          persona.price != null
                              ? '₹${persona.price!.toStringAsFixed(0)}/min'
                              : 'Coming soon',
                          style: persona.price != null
                              ? MyTextTheme.smallBCB.copyWith(
                                  color: AppColors.saffron,
                                  fontWeight: FontWeight.bold,
                                ).merge(AppTypography.body1)
                              : MyTextTheme.smallBCN.copyWith(
                                  color: const Color(0xFF999999),
                                ).merge(AppTypography.body2),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Call and Chat buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            label: 'Call',
                            onTap: onCallTap ?? () {},
                            backgroundColor: AppColors.saffron,
                            textColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _buildActionButton(
                            label: 'Chat',
                            onTap: onChatTap ?? onTap,
                            backgroundColor: AppColors.saffron,
                            textColor: Colors.white,
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
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 120.w,
      height: 140.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5F2221).withOpacity(0.1),
            AppColors.saffron.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          color: AppColors.saffron.withOpacity(0.5),
          size: 40.w,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ).merge(AppTypography.body2),
          ),
        ),
      ),
    );
  }
}






