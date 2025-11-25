import 'package:get/get.dart';
import '../../../data/models/podcast_model.dart';
import '../../../data/models/episode_model.dart';
import '../../../data/repositories/podcast_repository.dart';
import '../../../app/routes/app_routes.dart';

enum HomeState { loading, success, error, empty }

class HomeController extends GetxController {
  final PodcastRepository _podcastRepository = Get.find();
  
  // Observables
  final Rx<HomeState> state = HomeState.loading.obs;
  final RxList<EpisodeModel> trendingEpisodes = <EpisodeModel>[].obs;
  final RxList<EpisodeModel> editorPickEpisodes = <EpisodeModel>[].obs;
  final RxList<PodcastModel> handpickedPodcasts = <PodcastModel>[].obs;
  final RxList<EpisodeModel> latestEpisodes = <EpisodeModel>[].obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
  
  Future<void> fetchData() async {
    try {
      state.value = HomeState.loading;
      errorMessage.value = '';
      
      // print('HomeController: Fetching all data...');
      
      // Fetch all sections in parallel
      final results = await Future.wait([
        _podcastRepository.getTrendingEpisodes(),
        _podcastRepository.getEditorPickEpisodes(),
        _podcastRepository.getLatestEpisodes(),
      ]);
      
      trendingEpisodes.value = results[0];
      editorPickEpisodes.value = results[1];
      latestEpisodes.value = results[2];
      
      // Use editor picks or trending as handpicked for now (can be replaced with dedicated endpoint)
      // Mock some podcasts from episodes
      handpickedPodcasts.value = _mockHandpickedFromEpisodes(editorPickEpisodes);
      
      if (trendingEpisodes.isEmpty && editorPickEpisodes.isEmpty && latestEpisodes.isEmpty) {
        state.value = HomeState.empty;
      } else {
        state.value = HomeState.success;
      }
      
    } catch (e) {
      // print('HomeController: Fetch error: $e');
      errorMessage.value = _parseError(e);
      state.value = HomeState.error;
    }
  }

  List<PodcastModel> _mockHandpickedFromEpisodes(List<EpisodeModel> episodes) {
    // Create mock podcast models from episodes
    return episodes.take(3).map((episode) {
      return PodcastModel(
        id: episode.podcastId != null ? int.tryParse(episode.podcastId!) : null,
        title: episode.podcastTitle ?? 'Unknown Podcast',
        author: 'Various Artists',
        description: episode.description ?? '',
        pictureUrl: episode.thumbnail ?? episode.coverImage,
        coverPictureUrl: episode.coverImage ?? episode.thumbnail,
      );
    }).toList();
  }

  String _parseError(dynamic e) {
    if (e.toString().contains('401')) {
      return 'Please log in again to continue';
    } else if (e.toString().contains('network')) {
      return 'No internet connection';
    }
    return 'Unable to load content';
  }
  
  Future<void> refreshPodcasts() async {
    await fetchData();
  }
  
  void navigateToPlayer(EpisodeModel episode) {
    // Convert Episode to PodcastModel for player compatibility if needed
    // Or update PlayerController to accept EpisodeModel directly
    // For now, we'll pass the episode directly
    Get.toNamed(
      AppRoutes.player,
      arguments: episode,
    );
  }
}
