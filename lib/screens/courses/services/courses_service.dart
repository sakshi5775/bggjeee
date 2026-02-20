import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/data_model/payment_process_model.dart';
import 'package:get/get.dart';

class CoursesService {
  final ApiRepository _apiRepository = Get.find();

  // Get courses with pagination and filters
  Future<CourseResponse?> getCourses({
    int page = 1,
    int limit = 10,
    bool? isPublished,
    String? search,
    String? instructor,
  }) async {
    final query = <String, dynamic>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (isPublished != null) {
      query['isPublished'] = isPublished.toString();
    }

    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }

    if (instructor != null && instructor.isNotEmpty) {
      query['instructor'] = instructor;
    }

    final response = await _apiRepository.getApi(
      EndPoints.courses,
      query: query,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return CourseResponse.fromJson(response.body);
      }
    }

    throw response.body?['message']?.toString() ?? 'Failed to fetch courses';
  }

  // Get single course by ID
  Future<CourseDetailModel?> getCourseById(String id) async {
    final response = await _apiRepository.getApi(EndPoints.courseById(id));

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return CourseDetailModel.fromJson(response.body);
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to fetch course details';
  }

  // Get lectures by course ID
  Future<List<LectureModel>?> getLecturesByCourseId(String courseId) async {
    final response = await _apiRepository.getApi(
      EndPoints.courseLectures(courseId),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        final data = response.body['data'] as List<dynamic>;
        return data
            .map((e) => LectureModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to fetch course lectures';
  }

  // Get lecture by ID
  Future<LectureModel?> getLectureById(String id) async {
    final response = await _apiRepository.getApi(EndPoints.lectureById(id));

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        final data = response.body['data'] as Map<String, dynamic>;
        return LectureModel.fromJson(data);
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to fetch lecture details';
  }

  // Get content by ID
  Future<ContentModel?> getContentById(String id) async {
    final response = await _apiRepository.getApi(EndPoints.contentById(id));

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic>? contentData;

      if (response.body is Map<String, dynamic>) {
        final body = response.body as Map<String, dynamic>;
        if (body['success'] == true && body['data'] != null) {
          contentData = body['data'] as Map<String, dynamic>?;
        } else if (body['_id'] != null || body['id'] != null) {
          contentData = body;
        }
      }

      if (contentData != null) {
        final url =
            contentData['url'] as String? ??
            contentData['fileUrl'] as String? ??
            contentData['contentUrl'] as String? ??
            '';
        if (url.isNotEmpty) {
          contentData['url'] = url;
        }
        return ContentModel.fromJson(contentData);
      }
    }

    throw response.body?['message']?.toString() ?? 'Failed to fetch content';
  }

  // Initiate order
  Future<Map<String, dynamic>?> initiateOrder({
    required String courseId,
    required String paymentMethod,
  }) async {
    final response = await _apiRepository.postApi(EndPoints.ordersInitiate, {
      'courseId': courseId,
      'paymentMethod': paymentMethod,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return response.body['data'] as Map<String, dynamic>;
      }
    }

    throw response.body?['message']?.toString() ?? 'Failed to initiate order';
  }

  // Process payment
  Future<PaymentProcessResponse?> processPayment({
    required String orderId,
    required String gatewayOrderId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final body = <String, dynamic>{
      'orderId': orderId,
      'gatewayOrderId': gatewayOrderId,
      'razorpay_order_id': razorpayOrderId,
      'razorpay_payment_id': razorpayPaymentId,
      'razorpay_signature': razorpaySignature,
    };

    final response = await _apiRepository.postApi(
      EndPoints.paymentsProcess,
      body,
    );

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.body is Map &&
        response.body['success'] == true) {
      return PaymentProcessResponse.fromJson(response.body);
    }

    throw response.body?['message']?.toString() ?? 'Failed to process payment';
  }

  // Get enrollments
  Future<Map<String, dynamic>?> getEnrollments({int page = 1}) async {
    // API is currently not working - returning null to avoid errors
    return null;
    /*
    final response = await _apiRepository.getApi(
      EndPoints.enrollments,
      query: {'page': page.toString()},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body is Map<String, dynamic>) {
        if (response.body['success'] == true) {
          return response.body['data'] as Map<String, dynamic>? ??
              response.body as Map<String, dynamic>;
        }
        return response.body as Map<String, dynamic>;
      } else if (response.body is List) {
        return {'courses': response.body};
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to fetch enrollments';
    */
  }

  // Check enrollment
  Future<Map<String, dynamic>?> checkEnrollment(String courseId) async {
    final response = await _apiRepository.getApi(
      EndPoints.enrollmentCheck(courseId),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return response.body['data'] as Map<String, dynamic>?;
      }
    }

    throw response.body?['message']?.toString() ?? 'Failed to check enrollment';
  }

  // Get progress overview
  Future<Map<String, dynamic>?> getProgressOverview() async {
    // API is currently not working - returning null to avoid errors
    return null;
    /*
    final response = await _apiRepository.getApi(EndPoints.progressOverview);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body is Map<String, dynamic>) {
        if (response.body['success'] == true) {
          return response.body['data'] as Map<String, dynamic>? ??
              response.body as Map<String, dynamic>;
        }
        return response.body as Map<String, dynamic>;
      } else if (response.body is List) {
        return {'courses': response.body};
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to fetch progress overview';
    */
  }

  // Get course progress
  Future<Map<String, dynamic>?> getCourseProgress(String courseId) async {
    final response = await _apiRepository.getApi(
      EndPoints.progressCourse(courseId),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return response.body['data'] as Map<String, dynamic>?;
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to fetch course progress';
  }

  // Update content progress
  Future<bool> updateContentProgress({
    required String courseId,
    required String contentId,
    required String lectureId,
    double? watchTime,
    double? totalDuration,
    bool? isCompleted,
    bool? isViewed,
  }) async {
    final body = <String, dynamic>{
      'courseId': courseId,
      'contentId': contentId,
      'lectureId': lectureId,
    };

    if (watchTime != null) body['watchTime'] = watchTime;
    if (totalDuration != null) body['totalDuration'] = totalDuration;
    if (isCompleted != null) body['isCompleted'] = isCompleted;
    if (isViewed != null) body['isViewed'] = isViewed;

    final response = await _apiRepository.postApi(
      EndPoints.progressContent,
      body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return true;
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to update content progress';
  }

  // Update lecture progress
  Future<bool> updateLectureProgress({
    required String courseId,
    required String lectureId,
  }) async {
    final body = <String, dynamic>{
      'courseId': courseId,
      'lectureId': lectureId,
    };

    final response = await _apiRepository.postApi(
      EndPoints.progressLecture,
      body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body['success'] == true) {
        return true;
      }
    }

    throw response.body?['message']?.toString() ??
        'Failed to update lecture progress';
  }
}
