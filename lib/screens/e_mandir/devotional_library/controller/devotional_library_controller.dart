import 'package:get/get.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/service/god_category_service.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/data_model/god_category_model.dart';
import '../data_model/devotional_music_model.dart';
import '../service/devotional_music_service.dart';
import '../service/audio_player_service.dart';
import 'package:flutter/material.dart';

class DevotionalLibraryController extends BaseController {
  final GodCategoryService _godCategoryService = Get.put(GodCategoryService());
  final DevotionalMusicService _musicService = Get.put(
    DevotionalMusicService(),
  );

  late final AudioPlayerService audioService;

  final ScrollController godTabScrollController = ScrollController();

  // God categories
  final RxList<GodCategoryModel> godCategories = <GodCategoryModel>[].obs;
  final RxInt selectedGodIndex = 0.obs;
  final RxBool isLoadingCategories = false.obs;

  // Music category filters
  final List<String> musicCategories = [
    'All',
    'Aarti',
    'Chalisa',
    'Bhajan',
    'Mantra',
    'Paath',
    'Stotra',
    'Katha',
    'Stuti',
  ];
  final RxInt selectedMusicCategoryIndex = 0.obs;

  // Tracks
  final RxList<DevotionalMusicItem> tracks = <DevotionalMusicItem>[].obs;
  final RxBool isLoadingTracks = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Register AudioPlayerService if not already registered
    if (!Get.isRegistered<AudioPlayerService>()) {
      Get.put(AudioPlayerService(), permanent: true);
    }
    audioService = Get.find<AudioPlayerService>();
    fetchGodCategories();
  }

  Future<void> fetchGodCategories() async {
    isLoadingCategories.value = true;
    final response = await _godCategoryService.getGodCategories();
    if (response != null && response.success) {
      godCategories.assignAll(response.items);
      if (godCategories.isNotEmpty) {
        fetchTracks();
      }
    }
    isLoadingCategories.value = false;
  }

  void onGodCategoryChanged(int index) {
    if (selectedGodIndex.value == index) return;
    selectedGodIndex.value = index;
    selectedMusicCategoryIndex.value = 0;
    scrollToSelectedGod();
    fetchTracks();
  }

  void scrollToSelectedGod() {
    final index = selectedGodIndex.value;
    if (godTabScrollController.hasClients) {
      final offset = index * 82.0;
      godTabScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onMusicCategoryChanged(int index) {
    if (selectedMusicCategoryIndex.value == index) return;
    selectedMusicCategoryIndex.value = index;
    fetchTracks();
  }

  String get selectedGodId =>
      godCategories.isNotEmpty ? godCategories[selectedGodIndex.value].id : '';

  String get selectedMusicCategory {
    final category = musicCategories[selectedMusicCategoryIndex.value];
    return category == 'All' ? 'all' : category.toLowerCase();
  }

  Future<void> fetchTracks() async {
    if (selectedGodId.isEmpty) return;
    isLoadingTracks.value = true;
    tracks.clear();
    final category = selectedMusicCategory;
    final response = await _musicService.getTracks(selectedGodId, category);
    if (response != null && response.data != null) {
      tracks.assignAll(response.data!.items);
    }
    isLoadingTracks.value = false;
  }

  /// Toggle play/pause for a track in the list (inline play)
  void togglePlayTrack(int trackIndex) {
    final track = tracks[trackIndex];
    final currentTrack = audioService.currentTrack;

    if (currentTrack != null && currentTrack.id == track.id) {
      // Same track — toggle play/pause
      audioService.togglePlay();
    } else {
      // Different track — start playing with full playlist
      audioService.playTrack(trackIndex, newPlaylist: tracks.toList());
    }
  }

  /// Navigate to full player screen
  void navigateToPlayer({int? trackIndex}) {
    final idx = trackIndex ?? audioService.currentIndex.value;
    // If no track is playing yet, start playing
    if (audioService.currentTrack == null && tracks.isNotEmpty) {
      audioService.playTrack(idx, newPlaylist: tracks.toList());
    }
    Get.toNamed(AppRoutes.devotionalPlayer);
  }
}
