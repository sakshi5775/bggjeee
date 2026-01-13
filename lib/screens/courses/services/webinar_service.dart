// import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
// import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
// import 'package:astrobharataiuser/data_model/webinar_model.dart';
// import 'package:get/get.dart';

// class WebinarService extends GetxService {
//   final ApiRepository _apiRepository = Get.find();

//   // Helper to construct base path for webinar-specific endpoints
//   String _getWebinarBasePath() {
//     // Assuming EndPoints.liveWebinars is something like '/api/learning-portal/webinars/live'
//     // We want '/api/learning-portal/webinars'
//     // If constants are not exactly matching, we rely on this or string replacement.
//     // Based on user provided API: http://.../api/learning-portal/api/learning-portal/webinars/
//     // It seems there is duplication or just a prefix.
//     // I shall use the constant if available, else a robust string logic.
//     return EndPoints.liveWebinars.replaceAll('/live', '');
//   }

//   // Fetch Live Webinars
//   Future<List<WebinarModel>> getLiveWebinars() async {
//     try {
//       final response = await _apiRepository.getApi(EndPoints.liveWebinars);
//       if (response.status.hasError) {
//         return [];
//       }
//       if (response.body['success'] == true && response.body['data'] != null) {
//         return (response.body['data'] as List)
//             .map((e) => WebinarModel.fromJson(e))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching live webinars: $e");
//       return [];
//     }
//   }

//   // Fetch Upcoming Webinars
//   Future<List<WebinarModel>> getUpcomingWebinars() async {
//     try {
//       final response = await _apiRepository.getApi(EndPoints.upcomingWebinars);
//       if (response.status.hasError) {
//         return [];
//       }
//       if (response.body['success'] == true && response.body['data'] != null) {
//         return (response.body['data'] as List)
//             .map((e) => WebinarModel.fromJson(e))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching upcoming webinars: $e");
//       return [];
//     }
//   }

//   // Fetch History Response
//   Future<List<WebinarModel>> getWebinarHistory({int page = 1}) async {
//     try {
//       final response = await _apiRepository.getApi(
//         '${EndPoints.webinarHistory}?page=$page&limit=20',
//       );
//       if (response.status.hasError) {
//         return [];
//       }
//       if (response.body['success'] == true && response.body['data'] != null) {
//         return (response.body['data'] as List)
//             .map((e) => WebinarModel.fromJson(e))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       print("Error fetching webinar history: $e");
//       return [];
//     }
//   }

//   // Get My RSVPs
//   Future<List<WebinarModel>> getMyRsvps() async {
//     try {
//       final response = await _apiRepository.getApi(
//         '${_getWebinarBasePath()}/my-rsvps',
//       );
//       if (response.status.hasError) return [];
//       if (response.body['success'] == true && response.body['data'] != null) {
//         return (response.body['data'] as List)
//             .map((e) => WebinarModel.fromJson(e))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   // Join Webinar
//   Future<JoinWebinarResponse?> joinWebinar(String webinarId) async {
//     try {
//       final response = await _apiRepository.postApi(
//         '${_getWebinarBasePath()}/$webinarId/join',
//         {
//           'deviceInfo': {'platform': 'MOBILE', 'userAgent': 'Flutter App'},
//         },
//       );

//       if (response.status.hasError) return null;
//       if (response.body['success'] == true) {
//         return JoinWebinarResponse.fromJson(response.body['data']);
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   // Leave Webinar
//   Future<bool> leaveWebinar(String webinarId) async {
//     try {
//       final response = await _apiRepository.postApi(
//         '${_getWebinarBasePath()}/$webinarId/leave',
//         {},
//       );
//       return !response.status.hasError && response.body['success'] == true;
//     } catch (e) {
//       return false;
//     }
//   }

