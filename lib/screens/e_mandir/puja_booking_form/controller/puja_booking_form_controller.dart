import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/data_model/payment_model.dart';
import 'package:astrobharataiuser/data_model/puja_booking_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_booking_form/service/puja_booking_service.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_booking_form/service/puja_payment_service.dart';
import 'package:astrobharataiuser/core/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:astrobharataiuser/utils/user_friendly_error.dart';

/// Controller for each participant form
class ParticipantFormData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gotraController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController whatsAppController = TextEditingController();
  final TextEditingController nakshatraController = TextEditingController();
  final TextEditingController rashiController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final RxBool sameAsPhone = false.obs;

  void dispose() {
    nameController.dispose();
    gotraController.dispose();
    mobileController.dispose();
    whatsAppController.dispose();
    nakshatraController.dispose();
    rashiController.dispose();
    relationController.dispose();
  }

  ParticipantModel toModel() {
    return ParticipantModel(
      name: nameController.text.trim(),
      gotra: gotraController.text.trim(),
      mobile: mobileController.text.trim(),
      whatsApp: sameAsPhone.value
          ? mobileController.text.trim()
          : whatsAppController.text.trim(),
      nakshatra: nakshatraController.text.trim().isNotEmpty
          ? nakshatraController.text.trim()
          : null,
      rashi: rashiController.text.trim().isNotEmpty
          ? rashiController.text.trim()
          : null,
      relation: relationController.text.trim().isNotEmpty
          ? relationController.text.trim()
          : null,
    );
  }
}

class PujaBookingFormController extends BaseController with WidgetsBindingObserver {
  final PujaBookingService _bookingService = PujaBookingService();
  final PujaPaymentService _paymentService = PujaPaymentService();

  // Razorpay instance
  late Razorpay _razorpay;

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Sankalp notes controller
  final TextEditingController sankalpNotesController = TextEditingController();

  // Participant form data list
  final RxList<ParticipantFormData> participantForms =
      <ParticipantFormData>[].obs;

  // Booking state
  final RxBool isBooking = false.obs;
  final RxBool isPaymentInProgress = false.obs;
  final RxInt currentExpandedIndex = 0.obs;

  // Current booking ID for payment
  String? _currentBookingId;
  bool _isRecoveringPendingPayment = false;

  // Arguments from previous page
  String? pujaId;
  String? pujaTitle;
  int packageIndex = 0;
  int personCount = 1;
  double? price;
  String? packageName;
  AddressModel? selectedAddress;

  // Nakshatra list for dropdown
  final List<String> nakshatraList = [
    'Ashwini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigashira',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Ashlesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Swati',
    'Vishakha',
    'Anuradha',
    'Jyeshtha',
    'Mula',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati',
  ];

  // Rashi list for dropdown
  final List<String> rashiList = [
    'Mesha (Aries)',
    'Vrishabha (Taurus)',
    'Mithuna (Gemini)',
    'Karka (Cancer)',
    'Simha (Leo)',
    'Kanya (Virgo)',
    'Tula (Libra)',
    'Vrishchika (Scorpio)',
    'Dhanu (Sagittarius)',
    'Makara (Capricorn)',
    'Kumbha (Aquarius)',
    'Meena (Pisces)',
  ];

