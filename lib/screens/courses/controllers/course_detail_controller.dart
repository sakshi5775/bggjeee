import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/courses/services/razorpay_payment_service.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CourseDetailController extends BaseController {
  final CoursesService _coursesService = CoursesService();
  final RazorpayPaymentService _razorpayService = RazorpayPaymentService();
  final String courseId;

  // Lock to prevent double processing
  bool _processPaymentLocked = false;

  CourseDetailController({required this.courseId}) {}

  @override
  void onClose() {
    _razorpayService.dispose();
    super.onClose();
  }

  // Course detail
  final Rx<CourseDetailModel?> courseDetail = Rx<CourseDetailModel?>(null);

  // Enrollment state (SOURCE OF TRUTH from API)
  final RxBool isEnrolled = false.obs;

  // Selected content for playback
  final Rx<ContentModel?> selectedContent = Rx<ContentModel?>(null);
  final Rx<LectureModel?> selectedLecture = Rx<LectureModel?>(null);

  // Course content expanded states
  final RxMap<String, bool> lectureExpandedStates = <String, bool>{}.obs;

  // Description expanded state
  final RxBool isDescriptionExpanded = false.obs;

  // Selected tab (0: Overview, 1: Curriculum, 2: Reviews)
  final RxInt selectedTab = 0.obs;

  // Pending payment data (for Razorpay callbacks)
  String? _pendingOrderId;
  String? _pendingGatewayOrderId;

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  // Handle Razorpay payment success
  void _handleRazorpaySuccess(Map<String, dynamic> response) async {
    try {
      setLoadingState(true);

      // Extract Razorpay response fields
      final razorpayPaymentId = response['paymentId'] as String?;
      final razorpayOrderId =
          response['orderId'] as String?; // Razorpay order ID from callback
      final razorpaySignature = response['signature'] as String?;

      if (_pendingOrderId == null || _pendingGatewayOrderId == null) {
        showErrorMessage(
          title: "Error",
          message: "Payment data missing. Please try again.",
        );
        return;
      }

      if (razorpayPaymentId == null || razorpayPaymentId.isEmpty) {
        showErrorMessage(
          title: "Payment Error",
          message: "Invalid payment response. Missing payment ID.",
        );
        return;
      }

      if (razorpayOrderId == null || razorpayOrderId.isEmpty) {
        showErrorMessage(
          title: "Payment Error",
          message: "Invalid payment response. Missing Razorpay order ID.",
        );
        return;
      }

      if (razorpaySignature == null || razorpaySignature.isEmpty) {
        showErrorMessage(
          title: "Payment Error",
          message: "Invalid payment response. Missing signature.",
        );
        return;
      }

      // CRITICAL: Verify gatewayOrderId from initiate matches Razorpay order_id
      if (_pendingGatewayOrderId != razorpayOrderId) {
        debugPrint('⚠️ gatewayOrderId mismatch!');
        debugPrint('  From initiate API: $_pendingGatewayOrderId');
        debugPrint('  From Razorpay: $razorpayOrderId');
        showErrorMessage(
          title: "Payment Error",
          message: "Order ID mismatch. Please try again.",
        );
        return;
      }

      // CRITICAL LOCK: Check right before API call to prevent double processing
      if (_processPaymentLocked) {
        debugPrint(
          '🚫 processPayment already executing — skipping duplicate call',
        );
        return;
      }

      // Lock right before API call
      _processPaymentLocked = true;

      // PROCESS PAYMENT - Backend handles everything (verification, enrollment, etc.)
      // Request format: orderId, gatewayOrderId, razorpay_order_id, razorpay_payment_id, razorpay_signature
      final paymentData = await _coursesService.processPayment(
        orderId: _pendingOrderId!,
        gatewayOrderId: _pendingGatewayOrderId!, // From initiate API
        razorpayOrderId: razorpayOrderId, // Razorpay order ID from callback
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );

      // Check API response - if success is true, payment is complete
      if (paymentData == null || !paymentData.success) {
        // Reset lock on failure so user can retry
        _processPaymentLocked = false;
        showErrorMessage(
          title: "Payment Processing Failed",
          message:
              paymentData?.message ??
              "Failed to process payment. Please contact support.",
        );
        return;
      }

      // API Response Structure:
      // {
      //   "success": true,
      //   "message": "Payment successful. Course access granted!",
      //   "data": {
      //     "order": { "status": "completed" },
      //     "payment": { "status": "captured" },
      //     "enrollment": { "accessStatus": "active" }
      //   }
      // }

      final enrollmentInfo = paymentData.data.enrollment;

      // If enrollment is active, course is unlocked
      if (enrollmentInfo.accessStatus == 'active') {
        // CRITICAL: Update enrollment status immediately so content is accessible
        isEnrolled.value = true;

        // Refresh course detail to get updated enrollment status
        await loadCourseDetail();

        // Double-check enrollment status after refresh
        final enrollmentStatus = await _coursesService.checkEnrollment(
          courseId,
        );
        if (enrollmentStatus != null) {
          final enrolled = enrollmentStatus['isEnrolled'] as bool? ?? false;
          isEnrolled.value = enrolled;
        }

        debugPrint('✅ Payment successful - Enrollment active, course unlocked');
        debugPrint('✅ isEnrolled.value set to: ${isEnrolled.value}');

        // Show success modal
        _showPaymentSuccessModal(
          message: paymentData.message.isNotEmpty
              ? paymentData.message
              : 'Course purchased successfully! You can now access all content.',
        );
      } else {
        showErrorMessage(
          title: "Enrollment Issue",
          message:
              "Payment successful but enrollment not activated. Please contact support.",
        );
      }

      // Clear pending data and reset lock after successful payment
      _pendingOrderId = null;
      _pendingGatewayOrderId = null;
      _processPaymentLocked = false;
    } catch (e) {
      // Reset lock on error so user can retry
      _processPaymentLocked = false;
      showErrorMessage(
        title: "Error",
        message: "Failed to process payment: $e",
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Handle Razorpay payment error
  void _handleRazorpayError(String error) {
    _processPaymentLocked = false;
    setLoadingState(false);
    showErrorMessage(title: "Payment Error", message: error);
    _pendingOrderId = null;
    _pendingGatewayOrderId = null;
  }

  // Handle Razorpay payment failure
  void _handleRazorpayFailure(dynamic response) {
    _processPaymentLocked = false;
    setLoadingState(false);
    final message = response is Map
        ? response['message']?.toString()
        : 'Payment was cancelled';
    showErrorMessage(
      title: "Payment Failed",
      message: message ?? "Payment was cancelled or failed. Please try again.",
    );
    _pendingOrderId = null;
    _pendingGatewayOrderId = null;
  }

  void _showPaymentSuccessModal({
    String message =
        'Course purchased successfully! You can now access all content.',
  }) {
    Get.dialog(
      PopScope(
        canPop: false, // Prevent back button from closing
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, AppColors.cream],
              ),
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          'Payment Successful',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success Icon
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 50.w,
                        ),
                      ),
                      Spacing.h(24),
                      // Success Message
                      AutoTranslateText(
                        'Course Purchased Successfully!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: '#68171E'.toColor(),
                        ),
                      ),
                      Spacing.h(12),
                      AutoTranslateText(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Auto-close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (Get.isDialogOpen == true) {
        Get.back(); // Close success modal
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    loadCourseDetail();
  }

  // Select content to play/view
  void selectContent(LectureModel lecture, ContentModel content) {
    selectedLecture.value = lecture;
    selectedContent.value = content;
  }

  // Toggle lecture expansion
  void toggleLecture(String lectureId) {
    lectureExpandedStates[lectureId] =
        !(lectureExpandedStates[lectureId] ?? false);
  }

  // Expand all lectures that have content
  void _expandAllLecturesWithContent() {
    if (courseDetail.value == null) return;

    final lectures = courseDetail.value!.lectures;
    for (final lecture in lectures) {
      // Expand lecture if it has content
      if (lecture.content.isNotEmpty) {
        lectureExpandedStates[lecture.id] = true;
      }
    }
  }

  // Step 2: Course Detail Flow (PREVIEW BEFORE ENROLL)
  Future<void> loadCourseDetail() async {
    try {
      setLoadingState(true);

      // Step 2: Get course detail
      final detail = await _coursesService.getCourseById(courseId);
      if (detail != null) {
        courseDetail.value = detail;

        // Step 4: Enrollment Check Flow (Security Layer) - updates isEnrolled
        await _verifyEnrollmentStatus();

        // Step 3: Course Lectures Visibility Flow (UDEMY BEHAVIOR)
        // Fetch FULL lecture structure EVEN IF USER IS NOT ENROLLED
        await _loadLecturesStructure();

        // Auto-expand all lectures with content when course detail loads
        _expandAllLecturesWithContent();
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to load course details",
        );
      }
    } catch (e) {
      showErrorMessage(
        title: "Error",
        message: "Failed to load course details: $e",
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Step 3: Course Lectures Visibility Flow (UDEMY BEHAVIOR)
  // ⚠️ THIS IS WHAT MAKES IT UDEMY-LIKE
  // This API is called EVEN IF USER IS NOT ENROLLED
  // Users can SEE everything (titles, descriptions, content titles) but ACCESS is restricted
  Future<void> _loadLecturesStructure() async {
    try {
      // Fetch full lecture structure from lectures API
      // This ensures we have complete lecture data even if course detail has partial data
      final lectures = await _coursesService.getLecturesByCourseId(courseId);
      if (lectures != null && lectures.isNotEmpty) {
        // Update course detail with full lecture structure
        if (courseDetail.value != null) {
          // Merge lecture data to ensure we have complete structure
          // The course detail API may have partial lecture data, this ensures completeness
          final updatedDetail = courseDetail.value!;
          // Replace lectures with full structure from lectures API
          courseDetail.value = CourseDetailModel(
            course: updatedDetail.course,
            lectures: lectures, // Use full lecture structure from lectures API
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading lectures structure: $e');
      // Don't show error - lectures from course detail are sufficient
      // This is a fallback to ensure we always have lecture data
    }
  }

  // Step 4: Enrollment Check Flow (Security Layer)
  Future<void> _verifyEnrollmentStatus() async {
    try {
      final enrollmentStatus = await _coursesService.checkEnrollment(courseId);
      if (enrollmentStatus != null) {
        // Update enrollment status from API verification
        final enrolled = enrollmentStatus['isEnrolled'] as bool? ?? false;
        isEnrolled.value = enrolled;
      }
    } catch (e) {
      // If enrollment check fails, keep the status from course detail
      debugPrint('Enrollment check failed: $e');
    }
  }

  // Re-check enrollment before content access (CRITICAL)
  Future<bool> verifyEnrollmentBeforeAccess() async {
    try {
      final enrollmentStatus = await _coursesService.checkEnrollment(courseId);
      if (enrollmentStatus != null) {
        final enrolled = enrollmentStatus['isEnrolled'] as bool? ?? false;
        isEnrolled.value = enrolled;
        return enrolled;
      }
      return isEnrolled.value;
    } catch (e) {
      debugPrint('Enrollment verification failed: $e');
      return isEnrolled.value;
    }
  }

  // Purchase Flow
  Future<void> initiatePurchase() async {
    try {
      // Reset lock when starting a new payment flow
      _processPaymentLocked = false;

      setLoadingState(true);

      // STEP 1 — ORDER INITIATION
      final orderData = await _coursesService.initiateOrder(
        courseId: courseId,
        paymentMethod: 'razorpay',
      );

      if (orderData == null) {
        showErrorMessage(title: "Error", message: "Failed to initiate order");
        return;
      }

      // Extract order, payment, and razorpay data
      final orderObj = orderData['order'] as Map<String, dynamic>?;
      final paymentObj = orderData['payment'] as Map<String, dynamic>?;
      final razorpayObj = orderData['razorpay'] as Map<String, dynamic>?;

      final orderId = orderObj?['orderId'] as String?;
      final gatewayOrderId = paymentObj?['gatewayOrderId'] as String?;

      if (orderId == null) {
        showErrorMessage(
          title: "Error",
          message: "Invalid order data received. Missing orderId.",
        );
        return;
      }

      if (gatewayOrderId == null) {
        showErrorMessage(
          title: "Error",
          message: "Invalid order data received. Missing gatewayOrderId.",
        );
        return;
      }

      if (razorpayObj == null) {
        showErrorMessage(
          title: "Error",
          message:
              "Invalid order data received. Missing Razorpay configuration.",
        );
        return;
      }

      // Extract Razorpay configuration from API response
      final razorpayKey = razorpayObj['key'] as String?;
      final razorpayOrderId = razorpayObj['orderId'] as String?;
      final razorpayAmount = razorpayObj['amount'] as int?;
      final razorpayName = razorpayObj['name'] as String?;
      final razorpayDescription = razorpayObj['description'] as String?;
      final razorpayPrefill = razorpayObj['prefill'] as Map<String, dynamic>?;
      final razorpayNotes = razorpayObj['notes'] as Map<String, dynamic>?;

      if (razorpayKey == null ||
          razorpayOrderId == null ||
          razorpayAmount == null) {
        showErrorMessage(
          title: "Error",
          message: "Invalid Razorpay configuration. Missing required fields.",
        );
        return;
      }

      // Initialize Razorpay with the key from API response
      _razorpayService.initialize(
        keyId: razorpayKey,
        onSuccess: _handleRazorpaySuccess,
        onError: _handleRazorpayError,
        onFailure: _handleRazorpayFailure,
      );

      // STEP 2 — OPEN RAZORPAY CHECKOUT
      setLoadingState(false); // Close loading to show Razorpay

      _razorpayService.openCheckout(
        orderId: orderId,
        gatewayOrderId: razorpayOrderId, // Use Razorpay order ID from response
        amount: razorpayAmount ~/ 100, // Convert from paise to rupees
        name: razorpayName ?? 'AstroBharat Learning Portal',
        description: razorpayDescription ?? 'Course Enrollment',
        prefillEmail: razorpayPrefill?['email'] as String? ?? '',
        prefillContact: razorpayPrefill?['contact'] as String? ?? '',
        prefillName: razorpayPrefill?['name'] as String? ?? '',
        razorpayKey: razorpayKey,
        notes: razorpayNotes,
      );

      // Store orderId and gatewayOrderId for callbacks
      _pendingOrderId = orderId;
      _pendingGatewayOrderId = gatewayOrderId;
    } catch (e) {
      _processPaymentLocked = false;
      showErrorMessage(
        title: "Error",
        message: "Failed to purchase course: $e",
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Refresh
  Future<void> refresh() async {
    await loadCourseDetail();
  }
}
