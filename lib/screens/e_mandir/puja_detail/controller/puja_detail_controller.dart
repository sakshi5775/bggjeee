import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/puja_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/puja_service.dart';
import 'package:get/get.dart';

class PujaDetailController extends BaseController {
  final PujaService _pujaService = PujaService();

  final Rx<PujaModel?> puja = Rx<PujaModel?>(null);
  final RxString errorMessage = ''.obs;
  final RxString selectedPackageId = ''.obs;

  String? get pujaId => Get.arguments as String?;

  @override
  void onInit() {
    super.onInit();
    if (pujaId != null && pujaId!.isNotEmpty) {
      loadPujaDetail();
    } else {
      errorMessage.value = 'Pooja ID not provided';
    }
  }

  Future<void> loadPujaDetail() async {
    if (pujaId == null || pujaId!.isEmpty) return;

    setLoadingState(true);
    errorMessage.value = '';

    try {
      final pujaData = await _pujaService.getPujaById(pujaId!);

      if (pujaData != null) {
        puja.value = pujaData;
        // Select the first package by default or recommended package
        if (pujaData.packages != null && pujaData.packages!.isNotEmpty) {
          final recommended = pujaData.packages!.firstWhere(
            (p) => p.isRecommended == true,
            orElse: () => pujaData.packages!.first,
          );
          selectedPackageId.value = recommended.id ?? '';
        }
      } else {
        errorMessage.value = 'Failed to load puja details';
      }
    } catch (e) {
      errorMessage.value = 'Error loading puja: ${e.toString()}';
    } finally {
      setLoadingState(false);
    }
  }

  void selectPackage(String packageId) {
    selectedPackageId.value = packageId;
  }

  PujaPackage? getSelectedPackage() {
    if (puja.value?.packages == null || selectedPackageId.value.isEmpty) {
      return puja.value?.packages?.first;
    }
    try {
      return puja.value!.packages!.firstWhere(
        (p) => p.id == selectedPackageId.value,
        orElse: () => puja.value!.packages!.first,
      );
    } catch (e) {
      return puja.value!.packages!.first;
    }
  }

  double? getSelectedPrice() {
    final package = getSelectedPackage();
    return package?.price;
  }

  // Get timing/date from API
  String getTiming() {
    if (puja.value?.timing != null && puja.value!.timing!.isNotEmpty) {
      // Try to parse as DateTime
      try {
        final dateTime = DateTime.tryParse(puja.value!.timing!);
        if (dateTime != null) {
          // Format as DD/MM/YYYY HH:MM
          final day = dateTime.day.toString().padLeft(2, '0');
          final month = dateTime.month.toString().padLeft(2, '0');
          final year = dateTime.year;
          final hour = dateTime.hour.toString().padLeft(2, '0');
          final minute = dateTime.minute.toString().padLeft(2, '0');
          return '$day/$month/$year $hour:$minute';
        }
      } catch (e) {
        // If parsing fails, return as is
      }
      return puja.value!.timing!;
    }
    return 'Not specified';
  }

  // Get availability status from API
  String getAvailability() {
    if (puja.value?.status != null && puja.value!.status!.isNotEmpty) {
      return puja.value!.status!.toUpperCase();
    }
    return 'Active';
  }

  // Check if Samagri is included based on packages
  String getSamagriStatus() {
    if (puja.value?.packages != null && puja.value!.packages!.isNotEmpty) {
      final hasInclusions = puja.value!.packages!.any(
        (p) => p.inclusions != null && p.inclusions!.isNotEmpty,
      );
      return hasInclusions ? 'Included' : 'Not Included';
    }
    return 'Not Included';
  }

  // Get temple name for Priest info
  String getTempleName() {
    if (puja.value?.temple?.name != null &&
        puja.value!.temple!.name!.isNotEmpty) {
      return puja.value!.temple!.name!;
    }
    return 'Temple Info';
  }

  void onProceedToBook() {
    if (puja.value == null) return;

    final selectedPackage = getSelectedPackage();
    final packageIndex =
        puja.value!.packages?.indexWhere(
          (p) => p.id == selectedPackageId.value,
        ) ??
        0;

    // Navigate to address selection page
    Get.toNamed(
      AppRoutes.addressSelection,
      arguments: {
        'pujaId': puja.value!.id,
        'pujaTitle': puja.value!.title,
        'packageId': selectedPackage?.id,
        'packageIndex': packageIndex >= 0 ? packageIndex : 0,
        'personCount': selectedPackage?.personCount ?? 1,
        'price': selectedPackage?.price,
        'packageName': selectedPackage?.packageName,
      },
    );
  }
}
