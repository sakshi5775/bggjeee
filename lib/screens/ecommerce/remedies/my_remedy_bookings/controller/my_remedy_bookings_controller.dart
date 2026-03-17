import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/remedy_booking_model.dart';
import 'package:astrobharataiuser/data_model/remedy_category_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/services/remedies_service.dart';
import 'package:get/get.dart';

class MyRemedyBookingsController extends BaseController {
  final RemediesService _remediesService = Get.find<RemediesService>();

  final RxList<RemedyBookingItem> bookings = <RemedyBookingItem>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;

  int currentPage = 1;
  bool hasNextPage = false;
  static const int limit = 10;

  final RxString sortBy = 'createdAt'.obs;
  final RxString sortOrder = 'desc'.obs;
  final RxString statusFilter = 'all'.obs;

  static const List<String> sortByOptions = [
    'all',
    'createdAt',
    'preferredDate',
    'totalAmount',
  ];
  static const List<String> sortOrderOptions = ['all', 'asc', 'desc'];
  static const List<String> statusOptions = [
    'all',
    'pending',
    'payment_pending',
    'confirmed',
    'scheduled',
    'in_progress',
    'completed',
    'cancelled',
    'refunded',
    'on_hold',
  ];

  @override
  void onInit() {
    super.onInit();
    loadBookings(reset: true);
  }

  Future<void> loadBookings({bool reset = true}) async {
    if (reset) {
      currentPage = 1;
      isLoading.value = true;
      bookings.clear();
    } else {
      isLoadingMore.value = true;
    }
    try {
      final sb = sortBy.value == 'all' ? null : sortBy.value;
      final so = sortOrder.value == 'all' ? null : sortOrder.value;
      final st = statusFilter.value == 'all' ? null : statusFilter.value;

      final result = await _remediesService.getMyRemedyBookings(
        page: currentPage,
        limit: limit,
        sortBy: sb,
        sortOrder: so,
        status: st,
      );
      if (result != null) {
        if (reset) {
          bookings.assignAll(result.items);
        } else {
          bookings.addAll(result.items);
        }
        hasNextPage = result.pagination?.hasNextPage ?? false;
        if (hasNextPage) currentPage++;
      }
    } catch (e) {
      print('Error loading remedy bookings: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void setSortBy(String value) {
    sortBy.value = value;
    loadBookings(reset: true);
  }

  void setSortOrder(String value) {
    sortOrder.value = value;
    loadBookings(reset: true);
  }

  void setStatus(String value) {
    statusFilter.value = value;
    loadBookings(reset: true);
  }

  void refresh() => loadBookings(reset: true);
}
