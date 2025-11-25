import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_view.dart';
import '../../categories/views/categories_view.dart';
import '../../library/views/library_view.dart';
import '../../../shared/widgets/mini_player.dart';
import '../../player/controllers/player_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure PlayerController is available
    if (!Get.isRegistered<PlayerController>()) {
      Get.put(PlayerController());
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF0B0B0F),
      body: Stack(
        children: [
          Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              const HomeView(),
              const CategoriesView(),
              const LibraryView(),
            ],
          )),
          
          // Mini Player Positioned above Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MiniPlayer(),
                Obx(() => Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFF1A1A1E), width: 1)),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: controller.currentIndex.value,
                    onTap: controller.changePage,
                    backgroundColor: const Color(0xFF0B0B0F),
                    selectedItemColor: const Color(0xFF00C853),
                    unselectedItemColor: Colors.white54,
                    type: BottomNavigationBarType.fixed,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.headphones),
                        label: 'Discover',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.grid_view_rounded),
                        label: 'Categories',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.library_music),
                        label: 'Your Library',
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
