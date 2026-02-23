import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:get/get.dart';

class RemedyCategoryListingController extends BaseController {
  final RemediesService _remediesService = Get.find<RemediesService>();

  final RxList<RemedyModel> remedies = <RemedyModel>[].obs;
  final RxBool isLoading = true.obs;

  // Arguments
  String categoryId = '';
  String categoryTitle = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      categoryId = Get.arguments['categoryId'] ?? '';
      categoryTitle = Get.arguments['title'] ?? '';
    }
    _fetchRemedies();
  }

  Future<void> _fetchRemedies() async {
    if (categoryId.isEmpty) {
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final result = await _remediesService.getRemediesByCategory(
        categoryId: categoryId,
      );
      remedies.assignAll(result);
    } catch (e) {
      print("Error fetching remedies by category: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
