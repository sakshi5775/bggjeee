import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/data_model/remedy_booking_model.dart';
import 'package:astrobharataiuser/data_model/remedy_category_model.dart';
import 'package:astrobharataiuser/data_model/remedy_model.dart';
import 'package:get/get.dart';

class RemediesService extends GetxService {
  final ApiRepository _apiRepository = Get.find<ApiRepository>();

  // Fetch Store Categories (using existing categories API)
  Future<List<CategoryModel>> getStoreCategories() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.ecommerceCategories,
        query: {
          'page': '1',
          'limit': '10',
          'isActive': 'true',
          'isFeatured': 'true',
        },
      );

      if (response.status.hasError) return [];
      if (response.body['success'] == true && response.body['data'] != null) {
        final data = response.body['data'];
        List itemsList = [];
        if (data is Map && data.containsKey('items')) {
          itemsList = data['items'];
        } else if (data is List) {
          itemsList = data;
        }
        return itemsList.map((e) => CategoryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching store categories: $e");
      return [];
    }
  }

  /// Active remedy categories list (no pagination). Search in title and offerLine via categories API with search.
  Future<List<RemedyCategoryModel>> getActiveRemedyCategories() async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.remedyCategoriesActiveList,
      );
      if (response.status.hasError) return [];
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data']['categories'] is List) {
        final list = response.body['data']['categories'] as List;
        return list
            .whereType<Map<String, dynamic>>()
            .map(RemedyCategoryModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      print("Error fetching active remedy categories: $e");
      return [];
    }
  }

  /// Remedy categories with pagination and search (search in title and offer line)
  Future<RemedyCategoryData?> getRemedyCategories({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _apiRepository.getApi(
        EndPoints.remedyCategories,
        query: queryParams,
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true && response.body['data'] != null) {
        return RemedyCategoryData.fromJson(response.body['data']);
      }
      return null;
    } catch (e) {
      print("Error fetching remedy categories: $e");
      return null;
    }
  }

  /// Single remedy category by id
  Future<RemedyCategoryModel?> getRemedyCategoryById(String id) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.remedyCategoryById(id),
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data']['category'] != null) {
        return RemedyCategoryModel.fromJson(
          response.body['data']['category'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print("Error fetching remedy category by id: $e");
      return null;
    }
  }

  /// Featured remedy services (limit)
  Future<List<RemedyModel>> getFeaturedRemedyServices({int limit = 10}) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.remedyServicesFeaturedList,
        query: {'limit': limit.toString()},
      );
      if (response.status.hasError) return [];
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data']['services'] is List) {
        final list = response.body['data']['services'] as List;
        return list
            .whereType<Map<String, dynamic>>()
            .map(RemedyModel.fromJson)
            .toList();
      }
      return [];
    } catch (e) {
      print("Error fetching featured remedy services: $e");
      return [];
    }
  }

  /// Remedy services by category id (paginated)
  Future<RemedyData?> getRemediesByCategoryPaginated({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.remedyServicesByCategory(categoryId),
        query: {'page': page.toString(), 'limit': limit.toString()},
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true && response.body['data'] != null) {
        return RemedyData.fromJson(response.body['data']);
      }
      return null;
    } catch (e) {
      print("Error fetching remedies by category: $e");
      return null;
    }
  }

  /// Fetch Remedies by Category (list only, backward compatible)
  Future<List<RemedyModel>> getRemediesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final data = await getRemediesByCategoryPaginated(
      categoryId: categoryId,
      page: page,
      limit: limit,
    );
    return data?.items ?? [];
  }

  /// All remedy services with filters: search (title, description), category, isFeatured, minPrice, maxPrice, sortBy (all, title, price, createdAt, sortOrder), sortOrder (asc, desc)
  Future<RemedyData?> getRemedyServices({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    bool? isFeatured,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (isFeatured != null) queryParams['isFeatured'] = isFeatured.toString();
      if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
      if (sortBy != null && sortBy.isNotEmpty && sortBy != 'all') queryParams['sortBy'] = sortBy;
      if (sortOrder != null && sortOrder.isNotEmpty && sortOrder != 'all') queryParams['sortOrder'] = sortOrder;

      final response = await _apiRepository.getApi(
        EndPoints.remedyServices,
        query: queryParams,
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true && response.body['data'] != null) {
        return RemedyData.fromJson(response.body['data']);
      }
      return null;
    } catch (e) {
      print("Error fetching remedy services: $e");
      return null;
    }
  }

  /// Single remedy service by id
  Future<RemedyModel?> getRemedyServiceById(String id) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.remedyServiceById(id),
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data']['service'] != null) {
        return RemedyModel.fromJson(
          response.body['data']['service'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print("Error fetching remedy service by id: $e");
      return null;
    }
  }

  // --------------- Remedy Bookings ---------------

  Future<RemedyBookingItem?> createRemedyBooking(
    RemedyCreateBookingRequest request,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.remedyBookings,
        request.toJson(),
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data']['booking'] != null) {
        return RemedyBookingItem.fromJson(
          response.body['data']['booking'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print("Error creating remedy booking: $e");
      rethrow;
    }
  }

  /// My bookings: sortBy (all, createdAt, preferredDate, totalAmount), sortOrder (all, asc, desc), status (all, pending, payment_pending, confirmed, scheduled, in_progress, completed, cancelled, refunded, on_hold)
  Future<RemedyBookingsListResponse?> getMyRemedyBookings({
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortOrder,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (sortBy != null && sortBy.isNotEmpty && sortBy != 'all') queryParams['sortBy'] = sortBy;
      if (sortOrder != null && sortOrder.isNotEmpty && sortOrder != 'all') queryParams['sortOrder'] = sortOrder;
      if (status != null && status.isNotEmpty && status != 'all') queryParams['status'] = status;

      final response = await _apiRepository.getApi(
        EndPoints.remedyBookingsMyBookings,
        query: queryParams,
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true && response.body['data'] != null) {
        return RemedyBookingsListResponse.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print("Error fetching my remedy bookings: $e");
      rethrow;
    }
  }

  /// Get booking by MongoDB _id
  Future<RemedyBookingItem?> getRemedyBookingById(String id) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.remedyBookingById(id),
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data']['booking'] != null) {
        return RemedyBookingItem.fromJson(
          response.body['data']['booking'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print("Error fetching remedy booking by id: $e");
      rethrow;
    }
  }

  /// Get booking by bookingId (e.g. RB202603170001)
  Future<RemedyBookingItem?> getRemedyBookingByBookingId(String bookingId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.remedyBookingByBookingId(bookingId),
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data']['booking'] != null) {
        return RemedyBookingItem.fromJson(
          response.body['data']['booking'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print("Error fetching remedy booking by bookingId: $e");
      rethrow;
    }
  }

  Future<RemedyBookingItem?> cancelRemedyBooking(String id, String reason) async {
    try {
      final response = await _apiRepository.putApiCall(
        EndPoints.remedyBookingCancel(id),
        {'reason': reason},
      );
      if (response.status.hasError) return null;
      if (response.body['success'] == true &&
          response.body['data'] != null &&
          response.body['data']['booking'] != null) {
        return RemedyBookingItem.fromJson(
          response.body['data']['booking'] as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      print("Error cancelling remedy booking: $e");
      rethrow;
    }
  }

  Future<RemedyPaymentInitiateResponse?> initiateRemedyPayment(
    String bookingId,
    {String paymentProvider = 'razorpay'}
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.remedyBookingInitiatePayment(bookingId),
        {'paymentProvider': paymentProvider},
      );
      if (response.status.hasError) return null;
      return RemedyPaymentInitiateResponse.fromJson(response.body);
    } catch (e) {
      print("Error initiating remedy payment: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> verifyRemedyPayment(
    String bookingId,
    RemedyPaymentVerifyRequest request,
  ) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.remedyBookingVerifyPayment(bookingId),
        request.toJson(),
      );
      if (response.status.hasError) return null;
      return response.body as Map<String, dynamic>?;
    } catch (e) {
      print("Error verifying remedy payment: $e");
      rethrow;
    }
  }
}
