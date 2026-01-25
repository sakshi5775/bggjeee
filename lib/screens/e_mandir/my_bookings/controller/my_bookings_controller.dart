import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/my_booking_model.dart';
import 'package:astrobharataiuser/screens/e_mandir/my_bookings/service/my_bookings_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBookingsController extends BaseController {
  final MyBookingsService _bookingsService = MyBookingsService();

  final RxList<MyBookingItemModel> bookings = <MyBookingItemModel>[].obs;
  final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;
  final int limit = 10;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadBookings();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreBookings();
      }
    });
  }

  Future<void> loadBookings() async {
    setLoadingState(true);
    errorMessage.value = '';
    currentPage.value = 1;

    try {
      final result = await _bookingsService.getMyBookings(
        page: currentPage.value,
        limit: limit,
      );
      if (result != null) {
        bookings.value = result.items ?? [];
        pagination.value = result.pagination;
      } else {
        errorMessage.value = 'Failed to load bookings';
      }
    } catch (e) {
      errorMessage.value = 'Error loading bookings: ${e.toString()}';
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> loadMoreBookings() async {
    if (isLoadingMore.value) return;
    if (pagination.value?.hasNextPage != true) return;

    isLoadingMore.value = true;

    try {
      currentPage.value++;
      final result = await _bookingsService.getMyBookings(
        page: currentPage.value,
        limit: limit,
      );
      if (result != null && result.items != null) {
        bookings.addAll(result.items!);
        pagination.value = result.pagination;
      }
    } catch (e) {
      currentPage.value--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshBookings() async {
    await loadBookings();
  }

  void onBookingTap(MyBookingItemModel booking) {
    if (booking.id == null) return;
    Get.toNamed(
      AppRoutes.myBookingDetail,
      arguments: {'bookingId': booking.id},
    );
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'pending_payment':
        return const Color(0xFFFF9800);
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'in_progress':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF8BC34A);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
