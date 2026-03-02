import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/data_model/chalisa_model.dart';
import '../service/chalisa_service.dart';

class ChalisaController extends BaseController {
  final ChalisaService _chalisaService = Get.put(ChalisaService());

  final RxList<ChalisaItem> chalisas = <ChalisaItem>[].obs;
  final RxBool isLoading = false.obs;

  /// Content type: 'chalisa' or 'aarti'
  late final String contentType;

  String get pageTitle =>
      contentType == 'aarti' ? '🙏 Sacred Aartis' : '🙏 Sacred Chalisas';

  String get emptyMessage =>
      contentType == 'aarti' ? 'No aartis available' : 'No chalisas available';

  @override
  void onInit() {
    super.onInit();
    contentType = (Get.arguments?['contentType'] as String?) ?? 'chalisa';
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final response = contentType == 'aarti'
          ? await _chalisaService.getAartis()
          : await _chalisaService.getChalisas();
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
