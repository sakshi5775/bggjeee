import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/live_stream_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class StreamReportsController extends BaseController {
  final LiveStreamService _liveStreamService = LiveStreamService();

  final RxList<StreamReportModel> reports = <StreamReportModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final RxInt totalReports = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports({bool reset = false}) async {
    try {
      if (reset) {
        currentPage.value = 1;
        reports.clear();
        hasMore.value = true;
      }

      if (!hasMore.value && !reset) {
        return;
      }

      isLoading.value = true;

      final response = await _liveStreamService.getMyReports(
        page: currentPage.value,
        limit: 20,
      );

      if (response != null) {
        if (reset) {
          reports.value = response.reports;
        } else {
          reports.addAll(response.reports);
        }

        totalReports.value = response.pagination.total;
        hasMore.value = currentPage.value < response.pagination.totalPages;

        if (hasMore.value) {
          currentPage.value++;
        }
      }
    } catch (e) {
      debugPrint('Error loading reports: $e');
      Get.snackbar(
        'Error',
        'Failed to load reports. Please try again.',
        snackPosition: Get.isBottomSheetOpen == true || Get.isDialogOpen == true
            ? SnackPosition.TOP
            : SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getCategoryLabel(String category) {
    switch (category) {
      case 'UNPROFESSIONAL_BEHAVIOUR':
        return 'Unprofessional Behaviour';
      case 'ABUSIVE_CONTENT':
        return 'Abusive Content/Harmful';
      case 'MISGUIDANCE':
        return 'Misguidance';
      case 'CONTACT_SHARING':
        return 'Contact Sharing';
      case 'OTHERS':
        return 'Others';
      default:
        return category;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Pending';
      case 'REVIEWED':
        return 'Reviewed';
      case 'RESOLVED':
        return 'Resolved';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }
}