//   // RSVP
//   Future<bool> rsvpWebinar(String webinarId) async {
//     try {
//       final response = await _apiRepository.postApi(
//         '${_getWebinarBasePath()}/$webinarId/rsvp',
//         {},
//       );
//       return !response.status.hasError && response.body['success'] == true;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Cancel RSVP
//   Future<bool> cancelRsvp(String webinarId) async {
//     try {
//       final response = await _apiRepository.deleteReq(
//         '${_getWebinarBasePath()}/$webinarId/rsvp',
//       );
//       return !response.status.hasError && response.body['success'] == true;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Get Questions
//   Future<List<QuestionModel>> getQuestions(
//     String webinarId, {
//     int page = 1,
//   }) async {
//     try {
//       final response = await _apiRepository.getApi(
//         '${_getWebinarBasePath()}/$webinarId/questions?page=$page&limit=20',
//       );
//       if (response.body['success'] == true) {
//         return (response.body['data'] as List)
//             .map((e) => QuestionModel.fromJson(e))
//             .toList();
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   // Submit Question
//   Future<bool> submitQuestion(String webinarId, String text) async {
//     try {
//       final response = await _apiRepository.postApi(
//         '${_getWebinarBasePath()}/$webinarId/questions',
//         {'questionText': text},
//       );
//       return response.body['success'] == true;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Upvote Question
//   Future<bool> upvoteQuestion(String webinarId, String questionId) async {
//     try {
//       final response = await _apiRepository.postApi(
//         '${_getWebinarBasePath()}/$webinarId/questions/$questionId/upvote',
//         {},
//       );
//       return response.body['success'] == true;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Refresh Token
//   Future<String?> refreshBroadcasterToken(String webinarId) async {
//     try {
//       final response = await _apiRepository.postApi(
//         '${_getWebinarBasePath()}/$webinarId/token/refresh',
//         {},
//       );
//       if (response.body['success'] == true) {
//         return response.body['data']['token'];
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   // Check recording status
//   Future<String?> checkRecordingStatus(String webinarId) async {
//     try {
//       final response = await _apiRepository.getApi(
//         '${_getWebinarBasePath()}/$webinarId/recording',
//       );
//       if (response.status.hasError) {
//         return null;
//       }
//       // Assuming 'recordingStatus' or data.status
//       if (response.body['recordingStatus'] != null) {
//         // Based on user JSON
//         return response.body['recordingStatus'];
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<int> getRsvpCount(String webinarId) async {
//     // Added
//     try {
//       final response = await _apiRepository.getApi(
//         '${_getWebinarBasePath()}/$webinarId/rsvp/count',
//       );
//       if (response.body['success'] == true) {
//         return response.body['data']['count'] ?? 0;
//       }
//       return 0;
//     } catch (e) {
//       return 0;
//     }
//   }
// }

import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/webinar_model.dart';
import 'package:get/get.dart';

class WebinarService extends GetxService {
  final ApiRepository _apiRepository = Get.find();

  // Helper to construct base path for webinar-specific endpoints
  String _getWebinarBasePath() {
    // EndPoints.liveWebinars is 'learning-portal/api/learning-portal/webinars/live'
    // We want the base: 'learning-portal/api/learning-portal/webinars'
    String basePath = EndPoints.liveWebinars;

    if (basePath.endsWith('/live')) {
      basePath = basePath.substring(0, basePath.length - '/live'.length);
    }

    return basePath;
  }

  // Fetch Live Webinars
  Future<List<WebinarModel>> getLiveWebinars() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.liveWebinars);

      if (response.status.hasError) {
        print("Error status in live webinars: ${response.statusText}");
        return [];
      }

      if (response.body == null) {
        print("Response body is null");
        return [];
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .map((e) {
                try {
                  return WebinarModel.fromJson(e as Map<String, dynamic>);
                } catch (e) {
                  print("Error parsing webinar: $e");
                  return null;
                }
              })
              .whereType<WebinarModel>()
              .toList();
        }
      }

      return [];
    } catch (e, stackTrace) {
      print("Error fetching live webinars: $e");
      print("Stack trace: $stackTrace");
      return [];
    }
  }

  // Fetch Upcoming Webinars
  Future<List<WebinarModel>> getUpcomingWebinars() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.upcomingWebinars);

      if (response.status.hasError) {
        print("Error status in upcoming webinars: ${response.statusText}");
        return [];
      }

      if (response.body == null) {
        print("Response body is null");
        return [];
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .map((e) {
                try {
                  return WebinarModel.fromJson(e as Map<String, dynamic>);
                } catch (e) {
                  print("Error parsing webinar: $e");
                  return null;
                }
              })
              .whereType<WebinarModel>()
              .toList();
        }
      }

      return [];
    } catch (e, stackTrace) {
      print("Error fetching upcoming webinars: $e");
      print("Stack trace: $stackTrace");
      return [];
    }
  }

  // Fetch History Response with pagination
  Future<List<WebinarModel>> getWebinarHistory({int? page, int? limit}) async {
    try {
      String url = EndPoints.webinarHistory;
      if (page != null && limit != null) {
        url += '?page=$page&limit=$limit';
      }

      print("Fetching webinar history from: $url");
      var response = await _apiRepository.getApi(url);

      // Fallback: If parameters failed (e.g., 403 or 404), try without parameters
      if (response.status.hasError && (page != null || limit != null)) {
        print(
          "Webinar history with parameters failed (${response.statusCode}), retrying without parameters...",
        );
        response = await _apiRepository.getApi(EndPoints.webinarHistory);
      }

      if (response.status.hasError) {
        print("Error status in webinar history: ${response.statusText}");
        return [];
      }

      if (response.body == null) {
        print("Response body is null");
        return [];
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .map((e) {
                try {
                  return WebinarModel.fromJson(e as Map<String, dynamic>);
                } catch (e) {
                  print("Error parsing webinar: $e");
                  return null;
                }
              })
              .whereType<WebinarModel>()
              .toList();
        }
      }

      return [];
    } catch (e, stackTrace) {
      print("Error fetching webinar history: $e");
      print("Stack trace: $stackTrace");
      return [];
    }
  }

  // Get My RSVPs
  Future<List<WebinarModel>> getMyRsvps() async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.getApi('$basePath/my-rsvps');

      if (response.status.hasError) {
        print("Error status in my RSVPs: ${response.statusText}");
        return [];
      }

      if (response.body == null) {
        print("Response body is null");
        return [];
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .map((e) {
                try {
                  return WebinarModel.fromJson(e as Map<String, dynamic>);
                } catch (e) {
                  print("Error parsing RSVP webinar: $e");
                  return null;
                }
              })
              .whereType<WebinarModel>()
              .toList();
        }
      }

      return [];
    } catch (e, stackTrace) {
      print("Error fetching my RSVPs: $e");
      print("Stack trace: $stackTrace");
      return [];
    }
  }

  // Get Single Webinar by ID
  Future<WebinarModel?> getWebinarById(String webinarId) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.getApi('$basePath/$webinarId');

      if (response.status.hasError) {
        print("Error fetching webinar by ID: ${response.statusText}");
        return null;
      }

      if (response.body == null) {
        print("Response body is null");
        return null;
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        return WebinarModel.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }

      return null;
    } catch (e, stackTrace) {
      print("Error fetching webinar by ID: $e");
      print("Stack trace: $stackTrace");
      return null;
    }
  }

  // Join Webinar
  Future<JoinWebinarResponse?> joinWebinar(String webinarId) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.postApi(
        '$basePath/$webinarId/join',
        {
          'deviceInfo': {'platform': 'MOBILE', 'userAgent': 'Flutter App'},
        },
      );

      if (response.status.hasError) {
        print("Error joining webinar: ${response.statusText}");
        return null;
      }

      if (response.body == null) {
        print("Response body is null");
        return null;
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        return JoinWebinarResponse.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }

      return null;
    } catch (e, stackTrace) {
      print("Error joining webinar: $e");
      print("Stack trace: $stackTrace");
      return null;
    }
  }

  // Leave Webinar
  Future<bool> leaveWebinar(String webinarId) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.postApi(
        '$basePath/$webinarId/leave',
        {},
      );

      if (response.body == null) {
        return false;
      }

      return !response.status.hasError && response.body['success'] == true;
    } catch (e, stackTrace) {
      print("Error leaving webinar: $e");
      print("Stack trace: $stackTrace");
      return false;
    }
  }

  // RSVP to Webinar
  Future<bool> rsvpWebinar(String webinarId) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.postApi(
        '$basePath/$webinarId/rsvp',
        {},
      );

      if (response.body == null) {
        return false;
      }

      final success =
          !response.status.hasError && response.body['success'] == true;

      if (!success && response.body['message'] != null) {
        print("RSVP error: ${response.body['message']}");
      }

      return success;
    } catch (e, stackTrace) {
      print("Error RSVP'ing to webinar: $e");
      print("Stack trace: $stackTrace");
      return false;
    }
  }

  // Cancel RSVP
  Future<bool> cancelRsvp(String webinarId) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.deleteReq(
        '$basePath/$webinarId/rsvp',
      );

      if (response.body == null) {
        return false;
      }

      final success =
          !response.status.hasError && response.body['success'] == true;

      if (!success && response.body['message'] != null) {
        print("Cancel RSVP error: ${response.body['message']}");
      }

      return success;
    } catch (e, stackTrace) {
      print("Error canceling RSVP: $e");
      print("Stack trace: $stackTrace");
      return false;
    }
  }

  // Get RSVP Count
  Future<int> getRsvpCount(String webinarId) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.getApi(
        '$basePath/$webinarId/rsvp/count',
      );

      if (response.body == null) {
        return 0;
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        return (response.body['data']['count'] as num?)?.toInt() ?? 0;
      }

      return 0;
    } catch (e, stackTrace) {
      print("Error getting RSVP count: $e");
      print("Stack trace: $stackTrace");
      return 0;
    }
  }

  // Get Questions
  Future<List<QuestionModel>> getQuestions(
    String webinarId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.getApi(
        '$basePath/$webinarId/questions?page=$page&limit=$limit',
      );

      if (response.body == null) {
        return [];
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        final data = response.body['data'];
        if (data is List) {
          return data
              .map((e) {
                try {
                  return QuestionModel.fromJson(e as Map<String, dynamic>);
                } catch (e) {
                  print("Error parsing question: $e");
                  return null;
                }
              })
              .whereType<QuestionModel>()
              .toList();
        }
      }

      return [];
    } catch (e, stackTrace) {
      print("Error fetching questions: $e");
      print("Stack trace: $stackTrace");
      return [];
    }
  }

  // Submit Question
  Future<bool> submitQuestion(String webinarId, String text) async {
    try {
      if (text.trim().isEmpty) {
        print("Question text is empty");
        return false;
      }

      final basePath = _getWebinarBasePath();
      final url = '$basePath/$webinarId/questions';
      final payload = {'questionText': text.trim()};

      print("Submitting question to: $url");
      print("Payload: $payload");

      final response = await _apiRepository.postApi(url, payload);

      if (response.status.hasError) {
        print("Submit question failed with status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }

      if (response.body == null) {
        return false;
      }

      final success = response.body['success'] == true;
      if (success) {
        print("Question submitted successfully");
      }
      return success;
    } catch (e, stackTrace) {
      print("Error submitting question: $e");
      print("Stack trace: $stackTrace");
      return false;
    }
  }

  // Upvote Question
  Future<bool> upvoteQuestion(String webinarId, String questionId) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.postApi(
        '$basePath/$webinarId/questions/$questionId/upvote',
        {},
      );

      if (response.body == null) {
        return false;
      }

      return response.body['success'] == true;
    } catch (e, stackTrace) {
      print("Error upvoting question: $e");
      print("Stack trace: $stackTrace");
      return false;
    }
  }

  // Refresh Token (for broadcasters/viewers)
  Future<WebinarTokenRefreshResponse?> refreshToken(String webinarId) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.postApi(
        '$basePath/$webinarId/token/refresh',
        {},
      );

      if (response.body == null) {
        return null;
      }

      if (response.body['success'] == true && response.body['data'] != null) {
        return WebinarTokenRefreshResponse.fromJson(
          response.body['data'] as Map<String, dynamic>,
        );
      }

      return null;
    } catch (e, stackTrace) {
      print("Error refreshing token: $e");
      print("Stack trace: $stackTrace");
      return null;
    }
  }

  // Check recording status
  Future<RecordingStatusResponse?> checkRecordingStatus(
    String webinarId,
  ) async {
    try {
      final basePath = _getWebinarBasePath();
      final response = await _apiRepository.getApi(
        '$basePath/$webinarId/recording',
      );

      if (response.body == null) {
        return null;
      }

      return RecordingStatusResponse.fromJson(
        response.body as Map<String, dynamic>,
      );
    } catch (e, stackTrace) {
      print("Error checking recording status: $e");
      print("Stack trace: $stackTrace");
      return null;
    }
  }
}
