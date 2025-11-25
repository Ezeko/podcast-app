import 'package:get/get.dart';

import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/login/views/login_view.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/player/views/player_view.dart';
import '../../modules/categories/views/categories_view.dart';
import '../../modules/main/views/main_view.dart';
import '../../modules/episodes/views/all_episodes_view.dart';
import '../../modules/profile/views/profile_view.dart';
import '../../modules/library/views/library_view.dart';
import '../bindings/app_bindings.dart';
import '../middleware/auth_middleware.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: AppBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.player,
      page: () => const PlayerView(),
      binding: AppBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesView(),
      binding: AppBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      binding: AppBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.allEpisodes,
      page: () => const AllEpisodesView(),
      binding: AppBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: AppBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.library,
      page: () => const LibraryView(),
      binding: AppBindings(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
