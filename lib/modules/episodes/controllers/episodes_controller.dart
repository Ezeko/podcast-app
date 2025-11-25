import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/episode_model.dart';
import '../../../data/repositories/podcast_repository.dart';

class EpisodesController extends GetxController {
  final PodcastRepository _repository = Get.find();
  
  final RxList<EpisodeModel> episodes = <EpisodeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString sortBy = 'Ascending'.obs;
  final RxString filterBy = 'All episodes'.obs;

  @override
  void onInit() {
    super.onInit();
    loadEpisodes();
  }

  Future<void> loadEpisodes() async {
    try {
      isLoading.value = true;
      episodes.value = await _repository.getLatestEpisodes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load episodes');
    } finally {
      isLoading.value = false;
    }
  }

  void showSortOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption('Ascending', () => sortBy.value = 'Ascending'),
            _buildOption('Descending', () => sortBy.value = 'Descending'),
            _buildOption('Most Recent', () => sortBy.value = 'Most Recent'),
          ],
        ),
      ),
    );
  }

  void showFilterOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption('All episodes', () => filterBy.value = 'All episodes'),
            _buildOption('Trending', () => filterBy.value = 'Trending'),
            _buildOption('Latest', () => filterBy.value = 'Latest'),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        onTap();
        Get.back();
      },
    );
  }
}
