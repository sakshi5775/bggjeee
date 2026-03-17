import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:get/get.dart';

class RemedyDetailController extends BaseController {
  final RemediesService _remediesService = Get.find<RemediesService>();

  final Rx<RemedyModel?> service = Rx<RemedyModel?>(null);
  final RxBool isLoading = true.obs;

  String? get serviceId => service.value?.id;

  @override
  void onInit() {
    super.onInit();
    _loadService();
  }

  Future<void> _loadService() async {
    final args = Get.arguments;
    String? id = args is String ? args : args is Map ? args['serviceId'] as String? : null;
    if (id == null || id.isEmpty) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading.value = true;
      final s = await _remediesService.getRemedyServiceById(id);
      service.value = s;
    } catch (e) {
      print('Error loading remedy service: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void openBookingForm() {
    final s = service.value;
    if (s == null || s.id == null) return;
    Get.toNamed(
      AppRoutes.remedyBookingForm,
      arguments: {
        'serviceId': s.id,
        'title': s.title,
        'price': s.price,
        'image': s.image,
      },
    );
  }
}
