import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/youtube_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AllVideosController extends BaseController {
  final YouTubeService _youtubeService = YouTubeService();

  // YouTube State
  final RxList<YouTubeVideo> videos = <YouTubeVideo>[].obs;
  final RxBool isLoading = false.obs;

  // YouTube State

  final RxBool isGridView = true.obs;
  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map && Get.arguments['tab'] != null) {
      selectedTabIndex.value = Get.arguments['tab'] as int;
    }
    loadVideos();
  }

  Future<void> loadVideos() async {
    try {
      isLoading.value = true;
      final list = await _youtubeService.getChannelVideos();
      videos.assignAll(list);
      if (kDebugMode) {
        print('AllVideos: Loaded ${list.length} YouTube videos');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AllVideos: Error loading YouTube videos $e');
      }
      showErrorMessage(message: 'Failed to load YouTube videos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    if (selectedTabIndex.value == 0) {
      await loadVideos();
    }
  }

  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }
}
