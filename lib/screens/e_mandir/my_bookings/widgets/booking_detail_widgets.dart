import 'package:astrobharataiuser/data_model/my_booking_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingInfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const BookingInfoSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: Colors.white, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              AutoTranslateText(
                title,
                style: AppTypography.h3.copyWith(
                  color: const Color(0xFF5D1C21),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class BookingDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const BookingDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoTranslateText(
            label,
            style: AppTypography.body2.copyWith(color: const Color(0xFF757575)),
          ),
          AutoTranslateText(
            value,
            style: AppTypography.body2.copyWith(
              color: valueColor ?? const Color(0xFF212121),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ParticipantCard extends StatelessWidget {
  final ParticipantInfo participant;
  final int index;

  const ParticipantCard({
    super.key,
    required this.participant,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.orangeGradient.colors.first.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: AutoTranslateText(
                    '${index + 1}',
                    style: AppTypography.body1.copyWith(
                      color: AppColors.orangeGradient.colors.first,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      participant.name ?? 'Unknown',
                      style: AppTypography.body1.copyWith(
                        color: const Color(0xFF212121),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (participant.relation != null)
                      AutoTranslateText(
                        participant.relation!,
                        style: AppTypography.label.copyWith(
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 6.h,
            children: [
              if (participant.gotra != null)
                _buildChip('Gotra: ${participant.gotra}'),
              if (participant.nakshatra != null)
                _buildChip('Nakshatra: ${participant.nakshatra}'),
              if (participant.rashi != null)
                _buildChip('Rashi: ${participant.rashi}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String text) {
    return AutoTranslateText(
      text,
      style: AppTypography.label.copyWith(color: const Color(0xFF616161)),
    );
  }
}
