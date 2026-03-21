import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/remedy_booking_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:astrobharataiuser/utils/user_friendly_error.dart';

class RemedyBookingFormController extends BaseController
    with WidgetsBindingObserver {
  final RemediesService _remediesService = Get.find<RemediesService>();
  Razorpay? _razorpay;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Customer
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alternatePhoneController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  // Booking
  final Rx<DateTime?> preferredDate = Rx<DateTime?>(null);
  final RxString preferredTimeSlot = 'morning'.obs; // morning, afternoon, evening
  final TextEditingController specialInstructionsController =
      TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  // Person details
  final TextEditingController personNameController = TextEditingController();
  final Rx<DateTime?> personDob = Rx<DateTime?>(null);
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController birthTimeController = TextEditingController();
  final TextEditingController gotraController = TextEditingController();
  final TextEditingController rashiController = TextEditingController();
  final TextEditingController nakshatraController = TextEditingController();

  final RxBool isSubmitting = false.obs;
  final RxBool isPaymentInProgress = false.obs;

  String? serviceId;
  String? serviceTitle;
  double? price;
  String? serviceImage;
  String? _createdBookingId;
  bool _isRecoveringPendingPayment = false;

  final List<String> timeSlots = ['morning', 'afternoon', 'evening'];

  final List<String> nakshatraList = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra',
    'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Purva Phalguni',
    'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha',
    'Jyeshtha', 'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana',
    'Dhanishta', 'Shatabhisha', 'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati',
  ];

  final List<String> rashiList = [
    'Mesha (Aries)', 'Vrishabha (Taurus)', 'Mithuna (Gemini)', 'Karka (Cancer)',
    'Simha (Leo)', 'Kanya (Virgo)', 'Tula (Libra)', 'Vrishchika (Scorpio)',
    'Dhanu (Sagittarius)', 'Makara (Capricorn)', 'Kumbha (Aquarius)', 'Meena (Pisces)',
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _parseArguments();
    _initRazorpay();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recoverPendingPaymentOnResume();
    }
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      serviceId = args['serviceId'] as String?;
      serviceTitle = args['title'] as String?;
      final p = args['price'];
      if (p != null) {
        if (p is int) price = p.toDouble();
        else if (p is double) price = p;
        else if (p is num) price = p.toDouble();
      }
      serviceImage = args['image'] as String?;
    }
  }

  void _initRazorpay() {
    try {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
    } catch (e, s) {
      CrashlyticsService.recordError(
        e,
        s,
        fatal: false,
        type: CrashErrorType.payment,
        reason: 'RAZORPAY_REMEDY_FORM_INIT',
      );
      _razorpay = null;
    }
  }

  void setPreferredDate(DateTime d) => preferredDate.value = d;
  void setPersonDob(DateTime d) => personDob.value = d;
  void setTimeSlot(String s) => preferredTimeSlot.value = s;

  String? _toIsoDate(DateTime? d) {
    if (d == null) return null;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String? _toIsoDateTime(DateTime? d) {
    if (d == null) return null;
    return '${_toIsoDate(d)}T10:00:00.000Z';
  }

  Future<void> submitBooking() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      return;
    }
    if (serviceId == null || serviceId!.isEmpty) {
      Get.snackbar('Error', 'Service not found', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    try {
      final customerDetails = RemedyBookingCustomerDetailsPayload(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        alternatePhone: alternatePhoneController.text.trim().isEmpty
            ? phoneController.text.trim()
            : alternatePhoneController.text.trim(),
        address: RemedyBookingAddress(
          addressLine1: addressLine1Controller.text.trim(),
          addressLine2: addressLine2Controller.text.trim().isEmpty
              ? null
              : addressLine2Controller.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          pincode: pincodeController.text.trim(),
          country: 'India',
        ),
      );

      final personDetails = RemedyBookingPersonDetails(
        name: personNameController.text.trim(),
        dateOfBirth: _toIsoDate(personDob.value),
        birthPlace: birthPlaceController.text.trim().isEmpty
            ? null
            : birthPlaceController.text.trim(),
        birthTime: birthTimeController.text.trim().isEmpty
            ? null
            : birthTimeController.text.trim(),
        gotra: gotraController.text.trim().isEmpty ? null : gotraController.text.trim(),
        rashi: rashiController.text.trim().isEmpty ? null : rashiController.text.trim(),
        nakshatra: nakshatraController.text.trim().isEmpty
            ? null
            : nakshatraController.text.trim(),
      );

      final bookingDetails = RemedyBookingDetailsPayload(
        preferredDate: _toIsoDateTime(preferredDate.value),
        preferredTimeSlot: preferredTimeSlot.value,
        specialInstructions: specialInstructionsController.text.trim().isEmpty
            ? null
            : specialInstructionsController.text.trim(),
        personDetails: personDetails,
        purpose: purposeController.text.trim().isEmpty
            ? null
            : purposeController.text.trim(),
        familyMembers: [],
      );

      final request = RemedyCreateBookingRequest(
        serviceId: serviceId!,
        customerDetails: customerDetails,
        bookingDetails: bookingDetails,
        paymentMethod: 'online',
      );

      final booking = await _remediesService.createRemedyBooking(request);
      if (booking != null && booking.id != null) {
        _createdBookingId = booking.id;
        await _initiatePayment(booking.id!);
      } else {
        Get.snackbar(
          'Booking Failed',
          'Could not create booking. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message: UserFriendlyError.message(
          e,
          fallback: 'Unable to submit booking. Please try again.',
        ),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _initiatePayment(String bookingId) async {
    isPaymentInProgress.value = true;
    try {
      final response = await _remediesService.initiateRemedyPayment(
        bookingId,
        paymentProvider: 'razorpay',
      );
      if (response != null &&
          response.success &&
          response.data != null &&
          response.data!.razorpayKeyId.isNotEmpty) {
        final d = response.data!;
        final orderId = d.razorpayOrder?.id ?? d.gatewayOrderId;
        final amount = d.razorpayOrder?.amount ?? (d.amount * 100).toInt();
        if (orderId.isEmpty) {
          Get.snackbar('Payment Error', 'Invalid order id');
          isPaymentInProgress.value = false;
          return;
        }
        final options = {
          'key': d.razorpayKeyId,
          'amount': amount,
          'currency': d.currency,
          'order_id': orderId,
          'name': 'AstroBharatai',
          'description': 'Remedy Booking - ${serviceTitle ?? "Remedy"}',
          'prefill': {
            'contact':
                UserData()
                    .getLoginData
                    .user
                    ?.phone
                    ?.replaceAll(RegExp(r'[^\d]'), '') ??
                phoneController.text.trim(),
            if (emailController.text.trim().isNotEmpty)
              'email': emailController.text.trim(),
            if (fullNameController.text.trim().isNotEmpty)
              'name': fullNameController.text.trim(),
          },
          'theme': {'color': '#FF9933'},
        };
        final rp = _razorpay;
        if (rp == null) {
          showErrorMessage(
            title: 'Payment Unavailable',
            message:
                'Payment could not be started. Please restart the app and try again.',
          );
        } else {
          rp.open(options);
        }
      } else {
        showErrorMessage(
          title: 'Payment Initiation Failed',
          message: UserFriendlyError.message(
            response?.message,
            fallback: 'Could not start payment. Please try again.',
          ),
        );
      }
    } catch (e) {
      showErrorMessage(
        title: 'Payment Error',
        message: UserFriendlyError.message(
          e,
          fallback: 'Payment could not be started. Please try again.',
        ),
      );
    } finally {
      isPaymentInProgress.value = false;
    }
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) async {
    isPaymentInProgress.value = true;
    try {
      final bookingId = _createdBookingId;
      if (bookingId == null) {
        Get.snackbar('Error', 'Booking id missing');
        return;
      }
      final verifyRequest = RemedyPaymentVerifyRequest(
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );
      await _remediesService.verifyRemedyPayment(bookingId, verifyRequest);
      _navigateToRemediesView();
      _createdBookingId = null;
      Get.snackbar(
        'Payment Successful',
        'Your remedy booking is confirmed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      showErrorMessage(
        title: 'Verification Error',
        message: UserFriendlyError.message(
          e,
          fallback: 'Payment verification failed. Please contact support.',
        ),
      );
    } finally {
      isPaymentInProgress.value = false;
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    _createdBookingId = null;
    Get.snackbar(
      'Payment Failed',
      UserFriendlyError.message(
        response.message,
        fallback: 'Payment could not be completed. Please try again.',
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
    );
    _navigateToRemediesView();
  }

  void _navigateToRemediesView() {
    UserMainController.popCurrentTabToRoot();
    UserMainController.pushInCurrentTab(AppRoutes.remedies);
  }

  bool _isSuccessfulPaymentStatus(String? status) {
    final normalized = status?.toLowerCase().trim();
    return normalized == 'completed' ||
        normalized == 'captured' ||
        normalized == 'paid' ||
        normalized == 'success' ||
        normalized == 'succeeded';
  }

  Future<void> _recoverPendingPaymentOnResume() async {
    if (_createdBookingId == null || _isRecoveringPendingPayment) return;
    _isRecoveringPendingPayment = true;
    try {
      final booking = await _remediesService.getRemedyBookingById(
        _createdBookingId!,
      );
      if (_isSuccessfulPaymentStatus(booking?.payment?.status)) {
        _navigateToRemediesView();
        Get.snackbar(
          'Payment Successful',
          'Your remedy booking is confirmed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
        _createdBookingId = null;
      }
    } catch (_) {
      // Keep silent during lifecycle recovery checks.
    } finally {
      _isRecoveringPendingPayment = false;
    }
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(
      'External Wallet',
      'Selected: ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    alternatePhoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    specialInstructionsController.dispose();
    purposeController.dispose();
    personNameController.dispose();
    birthPlaceController.dispose();
    birthTimeController.dispose();
    gotraController.dispose();
    rashiController.dispose();
    nakshatraController.dispose();
    _razorpay?.clear();
    super.onClose();
  }
}
