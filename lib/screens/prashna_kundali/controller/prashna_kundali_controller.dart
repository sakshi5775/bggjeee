import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/prashna_kundali_model.dart';
import 'package:astrobharataiuser/screens/prashna_kundali/service/prashna_kundali_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PrashnaKundaliController extends BaseController {
  final PrashnaKundaliService _service = PrashnaKundaliService();

  // State
  final RxList<PrashnaQuestion> questions = <PrashnaQuestion>[].obs;
  final Rxn<PrashnaQuestion> selectedQuestion = Rxn<PrashnaQuestion>();
  final RxBool isLoadingQuestions = false.obs;
  final RxBool isAnalyzing = false.obs;
  final Rxn<PrashnaReading> analysisResult = Rxn<PrashnaReading>();

  // History
  final RxList<PrashnaReading> historyReadings = <PrashnaReading>[].obs;
  final RxBool isLoadingHistory = false.obs;
  final Rxn<Pagination> pagination = Rxn<Pagination>();

  // Location
  final RxString currentCity = "Fetching location...".obs;
  double? latitude;
  double? longitude;
  double timezone = 5.5;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
    _fetchCurrentLocation();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoadingQuestions.value = true;
      final fetchedQuestions = await _service.getQuestions();
      questions.assignAll(fetchedQuestions);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingQuestions.value = false;
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;

        // Use AddressHelper to get city and timezone
        final timezoneStr = await AddressHelper.getTimezoneFromCoordinates(
          latitude!,
          longitude!,
        );
        if (timezoneStr != null) {
          if (timezoneStr.contains("Kolkata")) {
            timezone = 5.5;
          }
          // derive offset from string if possible, otherwise stick to default
        }

        // Fetch city name via reverse geocoding
        final address = await AddressHelper.reverseGeocode(
          latitude!,
          longitude!,
        );
        if (address != null && address['city'] != null) {
          currentCity.value = address['city'];
        } else {
          currentCity.value = "Current Location";
        }
      } else {
        currentCity.value = "Location permission denied";
      }
    } catch (e) {
      currentCity.value = "Location unavailable";
      print("Location error: $e");
    }
  }

  Future<void> analyzeQuestion() async {
    if (selectedQuestion.value == null) {
      Get.snackbar('Wait', 'Please select a question first');
      return;
    }

    if (latitude == null || longitude == null) {
      Get.snackbar('Error', 'Location not available. Please enable location.');
      return;
    }

    // Check balance
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      if (!pricingCtrl.hasSufficientBalance('prashna_kundli')) {
        pricingCtrl.showInsufficientBalancePopup('prashna_kundli');
        return;
      }
    }

    try {
      isAnalyzing.value = true;
      final request = PrashnaAnalysisRequest(
        questionId: selectedQuestion.value!.id,
        location: PrashnaLocation(
          city: currentCity.value,
          latitude: latitude!,
          longitude: longitude!,
          timezone: timezone,
        ),
      );

      final result = await _service.analyzePrashna(
        request,
        timeout: const Duration(minutes: 5),
      );
      analysisResult.value = result;
      Get.toNamed(
        AppRoutes.prashnaKundaliResults,
        arguments: {'result': result},
      );
    } catch (e) {
      Get.snackbar('Analysis Failed', e.toString());
    } finally {
      isAnalyzing.value = false;
    }
  }

  Future<void> fetchHistory({int page = 1}) async {
    try {
      isLoadingHistory.value = true;
      final response = await _service.getHistory(page: page);
      if (page == 1) {
        historyReadings.assignAll(response.data);
      } else {
        historyReadings.addAll(response.data);
      }
      pagination.value = response.pagination;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingHistory.value = false;
    }
  }

  void selectQuestion(PrashnaQuestion question) {
    selectedQuestion.value = question;
  }
}
