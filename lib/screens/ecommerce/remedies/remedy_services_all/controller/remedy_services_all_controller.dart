import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:get/get.dart';

class RemedyServicesAllController extends BaseController {
  final RemediesService _remediesService = Get.find<RemediesService>();

  final RxList<RemedyModel> services = <RemedyModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;

  int _page = 1;
  static const int _limit = 20;
  bool _hasNextPage = false;

  @override
  void onInit() {
    super.onInit();
    fetchServices(reset: true);
  }

  Future<void> fetchServices({bool reset = false}) async {
    if (reset) {
      _page = 1;
      services.clear();
      isLoading.value = true;
    } else {
      if (!_hasNextPage || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      final data = await _remediesService.getRemedyServices(
        page: _page,
        limit: _limit,
        isFeatured: true,
      );
      if (data?.items != null) {
        if (reset) {
          services.assignAll(data!.items!);
        } else {
          services.addAll(data!.items!);
        }
        _hasNextPage = data.pagination?.hasNextPage ?? false;
        if (_hasNextPage) _page++;
      }
    } catch (e) {
      print('RemedyServicesAllController fetch error: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
