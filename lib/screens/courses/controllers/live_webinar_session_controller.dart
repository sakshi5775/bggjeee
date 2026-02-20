import 'dart:async';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart';
import 'package:astrobharataiuser/data_model/webinar_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveWebinarSessionController extends BaseController {
  final String webinarId;
  final String courseId;
  final CoursesService _coursesService = Get.find<CoursesService>();
  final WebinarService _webinarService = Get.find<WebinarService>();

  LiveWebinarSessionController({
    required this.webinarId,
    required this.courseId,
  });

  // Webinar data
  final Rx<WebinarModel?> webinar = Rx<WebinarModel?>(null);
  final Rx<CourseModel?> course = Rx<CourseModel?>(null);
  final Rx<JoinWebinarResponse?> joinResponse = Rx<JoinWebinarResponse?>(null);

  // UI State
  final RxString webinarTitle = ''.obs;
  final RxString hostName = ''.obs;
  final RxString thumbnailUrl = ''.obs;
  final RxInt viewerCount = 0.obs;
  final RxInt qaCount = 0.obs;
  final RxString durationText = '0:00'.obs;

  // Agora credentials
  String? agoraAppId;
  String? agoraChannelName;
  String? agoraToken;
  int? agoraUid;

  // Agora Engine & State
  RtcEngine? agoraEngine;
  final RxInt remoteUid = 0.obs;
  final RxBool isEngineInitialized = false.obs;

  // Controls
  final RxBool isMicOn = false.obs;
  final RxBool isVideoOn = false.obs;
  final RxBool hasJoined = false.obs;
  final RxBool isFullscreen = false.obs;

  // Questions
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  final TextEditingController questionController = TextEditingController();

  // Timer for duration tracking & token refresh
  Timer? _durationTimer;
  Timer? _tokenRefreshTimer;
  Timer? _questionPollingTimer;
  DateTime? _joinedAt;
  final Set<String> _upvotedQuestions = {}; // Prevent duplicate upvotes locally

  @override
  void onInit() {
    super.onInit();
    loadWebinarData();
  }

  @override
  void onClose() {
    _durationTimer?.cancel();
    questionController.dispose();

    // Leave webinar if still joined
    if (hasJoined.value) {
      leaveWebinar();
    }

    _tokenRefreshTimer?.cancel();
    _questionPollingTimer?.cancel();
    _cleanupAgora();

    // Reset orientation on close
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.onClose();
  }

  Future<void> loadWebinarData() async {
    try {
      setLoadingState(true);

      // 1. Load course details (optional, for context)
      if (courseId.isNotEmpty) {
        try {
          final courseDetail = await _coursesService.getCourseById(courseId);
          if (courseDetail != null) {
            course.value = courseDetail.course;
          }
        } catch (e) {
          print("Error loading course: $e");
          // Continue even if course loading fails
        }
      }

      // 2. Load Webinar Details
      final webinarData = await _webinarService.getWebinarById(webinarId);
      if (webinarData != null) {
        webinar.value = webinarData;
        _updateUIFromWebinar(webinarData);
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to load webinar details",
        );
        Get.back();
        return;
      }

      // 3. Join the webinar session
      await joinWebinarSession();

      // 4. Fetch Questions
      await fetchQuestions();

      // 5. Start duration timer
      _startDurationTimer();

      // 6. Start fetching questions periodically
      _startQuestionPolling();
    } catch (e) {
      print("Error loading webinar data: $e");
      showErrorMessage(title: "Error", message: "Failed to load session: $e");
      Get.back();
    } finally {
      setLoadingState(false);
    }
  }

  void _updateUIFromWebinar(WebinarModel webinarData) {
    webinarTitle.value = webinarData.title ?? 'Live Webinar';
    hostName.value = webinarData.hostName ?? 'Host';
    thumbnailUrl.value = webinarData.thumbnail ?? '';

    // Calculate time remaining logic removed as requested (timeRemaining is deleted)
  }

  Future<void> joinWebinarSession() async {
    try {
      final response = await _webinarService.joinWebinar(webinarId);

      if (response != null) {
        joinResponse.value = response;
        hasJoined.value = true;
        _joinedAt = DateTime.now();

        // Store Agora credentials for future SDK integration
        agoraAppId = response.agoraAppId;
        agoraChannelName = response.channelName;
        agoraToken = response.token;
        agoraUid = response.uid;

        print("Joined webinar successfully");
        print("Agora App ID: $agoraAppId");
        print("Channel: $agoraChannelName");
        print("Token: ${agoraToken?.substring(0, 20)}...");
        print("UID: $agoraUid");

        // Initialize refresh timer based on expiration
        _startTokenRefreshTimer(response.tokenExpiresAt);

        // Initialize Agora SDK with these credentials
        await _initializeAgoraEngine();

        Get.snackbar(
          "Connected",
          "You've joined the live session",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      } else {
        showErrorMessage(
          title: "Connection Failed",
          message: "Unable to join the webinar session",
        );
      }
    } catch (e) {
      print("Error joining webinar session: $e");

      // Handle specific error cases
      String errorMessage = "Unable to join the webinar session";
      if (e.toString().contains("409") ||
          e.toString().contains("already exists")) {
        errorMessage = "You're already in this webinar session";
        hasJoined.value = true; // Mark as joined since we're already in
      } else if (e.toString().contains("403")) {
        errorMessage = "You don't have permission to join this webinar";
      } else if (e.toString().contains("404")) {
        errorMessage = "Webinar session not found";
      }

      showErrorMessage(title: "Connection Error", message: errorMessage);
    }
  }

  Future<void> leaveWebinar() async {
    try {
      if (hasJoined.value) {
        final success = await _webinarService.leaveWebinar(webinarId);

        if (success) {
          hasJoined.value = false;
          print("Left webinar successfully");
        } else {
          print("Failed to leave webinar");
        }

        // Cleanup Agora resources
        await _cleanupAgora();
      }
    } catch (e) {
      print("Error leaving webinar: $e");
    }
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      durationText.value = sessionDuration;
    });
  }

  void toggleFullscreen() async {
    // Mark function as async
    isFullscreen.value = !isFullscreen.value;

    if (isFullscreen.value) {
      // ENTER Fullscreen: Allow both landscape options
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // EXIT Fullscreen:
      // Option A: If you want to force Portrait only:
      /* await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); 
    */

      // Option B: If you want to allow Auto-Rotation (Normal behavior):
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    // The delay is still useful for waiting for the rotation animation to finish
    // before rebuilding layout-dependent widgets.
    Future.delayed(const Duration(milliseconds: 300), () {
      isFullscreen.refresh();
      update();
    });
  }

  void toggleMic() {
    isMicOn.value = !isMicOn.value;
    // TODO: Agora toggle mic
    print("Mic ${isMicOn.value ? 'enabled' : 'disabled'}");
  }

  void toggleVideo() {
    isVideoOn.value = !isVideoOn.value;
    // TODO: Agora toggle video
    print("Video ${isVideoOn.value ? 'enabled' : 'disabled'}");
  }

  // --- Q&A Logic ---

  Future<void> fetchQuestions() async {
    try {
      // Prefer friendly webinarId for these endpoints as confirmed by logs
      final targetId = webinar.value?.webinarId ?? webinarId;
      // print("Fetching questions for webinar: $targetId");
      final fetchedQuestions = await _webinarService.getQuestions(targetId);
      questions.assignAll(fetchedQuestions);
      qaCount.value = questions.length;
      // print("Loaded ${questions.length} questions for $targetId");
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }

  void _startQuestionPolling() {
    _questionPollingTimer?.cancel();
    _questionPollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (hasJoined.value) {
        fetchQuestions();
      }
    });
  }

  Future<void> submitQuestion() async {
    final text = questionController.text.trim();
    if (text.isEmpty) {
      showErrorMessage(title: "Error", message: "Please enter a question");
      return;
    }

    if (text.length < 5 || text.length > 500) {
      showErrorMessage(
        title: "Invalid Input",
        message: "Question must be between 5 and 500 characters",
      );
      return;
    }

    try {
      setLoadingState(true);
      final targetId = webinar.value?.webinarId ?? webinarId;
      print("Submit Question - targetId: $targetId (webinarId: $webinarId)");

      final success = await _webinarService.submitQuestion(targetId, text);

      if (success) {
        Get.snackbar(
          "Success",
          "Question submitted successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        questionController.clear();

        // Refresh questions
        await fetchQuestions();
      } else {
        showErrorMessage(title: "Error", message: "Failed to submit question");
      }
    } catch (e) {
      print("Error submitting question: $e");
      showErrorMessage(title: "Error", message: "An unexpected error occurred");
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> upvoteQuestion(String questionId) async {
    if (_upvotedQuestions.contains(questionId)) {
      Get.snackbar(
        "Notice",
        "You have already upvoted this question",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final targetId = webinar.value?.webinarId ?? webinarId;
      print("Upvoting question: $questionId in webinar: $targetId");

      final success = await _webinarService.upvoteQuestion(
        targetId,
        questionId,
      );

      if (success) {
        _upvotedQuestions.add(questionId);
        // Refresh questions to show updated count locally
        await fetchQuestions();
        Get.snackbar(
          "Success",
          "Upvoted successfully",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      } else {
        showErrorMessage(
          title: "Notice",
          message:
              "Could not upvote at this time. It might be already upvoted.",
        );
      }
    } catch (e) {
      print("Error upvoting question: $e");
      showErrorMessage(
        title: "Error",
        message: "Failed to upvote. Please try again.",
      );
    }
  }

  void _startTokenRefreshTimer(String? expiresAtStr) {
    _tokenRefreshTimer?.cancel();
    if (expiresAtStr == null) return;

    try {
      final expiresAt = DateTime.parse(expiresAtStr);
      final now = DateTime.now();
      final difference = expiresAt.difference(now);

      // Refresh 5 minutes before expiry
      final leadTime = const Duration(minutes: 5);
      final refreshDelay = difference - leadTime;

      if (refreshDelay.isNegative) {
        // Already close to expiry or expired, refresh now
        _refreshToken();
      } else {
        _tokenRefreshTimer = Timer(refreshDelay, () => _refreshToken());
      }
    } catch (e) {
      print("Error setting up token refresh timer: $e");
    }
  }

  Future<void> _refreshToken() async {
    try {
      final response = await _webinarService.refreshToken(webinarId);
      if (response != null && response.token != null) {
        agoraToken = response.token;
        // Notify Agora SDK of new token if implemented
        // _agoraEngine?.renewToken(agoraToken!);

        print("Token refreshed successfully");

        // Schedule next refresh
        if (response.expiresAt != null) {
          _startTokenRefreshTimer(response.expiresAt);
        }
      }
    } catch (e) {
      print("Error refreshing token: $e");
      // Retry in 1 minute on failure
      _tokenRefreshTimer = Timer(
        const Duration(minutes: 1),
        () => _refreshToken(),
      );
    }
  }

  // Get session duration
  String get sessionDuration {
    if (_joinedAt == null) return '0:00';

    final duration = DateTime.now().difference(_joinedAt!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}';
    } else {
      final seconds = duration.inSeconds.remainder(60);
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  // --- Agora Platform Logic ---

  Future<void> _initializeAgoraEngine() async {
    if (agoraAppId == null || agoraChannelName == null || agoraToken == null) {
      print("Missing Agora credentials, cannot initialize");
      return;
    }

    try {
      // 1. Request permissions
      await [Permission.microphone, Permission.camera].request();

      // 2. Create engine
      agoraEngine = createAgoraRtcEngine();
      await agoraEngine!.initialize(RtcEngineContext(appId: agoraAppId));

      // 3. Register event handlers
      agoraEngine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print("Successfully joined Agora channel: ${connection.channelId}");
          },
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            print("Remote user joined: $uid");
            remoteUid.value = uid;
          },
          onUserOffline:
              (
                RtcConnection connection,
                int uid,
                UserOfflineReasonType reason,
              ) {
                print("Remote user offline: $uid");
                if (remoteUid.value == uid) {
                  remoteUid.value = 0;
                }
              },
          onError: (ErrorCodeType err, String msg) {
            print("Agora error: $err - $msg");
          },
        ),
      );

      // 4. Enable video/audio
      await agoraEngine!.enableVideo();
      await agoraEngine!.setClientRole(role: ClientRoleType.clientRoleAudience);

      // 5. Join Channel
      await agoraEngine!.joinChannel(
        token: agoraToken!,
        channelId: agoraChannelName!,
        uid: agoraUid ?? 0,
        options: const ChannelMediaOptions(),
      );

      isEngineInitialized.value = true;
    } catch (e) {
      print("Error initializing Agora: $e");
    }
  }

  Future<void> _cleanupAgora() async {
    try {
      if (agoraEngine != null) {
        await agoraEngine!.leaveChannel();
        await agoraEngine!.release();
        agoraEngine = null;
        isEngineInitialized.value = false;
        remoteUid.value = 0;
      }
    } catch (e) {
      print("Error cleaning up Agora: $e");
    }
  }
}
