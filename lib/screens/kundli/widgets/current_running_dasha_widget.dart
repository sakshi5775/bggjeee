import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentRunningDashaWidget extends StatelessWidget {
  final String mahadasha;
  final String antardasha;
  final String pratyantardasha;

  const CurrentRunningDashaWidget({
    super.key,
    required this.mahadasha,
    required this.antardasha,
    required this.pratyantardasha,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔸 Header
          Row(
            children: [
              Container(
                height: 44.w,
                width: 44.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A3D), Color(0xFFED6F30)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "Current Running Dasha",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A1E1B),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          /// 🔸 Dasha Cards
          Row(
            children: [
              _dashaCard(title: "Mahadasha", value: mahadasha),
              _dashaCard(title: "Antardasha", value: antardasha),
              _dashaCard(title: "Pratyantardasha", value: pratyantardasha),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dashaCard({required String title, required String value}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFED6F30), width: 1.2),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
