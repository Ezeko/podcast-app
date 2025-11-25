import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/home_controller.dart';

import '../../../shared/widgets/error_widget.dart';
import '../../../app/routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: Obx(() {
            if (controller.state.value == HomeState.loading) {
              // Pull-to-refresh with full-screen shimmer placeholder
              return RefreshIndicator(
                onRefresh: controller.refreshPodcasts,
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[800]!,
                        highlightColor: Colors.grey[700]!,
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          
          if (controller.state.value == HomeState.error) {
            return ErrorDisplay(
              message: controller.errorMessage.value,
              onRetry: controller.fetchData,
            );
          }
          
          return CustomScrollView(
            slivers: [
              _buildAppBar(size),
              _buildHotTrendingSection(controller, size),
              _buildEditorPickSection(controller, size),
              _buildHandpickedSection(controller, size),
              _buildNewestEpisodesSection(controller, size),
              _buildMixedCategoriesSection(controller, size),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAppBar(Size size) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF0B0B0F),
      floating: true,
      elevation: 0,
      toolbarHeight: 70,
      title: Image.asset(
        'assets/images/jolly_logo.png',
        width: size.width * 0.2,
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
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF00C853),
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                onPressed: () => Get.toNamed(AppRoutes.profile),
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
        ),
      ],
    );
  }

  Widget _buildHotTrendingSection(HomeController controller, Size size) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(size.width * 0.05, 20, size.width * 0.05, 16),
            child: const Text(
              '🔥 Hot & trending episodes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.52,
            child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              itemCount: controller.trendingEpisodes.length,
              itemBuilder: (context, index) {
                final episode = controller.trendingEpisodes[index];
                return _buildTrendingCard(episode, controller, size);
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(dynamic episode, HomeController controller, Size size) {
    
    return GestureDetector(
      onTap: () => controller.navigateToPlayer(episode),
      child: Container(
        width: size.width * 0.7,
        margin: EdgeInsets.only(right: size.width * 0.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A5F), // Dark blue
              Color(0xFF0D1F3C), // Darker navy
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: episode.thumbnail ?? episode.coverImage ?? '',
                    width: size.width * 0.7,
                    height: size.height * 0.25,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: size.height * 0.25,
                      color: const Color(0xFF252529),
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFF00C853)),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: size.height * 0.25,
                      color: const Color(0xFF252529),
                      child: const Icon(Icons.podcasts, color: Colors.white54, size: 60),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C853),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      episode.podcastTitle ?? 'Unknown Podcast',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      episode.title ?? 'Untitled',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Expanded(
                      child: Text(
                        episode.description ?? 'In this episode of the Change Africa Podcast, we host Tarek Mouganie, the multifaceted founder and CEO of Affinity Africa. The epi...',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    Row(
                      children: [
                        _buildActionButton(Icons.favorite_border, size),
                        SizedBox(width: size.width * 0.03),
                        _buildActionButton(Icons.playlist_add, size),
                        SizedBox(width: size.width * 0.03),
                        _buildActionButton(Icons.share, size),
                        SizedBox(width: size.width * 0.03),
                        _buildActionButton(Icons.download_outlined, size),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Size size) {
    return Container(
      width: size.width * 0.1,
      height: size.width * 0.1,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildEditorPickSection(HomeController controller, Size size) {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.editorPickEpisodes.isEmpty) return const SizedBox.shrink();
        
        final episode = controller.editorPickEpisodes.first;
        
        return Padding(
          padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.04, size.width * 0.05, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '✨ Editor\'s pick',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              GestureDetector(
                onTap: () => controller.navigateToPlayer(episode),
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.04),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00C853), // Bright green
                        Color(0xFF009624), // Darker green
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: episode.thumbnail ?? episode.coverImage ?? '',
                              width: size.width * 0.35,
                              height: size.width * 0.35,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                width: size.width * 0.35,
                                height: size.width * 0.35,
                                color: const Color(0xFF252529),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                width: size.width * 0.35,
                                height: size.width * 0.35,
                                color: const Color(0xFF252529),
                                child: const Icon(Icons.podcasts, color: Colors.white54, size: 40),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00C853),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              episode.title ?? 'Reliable Takes on Africa...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: size.height * 0.008),
                            Text(
                              'By: ${episode.podcastTitle ?? 'Sema Nasi'}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: size.height * 0.012),
                            Text(
                              episode.description ?? 'A South African podcast that celebrates local art...',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: size.height * 0.015),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Follow', style: TextStyle(fontSize: 11)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white54),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.share, color: Colors.white54, size: 20),
                                  onPressed: () {},
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHandpickedSection(HomeController controller, Size size) {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.handpickedPodcasts.isEmpty) return const SizedBox.shrink();
        
        return Padding(
          padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.04, size.width * 0.05, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    '🔥',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Handpicked for you',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Podcasts you\'d love',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Column(
                children: controller.handpickedPodcasts.take(3).map((podcast) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: size.height * 0.03),
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: podcast.pictureUrl ?? podcast.coverPictureUrl ?? '',
                            width: double.infinity,
                            height: size.width * 0.8, // Large image
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              height: size.width * 0.8,
                              color: const Color(0xFF252529),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              height: size.width * 0.8,
                              color: const Color(0xFF252529),
                              child: const Icon(Icons.podcasts, color: Colors.white54, size: 60),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          podcast.title ?? 'The NDL Show',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.005),
                        Text(
                          'By: ${podcast.author ?? 'Nathan Bassey'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        Text(
                          podcast.description ?? 'A South African podcast that celebrates local art and music while fostering pivotal and timeless conversations...',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: size.height * 0.025),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Follow', style: TextStyle(fontSize: 14)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow, size: 18),
                              label: const Text('Play', style: TextStyle(fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00C853),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '28 Episodes',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMixedCategoriesSection(HomeController controller, Size size) {
    final categories = [
      {'name': '#Artandculture', 'color': const Color(0xFF2C5F2D)},
      {'name': '#Motivational', 'color': const Color(0xFF8B4513)},
      {'name': '#Sport', 'color': const Color(0xFF1E3A5F)},
      {'name': '#Technology', 'color': const Color(0xFF4A4A4A)},
      {'name': '#Comedy', 'color': const Color(0xFF2C5F2D)},
      {'name': '#Talkshow', 'color': const Color(0xFF2C5F2D)},
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.04, size.width * 0.05, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mixed by interest & categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildCategoryCard(
                  category['name'] as String,
                  category['color'] as Color,
                  size,
                );
              },
            ),
            SizedBox(height: size.height * 0.02),
            Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white38),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Show more', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String name, Color color, Size size) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(4, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.podcasts, color: Colors.white54, size: 20),
                  );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewestEpisodesSection(HomeController controller, Size size) {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (controller.latestEpisodes.isEmpty) return const SizedBox.shrink();
        
        return Padding(
          padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.04, size.width * 0.05, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Newest episodes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Shuffle play', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              ...List.generate(
                controller.latestEpisodes.length.clamp(0, 10),
                (index) {
                  final episode = controller.latestEpisodes[index];
                  return _buildNumberedEpisodeItem(episode, index + 1, controller, size);
                },
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.allEpisodes),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1E),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('See all', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNumberedEpisodeItem(dynamic episode, int number, HomeController controller, Size size) {
    return GestureDetector(
      onTap: () => controller.navigateToPlayer(episode),
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.015),
        child: Row(
          children: [
            // Number
            SizedBox(
              width: size.width * 0.08,
              child: Text(
                number.toString().padLeft(2, '0'),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            // Thumbnail with play button overlay (CENTERED)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: episode.thumbnail ?? episode.coverImage ?? '',
                    width: size.width * 0.18,
                    height: size.width * 0.18,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: size.width * 0.18,
                      height: size.width * 0.18,
                      color: const Color(0xFF252529),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: size.width * 0.18,
                      height: size.width * 0.18,
                      color: const Color(0xFF252529),
                      child: const Icon(Icons.podcasts, color: Colors.white54, size: 24),
                    ),
                  ),
                ),
                // Play button overlay (centered on thumbnail)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C853),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: size.width * 0.03),
            // Episode info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title ?? 'Caleb Maru: Navigating Afric...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    episode.description ?? 'In this episode of the Change Africa Podcast, we host Tarek Mougani...',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    '20 June, 23 · ${episode.formattedDuration}',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
