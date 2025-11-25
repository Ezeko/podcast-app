import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
// import '../../../data/models/podcast_model.dart';
import '../../../data/models/episode_model.dart';
// import '../../../data/repositories/podcast_repository.dart';

enum PodcastPlayerState { loading, ready, playing, paused, error }

class PlayerController extends GetxController {
  static PlayerController get instance => Get.find();
  // final PodcastRepository _podcastRepository = Get.find();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Podcast data
  EpisodeModel? episode;
  final Rx<EpisodeModel?> currentEpisode = Rx<EpisodeModel?>(null);

  // Player state
  final Rx<PodcastPlayerState> state = PodcastPlayerState.loading.obs;
  final RxString errorMessage = ''.obs;

  // Playback state
  final RxBool isPlaying = false.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;

  // Queue management
  final RxList<EpisodeModel> queue = <EpisodeModel>[].obs;
  final RxInt currentQueueIndex = (-1).obs;


  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  bool _listenersSetup = false;

  void loadPlayer() {
    // Get episode from arguments or existing currentEpisode
    EpisodeModel? newEpisode;
    List<EpisodeModel>? episodeQueue;
    
    if (Get.arguments is Map) {
      final args = Get.arguments as Map;
      newEpisode = args['episode'] as EpisodeModel?;
      episodeQueue = args['queue'] as List<EpisodeModel>?;
    } else if (Get.arguments is EpisodeModel) {
      newEpisode = Get.arguments as EpisodeModel;
    } else if (currentEpisode.value != null) {
      newEpisode = currentEpisode.value;
    } else {
      errorMessage.value = 'Invalid arguments';
      state.value = PodcastPlayerState.error;
      return;
    }

    // If same episode AND currentEpisode is not null, don't reload (preserves position and state)
    if (episode?.id == newEpisode?.id && currentEpisode.value != null) {
      // Ensure currentEpisode is updated just in case
      currentEpisode.value = episode;
      return;
    }

    episode = newEpisode;
    currentEpisode.value = episode;

    // Update queue if provided
    if (episodeQueue != null && episodeQueue.isNotEmpty) {
      queue.value = episodeQueue;
      currentQueueIndex.value = episodeQueue.indexWhere((e) => e.id == episode?.id);
    } else if (queue.isEmpty) {
      // If no queue provided, create a single-item queue
      queue.value = [episode!];
      currentQueueIndex.value = 0;
    }

    // Setup audio player listeners only once
    if (!_listenersSetup) {
      _setupAudioPlayerListeners();
      _listenersSetup = true;
    }

    // Load episode
    loadEpisode();
  }

  void _setupAudioPlayerListeners() {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.playing) {
        isPlaying.value = true;
        if (state.value == PodcastPlayerState.ready ||
            state.value == PodcastPlayerState.paused) {
          state.value = PodcastPlayerState.playing;
        }
      } else if (playerState == PlayerState.paused) {
        isPlaying.value = false;
        if (state.value == PodcastPlayerState.playing) {
          state.value = PodcastPlayerState.paused;
        }
      } else if (playerState == PlayerState.disposed) {
        isPlaying.value = false;
        state.value = PodcastPlayerState.ready;
      }
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((Duration d) {
      duration.value = d;
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((Duration p) {
      position.value = p;
    });
  }

  Future<void> loadEpisode() async {
    if (episode == null) {
      errorMessage.value = 'Episode data missing';
      state.value = PodcastPlayerState.error;
      return;
    }
    try {
      state.value = PodcastPlayerState.loading;
      errorMessage.value = '';
      // print(' PlayerController: Loading episode #${episode!.id}');
      // print('   Title: ${episode!.title}');

      // Set audio source if available
      if (episode!.audioUrl != null && episode!.audioUrl!.isNotEmpty) {
        await _audioPlayer.setSourceUrl(episode!.audioUrl!);
        state.value = PodcastPlayerState.ready;
        // print('✅ PlayerController: Audio source set');

        // Auto play
        await _audioPlayer.resume();
      } else {
        // print('⚠️ PlayerController: No audio URL available');
        state.value = PodcastPlayerState.ready; // Just show info
      }
    } catch (e) {
      // print('❌ PlayerController: Load error: $e');
      errorMessage.value = 'Failed to load episode: ${e.toString()}';
      state.value = PodcastPlayerState.error;
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (isPlaying.value) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      // print('Toggle play/pause error: $e');
      errorMessage.value = e.toString();
      state.value = PodcastPlayerState.error;
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      // print('Seek error: $e');
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '$minutes:${twoDigits(seconds)}';
  }

  Future<void> skipForward10() async {
    try {
      final newPosition = position.value + const Duration(seconds: 10);
      if (newPosition < duration.value) {
        await _audioPlayer.seek(newPosition);
      } else {
        await _audioPlayer.seek(duration.value);
      }
    } catch (e) {
      // print('Skip forward error: $e');
    }
  }

  Future<void> skipBackward10() async {
    try {
      final newPosition = position.value - const Duration(seconds: 10);
      if (newPosition.isNegative) {
        await _audioPlayer.seek(Duration.zero);
      } else {
        await _audioPlayer.seek(newPosition);
      }
    } catch (e) {
      // print('Skip backward error: $e');
    }
  }

  void addToQueue() {
    // TODO: Implement add to queue functionality
    Get.snackbar(
      'Add to Queue',
      'Episode will be added to queue (Coming soon)',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void saveEpisode() {
    // TODO: Implement save/favorite episode functionality
    Get.snackbar(
      'Save Episode',
      'Episode saved to your library (Coming soon)',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void shareEpisode() {
    // TODO: Implement share functionality
    Get.snackbar(
      'Share Episode',
      'Share functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void addToPlaylist() {
    // TODO: Navigate to playlist selection
    Get.snackbar(
      'Add to Playlist',
      'Playlist selection coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToEpisodePage() {
    Get.snackbar(
      'Episode Page',
      'Episode details page coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void playPrevious() {
    if (queue.isEmpty || currentQueueIndex.value <= 0) {
      Get.snackbar(
        'No Previous Episode',
        'This is the first episode in the queue',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    currentQueueIndex.value--;
    final previousEpisode = queue[currentQueueIndex.value];
    episode = previousEpisode;
    currentEpisode.value = previousEpisode;
    loadEpisode();
  }

  void playNext() {
    if (queue.isEmpty || currentQueueIndex.value >= queue.length - 1) {
      Get.snackbar(
        'No Next Episode',
        'This is the last episode in the queue',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    currentQueueIndex.value++;
    final nextEpisode = queue[currentQueueIndex.value];
    episode = nextEpisode;
    currentEpisode.value = nextEpisode;
    loadEpisode();
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      isPlaying.value = false;
      position.value = Duration.zero;
      currentEpisode.value = null;
    } catch (e) {
      // print('Stop error: $e');
    }
  }
}
