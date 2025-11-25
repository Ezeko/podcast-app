import 'package:get/get.dart';

class LibraryController extends GetxController {

  static LibraryController get instance => Get.find();
  final RxInt favoritesCount = 4.obs;
  final RxInt recentlyPlayedCount = 3.obs;
  final RxInt playlistsCount = 4.obs;
  final RxInt followingCount = 2.obs;
  
  void goToFavorites() {
    Get.snackbar('Favorites', 'Feature coming soon');
  }
  
  void goToRecentlyPlayed() {
    Get.snackbar('Recently Played', 'Feature coming soon');
  }
  
  void goToPlaylists() {
    Get.snackbar('Playlists', 'Feature coming soon');
  }
  
  void goToFollowing() {
    Get.snackbar('Following', 'Feature coming soon');
  }
  
  void goToQueue() {
    Get.snackbar('Queue', 'Feature coming soon');
  }
}
