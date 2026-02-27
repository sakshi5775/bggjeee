import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/data_model/devotional_music_model.dart';

/// Shared audio player service that persists across screens.
/// Registered via Get.put so both library and player controllers share it.
class AudioPlayerService extends GetxService {
  final AudioPlayer audioPlayer = AudioPlayer();

  // Playlist & current track
  final RxList<DevotionalMusicItem> playlist = <DevotionalMusicItem>[].obs;
  final RxInt currentIndex = 0.obs;

  // Playback state
  final RxBool isPlaying = false.obs;
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> bufferedPosition = Duration.zero.obs;

  // Controls
  final RxBool isRepeat = false.obs;
  final RxBool isShuffle = false.obs;

  // Whether mini-player should be visible
  final RxBool isMiniPlayerVisible = false.obs;

  DevotionalMusicItem? get currentTrack =>
      playlist.isNotEmpty && currentIndex.value < playlist.length
      ? playlist[currentIndex.value]
      : null;

  @override
  void onInit() {
    super.onInit();

    audioPlayer.positionStream.listen((pos) {
      currentPosition.value = pos;
    });

    audioPlayer.durationStream.listen((dur) {
      if (dur != null) totalDuration.value = dur;
    });

    audioPlayer.bufferedPositionStream.listen((buf) {
      bufferedPosition.value = buf;
    });

    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _onTrackCompleted();
      }
    });
  }

  Future<void> playTrack(
    int index, {
    List<DevotionalMusicItem>? newPlaylist,
  }) async {
    if (newPlaylist != null) {
      playlist.assignAll(newPlaylist);
    }
    if (index < 0 || index >= playlist.length) return;
    currentIndex.value = index;
    isMiniPlayerVisible.value = true;
    try {
      await audioPlayer.setUrl(playlist[index].audioUrl);
      audioPlayer.play();
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  void togglePlay() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void playNext() {
    if (isShuffle.value && playlist.length > 1) {
      final indices = List.generate(playlist.length, (i) => i)
        ..remove(currentIndex.value);
      indices.shuffle();
      playTrack(indices.first);
    } else if (currentIndex.value < playlist.length - 1) {
      playTrack(currentIndex.value + 1);
    }
  }

  void playPrevious() {
    if (currentPosition.value.inSeconds > 3) {
      audioPlayer.seek(Duration.zero);
    } else if (currentIndex.value > 0) {
      playTrack(currentIndex.value - 1);
    }
  }

  void toggleRepeat() {
    isRepeat.value = !isRepeat.value;
  }

  void toggleShuffle() {
    isShuffle.value = !isShuffle.value;
  }

  void stopAndDismiss() {
    audioPlayer.stop();
    isMiniPlayerVisible.value = false;
    isPlaying.value = false;
    currentPosition.value = Duration.zero;
    totalDuration.value = Duration.zero;
  }

  void _onTrackCompleted() {
    if (isRepeat.value) {
      audioPlayer.seek(Duration.zero);
      audioPlayer.play();
    } else {
      playNext();
    }
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
