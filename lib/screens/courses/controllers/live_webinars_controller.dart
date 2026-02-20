// import 'package:astrobharataiuser/core/base/base_controller.dart';
// import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart';
// import 'package:astrobharataiuser/data_model/webinar_model.dart';
// import 'package:get/get.dart';

// class LiveWebinarsController extends BaseController {
//   final WebinarService _webinarService = Get.put(
//     WebinarService(),
//   ); // Ensure service is put

//   // Selected tab (0: Live Now, 1: Upcoming, 2: Recordings)
//   final RxInt selectedTab = 0.obs;

//   // Lists for different categories
//   final RxList<WebinarModel> liveWebinars = <WebinarModel>[].obs;
//   final RxList<WebinarModel> upcomingWebinars = <WebinarModel>[].obs;
//   final RxList<WebinarModel> recordedWebinars = <WebinarModel>[].obs;

//   // RSVP Management
//   final RxSet<String> myRsvpIds = <String>{}.obs;

//   // Questions Management (for the currently selected/expanded webinar if applicable, or generic)
//   // Store questions mapped by WebinarID to avoid mixing them up
//   final RxMap<String, List<QuestionModel>> webinarQuestions =
//       <String, List<QuestionModel>>{}.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadWebinars();
//   }

//   // Load all webinars and RSVPs
//   Future<void> loadWebinars() async {
//     try {
//       setLoadingState(true);

//       // Load all lists concurrently
//       await Future.wait([
//         _fetchLiveWebinars(),
//         _fetchUpcomingWebinars(),
//         _fetchRecordedWebinars(),
//         _fetchMyRsvps(),
//       ]);
//     } catch (e) {
//       // Error handling is done inside individual fetch methods or here if needed
//       // showErrorMessage(title: "Error", message: "Failed to load webinars");
//     } finally {
//       setLoadingState(false);
//     }
//   }

//   Future<void> _fetchLiveWebinars() async {
//     try {
//       final webinars = await _webinarService.getLiveWebinars();
//       liveWebinars.value = webinars;
//     } catch (e) {
//       print("Error fetching live webinars: $e");
//     }
//   }

//   Future<void> _fetchUpcomingWebinars() async {
//     try {
//       final webinars = await _webinarService.getUpcomingWebinars();
//       upcomingWebinars.value = webinars;
//     } catch (e) {
//       print("Error fetching upcoming webinars: $e");
//     }
//   }

//   Future<void> _fetchRecordedWebinars() async {
//     try {
//       final webinars = await _webinarService.getWebinarHistory();
//       recordedWebinars.value = webinars;
//     } catch (e) {
//       print("Error fetching recorded webinars: $e");
//     }
//   }

//   Future<void> _fetchMyRsvps() async {
//     try {
//       final rsvps = await _webinarService.getMyRsvps();
//       myRsvpIds.assignAll(rsvps.map((e) => e.webinarId!).toSet());
//       // Note: check if webinarId or _id is used for RSVP.
//       // User API shows RSVPing to WEBINAR_... ID.
//       // So ensuring we map correct ID. `webinarId` field seems correct based on join response.
//       // API response for my-rsvps likely returns Webinar objects.
//     } catch (e) {
//       print("Error fetching RSVPs: $e");
//     }
//   }

//   // Get current list based on selected tab
//   List<WebinarModel> get currentList {
//     switch (selectedTab.value) {
//       case 0:
//         return liveWebinars;
//       case 1:
//         return upcomingWebinars;
//       case 2:
//         return recordedWebinars;
//       default:
//         return [];
//     }
//   }

//   // Get tab counts
//   String get liveCount => liveWebinars.length.toString();
//   String get upcomingCount => upcomingWebinars.length.toString();
//   String get recordingsCount => recordedWebinars.length.toString();

//   // Helper to check if I have RSVP'd
//   bool isRsvped(String webinarId) {
//     return myRsvpIds.contains(webinarId);
//   }

//   // Toggle RSVP
//   Future<void> toggleRsvp(WebinarModel webinar) async {
//     if (webinar.webinarId == null) return;

//     final isRegistered = isRsvped(webinar.webinarId!);
//     bool success;

