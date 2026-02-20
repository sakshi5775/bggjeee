import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/live_stream_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReportAbusePopup extends StatefulWidget {
  final String streamId;

  const ReportAbusePopup({
    Key? key,
    required this.streamId,
  }) : super(key: key);

  @override
  State<ReportAbusePopup> createState() => _ReportAbusePopupState();
}

class _ReportAbusePopupState extends State<ReportAbusePopup> {
  String? _selectedCategory;
  bool _isSubmitting = false;
  final LiveStreamService _liveStreamService = LiveStreamService();

  // Report categories mapping
  final List<Map<String, String>> _reportCategories = [
    {
      'value': 'UNPROFESSIONAL_BEHAVIOUR',
      'label': 'Unprofessional Behaviour',
    },
    {
      'value': 'ABUSIVE_CONTENT',
      'label': 'Abusive Content/Harmful',
    },
    {
      'value': 'MISGUIDANCE',
      'label': 'Misguidance',
    },
    {
      'value': 'CONTACT_SHARING',
      'label': 'Contact Sharing',
    },
    {
      'value': 'OTHERS',
      'label': 'Others',
    },
  ];

  Future<void> _submitReport() async {
    if (_selectedCategory == null) {
      Get.snackbar(
        'Error',
        'Please select a report category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _liveStreamService.reportStream(
        widget.streamId,
        _selectedCategory!,
      );

      if (response != null) {
        Get.back(); // Close the popup
        Get.snackbar(
          'Success',
          'Report submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit report. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } on AlreadyReportedException catch (e) {
      // Handle already reported case gracefully
      Get.back(); // Close the popup
      final message = e.toString().trim();
      Get.snackbar(
        'Info',
        message.isEmpty ? 'You have already reported this stream' : message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF9E6), // Light creamy yellow at top
            Color(0xFFFFE5CC), // Light orange/peach at bottom
          ],
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoTranslateText(
                      'Report Abuse',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5D2B1F), // Dark brown/reddish-brown
                      ).merge(AppTypography.h1),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: const Color(0xFFF38B3B), // Orange/red color
                      size: 28.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Report category options
              ..._reportCategories.map((category) => Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category['value'];
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedCategory == category['value']
                                    ? const Color(0xFFF38B3B)
                                    : const Color(0xFFF38B3B).withValues(alpha: 0.6),
                                width: 2,
                              ),
                              color: _selectedCategory == category['value']
                                  ? const Color(0xFFF38B3B)
                                  : Colors.transparent,
                            ),
                            child: _selectedCategory == category['value']
                                ? Center(
                                    child: Container(
                                      width: 10.w,
                                      height: 10.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: AutoTranslateText(
                              category['label']!,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF5D2B1F), // Dark brown/reddish-brown
                              ).merge(AppTypography.h3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              SizedBox(height: 32.h),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF8B2635), // Dark red/maroon
                          Color(0xFFF38B3B), // Orange-red
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: _isSubmitting
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : AutoTranslateText(
                              'Submit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ).merge(AppTypography.h2),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