  // Relation list for dropdown
  final List<String> relationList = [
    'Self',
    'Spouse',
    'Father',
    'Mother',
    'Son',
    'Daughter',
    'Brother',
    'Sister',
    'Grandfather',
    'Grandmother',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _parseArguments();
    _initializeParticipantForms();
    _initializeRazorpay();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recoverPendingPaymentOnResume();
    }
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      pujaId = args['pujaId'] as String?;
      pujaTitle = args['pujaTitle'] as String?;
      packageIndex = args['packageIndex'] as int? ?? 0;
      personCount = args['personCount'] as int? ?? 1;
      final priceArg = args['price'];
      if (priceArg != null) {
        if (priceArg is int) {
          price = priceArg.toDouble();
        } else if (priceArg is double) {
          price = priceArg;
        } else if (priceArg is num) {
          price = priceArg.toDouble();
        }
      } else {
        price = null;
      }
      packageName = args['packageName'] as String?;
      selectedAddress = args['address'] as AddressModel?;
    }
  }

  void _initializeParticipantForms() {
    // Create form data for each participant based on personCount
    for (int i = 0; i < personCount; i++) {
      participantForms.add(ParticipantFormData());
    }
  }

  void toggleExpandedIndex(int index) {
    if (currentExpandedIndex.value == index) {
      currentExpandedIndex.value = -1; // Collapse
    } else {
      currentExpandedIndex.value = index;
    }
  }

  void toggleSameAsPhone(int index, bool value) {
    if (index < participantForms.length) {
      participantForms[index].sameAsPhone.value = value;
      if (value) {
        participantForms[index].whatsAppController.text =
            participantForms[index].mobileController.text;
      }
    }
  }

  Future<void> submitBooking() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      return;
    }

    isBooking.value = true;

    try {
      // Build participants list
      final participants = participantForms
          .map((form) => form.toModel())
          .toList();

      // Create booking request
      final request = PujaBookingRequest(
        puja: pujaId,
        packageIndex: packageIndex,
        participants: participants,
        sankalpNotes: sankalpNotesController.text.trim().isNotEmpty
            ? sankalpNotesController.text.trim()
            : null,
        savedAddressId: selectedAddress?.id,
      );

      final bookingId = await _bookingService.createBooking(request);
      print('Booking response: $bookingId');
      if (bookingId != null) {
        _currentBookingId = bookingId;
        // Initiate payment after booking creation
        await _initiatePayment(bookingId);
      } else {
        Get.snackbar(
          'Booking Failed',
          'Unable to complete booking. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
        isBooking.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        UserFriendlyError.message(
          e,
          fallback: 'An error occurred while creating booking. Please try again.',
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      isBooking.value = false;
    }
  }

  Future<void> _initiatePayment(String bookingId) async {
    isPaymentInProgress.value = true;

    try {
      final request = PujaPaymentInitiateRequest(
        bookingId: bookingId,
        paymentProvider: 'razorpay',
      );

      final response = await _paymentService.initiatePayment(request);

      if (response != null &&
          response.success &&
          response.data != null &&
          response.data!.order != null) {
        _openRazorpayCheckout(response.data!);
      } else {
        Get.snackbar(
          'Payment Initiation Failed',
          UserFriendlyError.message(
            response?.message,
            fallback: 'Unable to initiate payment. Please try again.',
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
        isBooking.value = false;
        isPaymentInProgress.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Payment Error',
        UserFriendlyError.message(
          e,
          fallback: 'An error occurred while initiating payment.',
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      isBooking.value = false;
      isPaymentInProgress.value = false;
    }
  }

  void _openRazorpayCheckout(PujaPaymentInitiateData paymentData) {
    var options = {
      'key': paymentData.razorpayKeyId,
      'amount': paymentData.order!.amount,
      'currency': paymentData.order!.currency,
      'order_id': paymentData.order!.id,
      'name': 'AstroBharatai',
      'description': 'Pooja Booking Payment',
      'prefill': {
        'contact':
            UserData().getLoginData.user?.phone?.replaceAll(RegExp(r'[^\d]'), '') ??
            '',
      },
      'theme': {
        'color': '#FF9933', // Saffron color
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.snackbar(
        'Error',
        UserFriendlyError.message(
          e,
          fallback: 'Unable to open payment gateway.',
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      isBooking.value = false;
      isPaymentInProgress.value = false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    isPaymentInProgress.value = true;

    try {
      final verifyRequest = PujaPaymentVerifyRequest(
        bookingId: _currentBookingId ?? '',
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );

      final verifyResponse = await _paymentService.verifyPayment(verifyRequest);

      if (verifyResponse != null && verifyResponse.success) {
        // Log Analytics
        AnalyticsService().logBookService(
          serviceName: pujaTitle ?? 'Puja',
          price: price,
        );

        UserMainController.popUntilInCurrentTab(
          (route) => route.settings.name == AppRoutes.bookPuja,
        );
        UserMainController.pushInCurrentTab(AppRoutes.myBookings);
        Get.snackbar(
          'Payment Successful! 🎉',
          'Your puja has been booked and payment completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Payment Verification Failed',
          verifyResponse?.message ??
              'Unable to verify payment. Please contact support.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        // Navigate to bookings anyway - the booking is created
        UserMainController.popUntilInCurrentTab(
          (route) => route.settings.name == AppRoutes.bookPuja,
        );
        UserMainController.pushInCurrentTab(AppRoutes.myBookings);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        UserFriendlyError.message(
          e,
          fallback: 'An error occurred while verifying payment.',
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isBooking.value = false;
      isPaymentInProgress.value = false;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isBooking.value = false;
    isPaymentInProgress.value = false;

    Get.snackbar(
      'Payment Failed',
      'Payment could not be completed. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );

    // Optionally navigate to my bookings to show pending payment
    UserMainController.popUntilInCurrentTab(
      (route) => route.settings.name == AppRoutes.bookPuja,
    );
    UserMainController.pushInCurrentTab(AppRoutes.myBookings);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(
      'External Wallet',
      'External wallet selected: ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withValues(alpha: 0.9),
      colorText: Colors.white,
    );
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
    if (_currentBookingId == null || _isRecoveringPendingPayment) return;
    _isRecoveringPendingPayment = true;
    try {
      final status = await _bookingService.getBookingPaymentStatus(
        _currentBookingId!,
      );
      if (_isSuccessfulPaymentStatus(status)) {
        UserMainController.popUntilInCurrentTab(
          (route) => route.settings.name == AppRoutes.bookPuja,
        );
        UserMainController.pushInCurrentTab(AppRoutes.myBookings);
        Get.snackbar(
          'Payment Successful! 🎉',
          'Your puja has been booked and payment completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        _currentBookingId = null;
      }
    } catch (_) {
      // Keep silent during lifecycle recovery checks.
    } finally {
      _isRecoveringPendingPayment = false;
    }
  }

  // Validators
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.trim().length < 10) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    sankalpNotesController.dispose();
    for (var form in participantForms) {
      form.dispose();
    }
    _razorpay.clear();
    super.onClose();
  }
}
