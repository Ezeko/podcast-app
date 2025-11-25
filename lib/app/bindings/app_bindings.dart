import 'package:get/get.dart';
import 'package:jolly_podcast/modules/library/controllers/library_controller.dart';
import 'package:jolly_podcast/modules/profile/controllers/profile_controller.dart';

import '../../modules/onboarding/controllers/onboarding_controller.dart';
import '../../modules/login/controllers/login_controller.dart';
import '../../modules/main/controllers/main_controller.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../modules/categories/controllers/categories_controller.dart';
import '../../modules/player/controllers/player_controller.dart';
import '../../modules/episodes/controllers/episodes_controller.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/podcast_repository.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    _injectRepositories();
    _injectControllers();
  }

  void _injectRepositories() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<PodcastRepository>(() => PodcastRepository(), fenix: true);
  }

  void _injectControllers() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CategoriesController>(
      () => CategoriesController(),
      fenix: true,
    );
    Get.lazyPut<PlayerController>(() => PlayerController(), fenix: true);
    Get.lazyPut<EpisodesController>(() => EpisodesController(), fenix: true);
    Get.lazyPut<LibraryController>(() => LibraryController(), fenix: true);

    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
