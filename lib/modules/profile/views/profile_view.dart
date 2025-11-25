import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/mini_player.dart';
import '../../player/controllers/player_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure PlayerController is available
    if (!Get.isRegistered<PlayerController>()) {
      Get.put(PlayerController());
    }
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with logo
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/jolly_logo.png',
                      width: 100,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Text(
                        'Jolly',
                        style: TextStyle(
                          color: Color(0xFF00C853),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Go back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Go back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF00C853), width: 3),
                ),
                child: ClipOval(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: const Color(0xFF00C853),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Name
              Obx(() => Text(
                controller.userName.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )),
              
              const SizedBox(height: 20),
              
              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Following', controller.following.value.toString()),
                    _buildStat('Playlists', controller.playlists.value.toString()),
                    _buildStat('Minutes listened', controller.minutesListened.value.toString()),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Menu items
              _buildMenuItem(
                icon: Icons.person,
                title: 'Account settings',
                onTap: controller.goToAccountSettings,
                iconColor: const Color(0xFFF48FB1), // Pinkish
              ),
              _buildMenuItem(
                icon: Icons.lock,
                title: 'Security settings',
                onTap: controller.goToSecuritySettings,
                iconColor: const Color(0xFF5DADE2), // Blue
              ),
              _buildMenuItem(
                icon: Icons.chat_bubble,
                title: 'Notifications',
                onTap: controller.goToNotifications,
                iconColor: const Color(0xFF5DADE2), // Blue
              ),
              _buildMenuItem(
                icon: Icons.layers,
                title: 'Become a podcast creator',
                onTap: controller.becomePodcastCreator,
                iconColor: const Color(0xFFFFB74D), // Orange/Yellow
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: controller.logout,
                iconColor: const Color(0xFFE74C3C), // Red
              ),
              
              const SizedBox(height: 40),
              
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Terms',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 40),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Privacy policy',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          _buildBottomNav(),
        ],
      ),
    );
  }
  
  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1E),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2E), width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF00C853),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: 2, // Your Library selected
        onTap: (index) {
          if (index == 0) Get.offAllNamed('/main');
          if (index == 1) Get.offAllNamed('/categories');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Your Library',
          ),
        ],
      ),
    );
  }
}
