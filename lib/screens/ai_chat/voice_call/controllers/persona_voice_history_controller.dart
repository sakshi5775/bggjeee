import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/ai_chat/voice_call/services/persona_voice_call_service.dart';

import 'package:get/get.dart';

class PersonaVoiceHistoryController extends BaseController {
  final String? personaId;
  final VoiceCallService _service = VoiceCallService();

  PersonaVoiceHistoryController({this.personaId});

  final RxList<Map<String, dynamic>> calls = <Map<String, dynamic>>[].obs;
  final RxInt total = 0.obs;
  final RxString status =
      ''.obs; // INITIATED, CONNECTED, IN_PROGRESS, COMPLETED, FAILED, CANCELLED
  final RxString sortBy = 'createdAt'.obs;
  final RxString sortOrder = 'desc'.obs;
  final RxInt limit = 20.obs;
  final RxInt skip = 0.obs;

  Future<void> load({bool reset = true}) async {
    if (reset) {
      skip.value = 0;
      calls.clear();
    }
    setLoadingState(true);
    try {
      final data = await _service.getHistory(
        personaId: personaId,
        limit: limit.value,
        skip: skip.value,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
        status: status.value.isEmpty ? null : status.value,
      );
      final list =
          (data?['calls'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      total.value = data?['total'] as int? ?? list.length;
      calls.addAll(list);
    } finally {
      setLoadingState(false);
    }
  }

  void updateStatus(String value) {
    status.value = value;
    load();
  }

  void updateSortOrder(String value) {
    sortOrder.value = value;
    load();
  }

  // Compute remaining time (10 minutes window) for active calls
  String computeRemaining(Map<String, dynamic> call) {
    final s = (call['status'] ?? '').toString();
    if (s == 'INITIATED' || s == 'CONNECTED' || s == 'IN_PROGRESS') {
      final createdAt = DateTime.tryParse((call['createdAt'] ?? '').toString());
      if (createdAt != null) {
        final elapsed = DateTime.now()
            .toUtc()
            .difference(createdAt.toUtc())
            .inSeconds;
        final remain = 600 - elapsed;
        final r = remain.clamp(0, 600);
        final m = (r ~/ 60).toString().padLeft(2, '0');
        final sec = (r % 60).toString().padLeft(2, '0');
        return '$m:$sec';
      }
    }
    return '';
  }
}
