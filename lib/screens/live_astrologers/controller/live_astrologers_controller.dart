import 'dart:async';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/live_stream_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/live_stream_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LiveAstrologersController extends BaseController {
  final LiveStreamService _liveStreamService = LiveStreamService();
  final AstrologerService _astrologerService = AstrologerService();

  // Tab state
  final RxInt selectedTab = 0.obs; // 0 = ONGOING, 1 = UPCOMING
  Timer? _liveStreamPollTimer;

  // ONGOING streams (live)
  final RxList<LiveStreamModel> liveStreams = <LiveStreamModel>[].obs;
  final RxBool isLoadingLiveStreams = false.obs;
  final RxMap<String, String?> astrologerProfilePictures =
      <String, String?>{}.obs;
  final RxMap<String, String?> astrologerNames = <String, String?>{}.obs;

  // UPCOMING streams (scheduled)
  final RxList<UpcomingStreamModel> upcomingStreams =
      <UpcomingStreamModel>[].obs;
  final RxBool isLoadingUpcomingStreams = false.obs;
  final RxMap<String, String?> upcomingAstrologerProfilePictures =
      <String, String?>{}.obs;
  final RxMap<String, String?> upcomingAstrologerNames =
      <String, String?>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLiveStreams();
    loadUpcomingStreams();
    _startPolling();
  }

  void _startPolling() {
    _liveStreamPollTimer?.cancel();
    _liveStreamPollTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (selectedTab.value == 0) {
        _pollLiveStreams();
      }
    });
  }

  Future<void> _pollLiveStreams() async {
    try {
      final response = await _liveStreamService.getLiveStreams(
        page: 1,
        limit: 100,
        useCache: false,
      );
      if (response != null) {
        liveStreams.value = response.streams
            .where((s) => s.status == 'LIVE')
            .toList();
      }
    } catch (e) {
      debugPrint('Error polling live streams: $e');
    }
  }

  @override
  void onClose() {
    _liveStreamPollTimer?.cancel();
    super.onClose();
  }

  // Load live streams (ONGOING tab)
  Future<void> loadLiveStreams() async {
    try {
      isLoadingLiveStreams.value = true;
      final response = await _liveStreamService.getLiveStreams(
        page: 1,
        limit: 100,
      );

      if (response != null) {
        // Filter for LIVE status only
        liveStreams.value = response.streams
            .where((s) => s.status == 'LIVE')
            .toList();
        await _loadAstrologerDetails(liveStreams);
      }
    } catch (e) {
      debugPrint('Error loading live streams: $e');
    } finally {
      isLoadingLiveStreams.value = false;
    }
  }

  // Load upcoming streams (UPCOMING tab)
  Future<void> loadUpcomingStreams() async {
    try {
      isLoadingUpcomingStreams.value = true;
      final response = await _liveStreamService.getUpcomingStreams(
        page: 1,
        limit: 100,
      );

      if (response != null) {
        upcomingStreams.value = response.streams;
        await _loadUpcomingAstrologerDetails(response.streams);
      }
    } catch (e) {
      debugPrint('Error loading upcoming streams: $e');
    } finally {
      isLoadingUpcomingStreams.value = false;
    }
  }

  // Load astrologer details for live streams
  Future<void> _loadAstrologerDetails(List<LiveStreamModel> streams) async {
    try {
      final astrologerResponse = await _astrologerService.getAstrologers(
        limit: 100,
      );
      if (astrologerResponse != null) {
        final Map<String, String?> profileMap = {};
        final Map<String, String?> nameMap = {};

        for (final astrologer in astrologerResponse.astrologers) {
          final name = astrologer.displayName.isNotEmpty
              ? astrologer.displayName
              : astrologer.name;

          profileMap[astrologer.astrologerId] = astrologer.profilePicture;
          profileMap[astrologer.id] = astrologer.profilePicture;

          nameMap[astrologer.astrologerId] = name;
          nameMap[astrologer.id] = name;
        }

        astrologerProfilePictures.value = profileMap;
        astrologerNames.value = nameMap;
      }
    } catch (e) {
      debugPrint('Error loading astrologer details: $e');
    }
  }

  // Load astrologer details for upcoming streams
  Future<void> _loadUpcomingAstrologerDetails(
    List<UpcomingStreamModel> streams,
  ) async {
    try {
      final astrologerResponse = await _astrologerService.getAstrologers(
        limit: 100,
      );
      if (astrologerResponse != null) {
        final Map<String, String?> profileMap = {};
        final Map<String, String?> nameMap = {};

        for (final astrologer in astrologerResponse.astrologers) {
          final name = astrologer.displayName.isNotEmpty
              ? astrologer.displayName
              : astrologer.name;

          profileMap[astrologer.astrologerId] = astrologer.profilePicture;
          profileMap[astrologer.id] = astrologer.profilePicture;

          nameMap[astrologer.astrologerId] = name;
          nameMap[astrologer.id] = name;
        }

        upcomingAstrologerProfilePictures.value = profileMap;
        upcomingAstrologerNames.value = nameMap;
      }
    } catch (e) {
      debugPrint('Error loading upcoming astrologer details: $e');
    }
  }

  // Get astrologer name for live stream
  String getAstrologerName(String astrologerId) {
    return astrologerNames[astrologerId] ?? 'Astrologer';
  }

  // Get astrologer profile picture for live stream
  String? getProfilePictureForAstrologer(String astrologerId) {
    return astrologerProfilePictures[astrologerId];
  }

  // Get astrologer name for upcoming stream
  String getUpcomingAstrologerName(String astrologerId) {
    return upcomingAstrologerNames[astrologerId] ?? 'Astrologer';
  }

  // Get astrologer profile picture for upcoming stream
  String? getUpcomingProfilePictureForAstrologer(String astrologerId) {
    return upcomingAstrologerProfilePictures[astrologerId];
  }

  // Switch tabs
  void switchTab(int index) {
    selectedTab.value = index;
  }

  // Refresh data
  Future<void> refresh() async {
    if (selectedTab.value == 0) {
      await loadLiveStreams();
    } else {
      await loadUpcomingStreams();
    }
  }
}