//     if (isRegistered) {
//       success = await _webinarService.cancelRsvp(webinar.webinarId!);
//       if (success) {
//         myRsvpIds.remove(webinar.webinarId!);
//         webinar.rsvpCount = (webinar.rsvpCount ?? 1) - 1;
//         liveWebinars.refresh(); // Trigger UI update
//         upcomingWebinars.refresh();
//       }
//     } else {
//       success = await _webinarService.rsvpWebinar(webinar.webinarId!);
//       if (success) {
//         myRsvpIds.add(webinar.webinarId!);
//         webinar.rsvpCount = (webinar.rsvpCount ?? 0) + 1;
//         liveWebinars.refresh();
//         upcomingWebinars.refresh();
//       }
//     }

//     if (!success) {
//       showErrorMessage(title: "Error", message: "Failed to update RSVP");
//     }
//   }

//   // Question Handling
//   Future<void> fetchQuestions(String webinarId) async {
//     final questions = await _webinarService.getQuestions(webinarId);
//     webinarQuestions[webinarId] = questions;
//   }

//   Future<void> submitQuestion(String webinarId, String text) async {
//     if (text.isEmpty) return;
//     final success = await _webinarService.submitQuestion(webinarId, text);
//     if (success) {
//       Get.snackbar("Success", "Question submitted");
//       fetchQuestions(webinarId); // Refresh list
//     } else {
//       showErrorMessage(title: "Error", message: "Failed to submit question");
//     }
//   }

//   Future<void> upvoteQuestion(String webinarId, String questionId) async {
//     final success = await _webinarService.upvoteQuestion(webinarId, questionId);
//     if (success) {
//       fetchQuestions(webinarId); // Refresh list to show new upvote count
//     }
//   }

//   // Join Webinar
//   Future<void> joinWebinar(String webinarId) async {
//     try {
//       setLoadingState(true);

//       final response = await _webinarService.joinWebinar(webinarId);
//       setLoadingState(false);

//       if (response != null) {
//         // Navigate
//         // Get.toNamed(AppRoutes.liveWebinarSession, arguments: ...);
//         Get.snackbar("Success", "Joined ${response.channelName}");
//       } else {
//         showErrorMessage(title: "Error", message: "Failed to join webinar");
//       }
//     } catch (e) {
//       setLoadingState(false);
//       showErrorMessage(title: "Error", message: e.toString());
//     }
//   }

//   // Refresh
//   Future<void> refreshWebinars() async {
//     await loadWebinars();
//   }
// }

import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart';
import 'package:astrobharataiuser/data_model/webinar_model.dart';
import 'package:get/get.dart';

class LiveWebinarsController extends BaseController {
  final WebinarService _webinarService = Get.find<WebinarService>();

  // Selected tab (1: Upcoming, 2: Recordings)
  // Note: Live webinars are always shown in the hero section above tabs
  final RxInt selectedTab = 1.obs;

  // Lists for different categories
  final RxList<WebinarModel> liveWebinars = <WebinarModel>[].obs;
  final RxList<WebinarModel> upcomingWebinars = <WebinarModel>[].obs;
  final RxList<WebinarModel> recordedWebinars = <WebinarModel>[].obs;

  // RSVP Management - using webinarId field
  final RxSet<String> myRsvpIds = <String>{}.obs;

  // Questions Management (for the currently selected/expanded webinar)
  final RxMap<String, List<QuestionModel>> webinarQuestions =
      <String, List<QuestionModel>>{}.obs;

