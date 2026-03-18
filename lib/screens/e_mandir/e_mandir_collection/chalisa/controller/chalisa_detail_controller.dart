import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
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
    final args = Get.arguments;
    if (args == null || args is! Map) {
      // Missing arguments — avoid crashing (late/unchecked access).
      // Navigate back after first frame so routing can settle.
      WidgetsBinding.instance.addPostFrameCallback((_) => Get.back());
      return;
    }

    chalisaId = (args['chalisaId'] as String?) ?? '';
    contentType = (args['contentType'] as String?) ?? 'chalisa';
    if (chalisaId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Get.back());
      return;
    }

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
    } catch (e, s) {
      reportError(
        e,
        s,
        type: CrashErrorType.ui,
        reason: 'CHALISA_DETAIL_FETCH_FAILED',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
