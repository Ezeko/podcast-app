import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/library_controller.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = LibraryController.instance;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,
        title: Image.asset(
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
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed('/profile'),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF00C853),
                child: Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Grid of library cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildLibraryCard(
                    icon: Icons.favorite,
                    title: 'Your Favorites',
                    count: '${controller.favoritesCount.value} Episodes',
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF8B4513), Color(0xFF5D4037)],
                    ),
                    onTap: controller.goToFavorites,
                  ),
                  _buildLibraryCard(
                    icon: Icons.podcasts,
                    title: 'Recently played',
                    count: '${controller.recentlyPlayedCount.value} Episodes',
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
                    ),
                    iconColor: const Color(0xFF00C853),
                    textColor: Colors.black,
                    onTap: controller.goToRecentlyPlayed,
                  ),
                  _buildLibraryCard(
                    icon: Icons.library_music,
                    title: 'Your Playlists',
                    count: '${controller.playlistsCount.value} Playlists',
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                    ),
                    onTap: controller.goToPlaylists,
                  ),
                  _buildLibraryCard(
                    icon: Icons.star,
                    title: 'Podcast you follow',
                    count: '${controller.followingCount.value} Podcasts',
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFAED581), Color(0xFF7CB342)],
                    ),
                    onTap: controller.goToFollowing,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Episodes in queue section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Episodes in queue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: controller.goToQueue,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('See all', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Empty state
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'All the episodes you add to queue will show here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLibraryCard({
    required IconData icon,
    required String title,
    required String count,
    required LinearGradient gradient,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