  // Loading states for individual operations
  final RxBool isRsvpLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWebinars();
  }

  // Load all webinars and RSVPs
  Future<void> loadWebinars() async {
    try {
      setLoadingState(true);

      // Load all lists concurrently
      await Future.wait([
        _fetchLiveWebinars(),
        _fetchUpcomingWebinars(),
        _fetchRecordedWebinars(),
        _fetchMyRsvps(),
      ]);
    } catch (e) {
      print("Error loading webinars: $e");
      showErrorMessage(
        title: "Error",
        message: "Failed to load webinars. Please try again.",
      );
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> _fetchLiveWebinars() async {
    try {
      final webinars = await _webinarService.getLiveWebinars();
      liveWebinars.value = webinars;
      print("Loaded ${webinars.length} live webinars");
    } catch (e) {
      print("Error fetching live webinars: $e");
    }
  }

  Future<void> _fetchUpcomingWebinars() async {
    try {
      final webinars = await _webinarService.getUpcomingWebinars();
      upcomingWebinars.value = webinars;
      print("Loaded ${webinars.length} upcoming webinars");
    } catch (e) {
      print("Error fetching upcoming webinars: $e");
    }
  }

  Future<void> _fetchRecordedWebinars() async {
    try {
      final webinars = await _webinarService.getWebinarHistory();
      recordedWebinars.value = webinars;
      print("Loaded ${webinars.length} recorded webinars");
    } catch (e) {
      print("Error fetching recorded webinars: $e");
    }
  }

  Future<void> _fetchMyRsvps() async {
    try {
      final rsvps = await _webinarService.getMyRsvps();

      // Extract IDs from each RSVP webinar
      final rsvpIds = <String>{};
      for (var w in rsvps) {
        if (w.webinarId != null && w.webinarId!.isNotEmpty) {
          rsvpIds.add(w.webinarId!);
        }
        if (w.id != null && w.id!.isNotEmpty) {
          rsvpIds.add(w.id!);
        }
      }

      myRsvpIds.assignAll(rsvpIds);
      print("Loaded ${rsvpIds.length} RSVPs");
    } catch (e) {
      print("Error fetching RSVPs: $e");
    }
  }

  // Get current list based on selected tab
  List<WebinarModel> get currentList {
    switch (selectedTab.value) {
      case 0:
        return liveWebinars;
      case 1:
        return upcomingWebinars;
      case 2:
        return recordedWebinars;
      default:
        return [];
    }
  }

  // Get tab counts
  String get liveCount => liveWebinars.length.toString();
  String get upcomingCount => upcomingWebinars.length.toString();
  String get recordingsCount => recordedWebinars.length.toString();

  // Helper to check if user has RSVP'd to a webinar
  bool isRsvped(String webinarId) {
    return myRsvpIds.contains(webinarId);
  }

  // Toggle RSVP - handles both adding and removing RSVPs
  Future<void> toggleRsvp(WebinarModel webinar) async {
    if (webinar.webinarId == null || webinar.webinarId!.isEmpty) {
      showErrorMessage(title: "Error", message: "Invalid webinar ID");
      return;
    }

    // Check if webinar accepts RSVPs (only SCHEDULED webinars)
    if (webinar.status != "SCHEDULED") {
      if (webinar.status == "LIVE" || webinar.status == "PREPARING") {
        showErrorMessage(
          title: "Upcoming Only",
          message:
              "This webinar is starting soon. You can join it directly once it's live!",
        );
      } else {
        showErrorMessage(
          title: "Not Available",
          message: "RSVP is not available for this webinar yet.",
        );
      }
      return;
    }

    final webinarId = webinar.webinarId!;
    final isCurrentlyRsvped = isRsvped(webinarId);

    // Prevent multiple simultaneous RSVP operations
    if (isRsvpLoading.value) {
      return;
    }

    try {
      isRsvpLoading.value = true;
      bool success;

      if (isCurrentlyRsvped) {
        // Cancel RSVP
        success = await _webinarService.cancelRsvp(webinarId);

        if (success) {
          myRsvpIds.remove(webinarId);

          // Update RSVP count
          if (webinar.rsvpCount != null && webinar.rsvpCount! > 0) {
            webinar.rsvpCount = webinar.rsvpCount! - 1;
          }

          // Refresh the lists to update UI
          liveWebinars.refresh();
          upcomingWebinars.refresh();

          Get.snackbar(
            "Success",
            "RSVP cancelled successfully",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          showErrorMessage(
            title: "Error",
            message: "Failed to cancel RSVP. Please try again.",
          );
        }
      } else {
        // Add RSVP
        success = await _webinarService.rsvpWebinar(webinarId);

        if (success) {
          myRsvpIds.add(webinarId);

          // Update RSVP count
          webinar.rsvpCount = (webinar.rsvpCount ?? 0) + 1;

          // Refresh the lists to update UI
          liveWebinars.refresh();
          upcomingWebinars.refresh();

          Get.snackbar(
            "Success",
            "RSVP confirmed! You'll be notified when the webinar starts.",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          // Only show error for unexpected failures
          showErrorMessage(
            title: "Error",
            message: "Failed to RSVP. Please try again later.",
          );
        }
      }
    } catch (e) {
      print("Error toggling RSVP: $e");

      // Only show error if it's not a status-based rejection
      if (!e.toString().contains("Can only RSVP for scheduled webinars")) {
        showErrorMessage(
          title: "Error",
          message: "An unexpected error occurred. Please try again.",
        );
      }
    } finally {
      isRsvpLoading.value = false;
    }
  }

  // Question Handling
  Future<void> fetchQuestions(String webinarId) async {
    try {
      final questions = await _webinarService.getQuestions(webinarId);
      webinarQuestions[webinarId] = questions;
      print("Loaded ${questions.length} questions for webinar $webinarId");
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  Future<void> submitQuestion(String webinarId, String text) async {
    if (text.trim().isEmpty) {
      showErrorMessage(title: "Error", message: "Please enter a question");
      return;
    }

    try {
      setLoadingState(true);
      final success = await _webinarService.submitQuestion(webinarId, text);

      if (success) {
        Get.snackbar(
          "Success",
          "Question submitted successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        // Refresh questions list
        await fetchQuestions(webinarId);
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to submit question. Please try again.",
        );
      }
    } catch (e) {
      print("Error submitting question: $e");
      showErrorMessage(title: "Error", message: "An unexpected error occurred");
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> upvoteQuestion(String webinarId, String questionId) async {
    try {
      final success = await _webinarService.upvoteQuestion(
        webinarId,
        questionId,
      );

      if (success) {
        // Refresh questions list to show updated upvote count
        await fetchQuestions(webinarId);
      } else {
        showErrorMessage(title: "Error", message: "Failed to upvote question");
      }
    } catch (e) {
      print("Error upvoting question: $e");
    }
  }

  // Join Webinar - Navigate to live session
  Future<void> joinWebinar(WebinarModel webinar) async {
    if (webinar.webinarId == null || webinar.webinarId!.isEmpty) {
      showErrorMessage(title: "Error", message: "Invalid webinar ID");
      return;
    }

    // Check if webinar can be joined
    if (webinar.canJoin != true) {
      showErrorMessage(
        title: "Cannot Join",
        message: "This webinar is not currently available to join",
      );
      return;
    }

    try {
      setLoadingState(true);

      final response = await _webinarService.joinWebinar(webinar.webinarId!);

      if (response != null) {
        // Navigate to live session with join response data
        Get.toNamed(
          '/live-webinar-session',
          arguments: {
            'webinarId': webinar.webinarId!,
            'courseId': webinar.courseId?.id ?? '',
            'joinResponse': response,
            'webinar': webinar,
          },
        );
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to join webinar. Please try again.",
        );
      }
    } catch (e) {
      print("Error joining webinar: $e");

      // Handle specific error cases
      String errorMessage =
          "An unexpected error occurred while joining the webinar";

      if (e.toString().contains("409") ||
          e.toString().contains("already exists")) {
        // User is already in this session - navigate anyway
        Get.toNamed(
          '/live-webinar-session',
          arguments: {
            'webinarId': webinar.webinarId!,
            'courseId': webinar.courseId?.id ?? '',
            'webinar': webinar,
          },
        );
        return; // Don't show error, just navigate
      } else if (e.toString().contains("403")) {
        errorMessage = "You don't have permission to join this webinar";
      } else if (e.toString().contains("404")) {
        errorMessage = "Webinar not found";
      }

      showErrorMessage(title: "Error", message: errorMessage);
    } finally {
      setLoadingState(false);
    }
  }

  // Refresh all webinar data
  Future<void> refreshWebinars() async {
    await loadWebinars();
  }

  // Change selected tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}

