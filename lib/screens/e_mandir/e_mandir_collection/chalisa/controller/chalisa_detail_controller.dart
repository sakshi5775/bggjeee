import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/data_model/chalisa_detail_model.dart';
import '../service/chalisa_service.dart';

class ChalisaDetailController extends BaseController {
  final ChalisaService _chalisaService = Get.find<ChalisaService>();

  final Rxn<ChalisaDetail> chalisa = Rxn<ChalisaDetail>();
  final RxBool isLoading = false.obs;

  late String chalisaId;

  @override
  void onInit() {
    super.onInit();
    chalisaId = Get.arguments['chalisaId'] as String;
    fetchChalisaDetail();
  }

  Future<void> fetchChalisaDetail() async {
    try {
      isLoading.value = true;
      final response = await _chalisaService.getChalisaById(chalisaId);
      if (response != null && response.data?.chalisa != null) {
        chalisa.value = response.data!.chalisa;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
