import 'package:get/get.dart';
import '../controllers/player_controller.dart';
import '../../../data/repositories/podcast_repository.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PodcastRepository());
    Get.lazyPut(() => PlayerController());
  }
}
