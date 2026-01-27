import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/youtube_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AllVideosController extends BaseController {
  final YouTubeService _youtubeService = YouTubeService();

  final RxList<YouTubeVideo> videos = <YouTubeVideo>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isGridView = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadVideos();
  }

  Future<void> loadVideos() async {
    try {
      isLoading.value = true;
      final list = await _youtubeService.getChannelVideos();
      videos.value = list;
      if (kDebugMode) {
        print('AllVideos: Loaded ${list.length} videos');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AllVideos: Error loading videos $e');
      }
      showErrorMessage(message: 'Failed to load videos');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadVideos();
  }

  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }
}
