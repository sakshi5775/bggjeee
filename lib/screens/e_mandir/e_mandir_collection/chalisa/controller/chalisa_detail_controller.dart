import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/data_model/chalisa_detail_model.dart';
import '../service/chalisa_service.dart';

class ChalisaDetailController extends BaseController {
  final ChalisaService _chalisaService = Get.find<ChalisaService>();

  final Rxn<ChalisaDetail> chalisa = Rxn<ChalisaDetail>();
  final RxBool isLoading = false.obs;

  late String chalisaId;

  /// Content type: 'chalisa' or 'aarti'
  late final String contentType;

  String get errorMessage => contentType == 'aarti'
      ? 'Unable to load aarti'
      : 'Unable to load chalisa';

  @override
  void onInit() {
    super.onInit();
    chalisaId = Get.arguments['chalisaId'] as String;
    contentType = (Get.arguments['contentType'] as String?) ?? 'chalisa';
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      final response = contentType == 'aarti'
          ? await _chalisaService.getAartiById(chalisaId)
          : await _chalisaService.getChalisaById(chalisaId);
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
