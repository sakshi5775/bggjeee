import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/data_model/payment_process_model.dart';
import 'package:flutter/foundation.dart';
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
    try {
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
      return null;
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      return null;
    }
  }

  // Get single course by ID
  Future<CourseDetailModel?> getCourseById(String id) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.courseById(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return CourseDetailModel.fromJson(response.body);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching course: $e');
      return null;
    }
  }

  // Get lectures by course ID
  Future<List<LectureModel>?> getLecturesByCourseId(String courseId) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.courseLectures(courseId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          final data = response.body['data'] as List<dynamic>;
          return data
              .map((e) => LectureModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching lectures: $e');
      return null;
    }
  }

  // Get lecture by ID
  Future<LectureModel?> getLectureById(String id) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.lectureById(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          final data = response.body['data'] as Map<String, dynamic>;
          return LectureModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching lecture: $e');
      return null;
    }
  }

  // Get content by ID
  Future<ContentModel?> getContentById(String id) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.contentById(id));

      debugPrint('=== CONTENT API RESPONSE ===');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');
      debugPrint('Body type: ${response.body.runtimeType}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic>? contentData;
        
        // Handle different response structures
        if (response.body is Map<String, dynamic>) {
          final body = response.body as Map<String, dynamic>;
          
          // Check if response has success wrapper
          if (body['success'] == true && body['data'] != null) {
            contentData = body['data'] as Map<String, dynamic>?;
          } 
          // Check if content is directly in body
          else if (body['_id'] != null || body['id'] != null) {
            contentData = body;
          }
        }
        
        if (contentData != null) {
          debugPrint('Content data: $contentData');
          debugPrint('URL field: ${contentData['url']}');
          debugPrint('fileUrl field: ${contentData['fileUrl']}');
          debugPrint('contentUrl field: ${contentData['contentUrl']}');
          
          // Try different URL field names
          final url = contentData['url'] as String? ?? 
                     contentData['fileUrl'] as String? ?? 
                     contentData['contentUrl'] as String? ?? 
                     '';
          
          // Create ContentModel with proper URL
          if (url.isNotEmpty) {
            contentData['url'] = url;
          }
          
          return ContentModel.fromJson(contentData);
        } else {
          debugPrint('⚠️ No content data found in response');
        }
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error fetching content: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  // Initiate order
  Future<Map<String, dynamic>?> initiateOrder({
    required String courseId,
    required String paymentMethod,
  }) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.ordersInitiate,
        {
          'courseId': courseId,
          'paymentMethod': paymentMethod,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return response.body['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error initiating order: $e');
      return null;
    }
  }

  // Process payment - matches confirmed API request/response structure
  Future<PaymentProcessResponse?> processPayment({
    required String orderId, // LRN-xxxx from initiate API
    required String gatewayOrderId, // gatewayOrderId from initiate API
    required String razorpayOrderId, // razorpay_order_id from Razorpay response
    required String razorpayPaymentId, // razorpay_payment_id from Razorpay response
    required String razorpaySignature, // razorpay_signature from Razorpay response
  }) async {
    try {
      // Request body format - EXACT match with working API
      final body = <String, dynamic>{
        'orderId': orderId,
        'gatewayOrderId': gatewayOrderId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
      };

      debugPrint('=== PAYMENT PROCESS REQUEST ===');
      debugPrint('Body: $body');

      final response = await _apiRepository.postApi(
        EndPoints.paymentsProcess,
        body,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.body is Map &&
          response.body['success'] == true) {
        // Parse response using confirmed structure
        return PaymentProcessResponse.fromJson(response.body);
      }

      return null;
    } catch (e) {
      debugPrint('Error processing payment: $e');
      return null;
    }
  }



  // Payment gateway removed - will be re-implemented later
  // Verify payment method temporarily disabled
  Future<Map<String, dynamic>?> verifyPayment({
    required String orderId,
    required String gatewayOrderId,
    required String gatewayPaymentId,
    required String signature,
  }) async {
    // Payment gateway removed - will be re-implemented later
    debugPrint("Payment verification is currently disabled");
    return null;
  }

  // Get enrollments
  Future<Map<String, dynamic>?> getEnrollments({int page = 1}) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.enrollments,
        query: {'page': page.toString()},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return response.body['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching enrollments: $e');
      return null;
    }
  }

  // Check enrollment (Step 3: Enrollment Check Flow)
  Future<Map<String, dynamic>?> checkEnrollment(String courseId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.enrollmentCheck(courseId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return response.body['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error checking enrollment: $e');
      return null;
    }
  }

  // Get progress overview
  Future<Map<String, dynamic>?> getProgressOverview() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.progressOverview);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return response.body['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching progress overview: $e');
      return null;
    }
  }

  // Get course progress
  Future<Map<String, dynamic>?> getCourseProgress(String courseId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.progressCourse(courseId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          return response.body['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching course progress: $e');
      return null;
    }
  }

  // Update content progress (mark as viewed/completed)
  Future<bool> updateContentProgress({
    required String courseId,
    required String contentId,
    required String lectureId,
    double? watchTime,
    double? totalDuration,
    bool? isCompleted,
    bool? isViewed,
  }) async {
    try {
      final body = <String, dynamic>{
        'courseId': courseId,
        'contentId': contentId,
        'lectureId': lectureId,
      };

      if (watchTime != null) {
        body['watchTime'] = watchTime;
      }
      if (totalDuration != null) {
        body['totalDuration'] = totalDuration;
      }
      if (isCompleted != null) {
        body['isCompleted'] = isCompleted;
      }
      if (isViewed != null) {
        body['isViewed'] = isViewed;
      }

      debugPrint('📊 Updating content progress: $body');

      final response = await _apiRepository.postApi(
        EndPoints.progressContent,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          debugPrint('✅ Content progress updated successfully: ${response.body}');
          return true;
        }
      }
      debugPrint('⚠️ Content progress update failed: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('❌ Error updating content progress: $e');
      return false;
    }
  }

  // Update lecture progress (mark lecture as completed)
  Future<bool> updateLectureProgress({
    required String courseId,
    required String lectureId,
  }) async {
    try {
      final body = <String, dynamic>{
        'courseId': courseId,
        'lectureId': lectureId,
      };

      debugPrint('📊 Updating lecture progress: $body');

      final response = await _apiRepository.postApi(
        EndPoints.progressLecture,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['success'] == true) {
          debugPrint('✅ Lecture progress updated successfully: ${response.body}');
          return true;
        }
      }
      debugPrint('⚠️ Lecture progress update failed: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('❌ Error updating lecture progress: $e');
      return false;
    }
  }
}

