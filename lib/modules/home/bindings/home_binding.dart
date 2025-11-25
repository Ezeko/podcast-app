import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/repositories/podcast_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PodcastRepository());
    Get.lazyPut(() => HomeController());
  }
}
