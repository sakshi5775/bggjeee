import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/data_model/chalisa_model.dart';
import '../service/chalisa_service.dart';

class ChalisaController extends BaseController {
  final ChalisaService _chalisaService = Get.put(ChalisaService());

  final RxList<ChalisaItem> chalisas = <ChalisaItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChalisas();
  }

  Future<void> fetchChalisas() async {
    try {
      isLoading.value = true;
      final response = await _chalisaService.getChalisas();
      if (response != null && response.data != null) {
        chalisas.assignAll(response.data!.items);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
