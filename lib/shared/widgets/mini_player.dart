import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../modules/player/controllers/player_controller.dart';
import '../../modules/player/views/player_view.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Obx(() {
      final episode = controller.currentEpisode.value;
      if (episode == null || !controller.isPlaying.value && controller.position.value == Duration.zero) {
        return const SizedBox.shrink();
      }

      return GestureDetector(
        onTap: () => Get.to(() => const PlayerView(), arguments: episode),
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1E),
            border: Border(top: BorderSide(color: Color(0xFF2A2A2E), width: 1)),
          ),
          child: Column(
            children: [
              Obx(() {
                final progress = controller.duration.value.inMilliseconds > 0
                    ? controller.position.value.inMilliseconds / controller.duration.value.inMilliseconds
                    : 0.0;
                
                return SizedBox(
                  height: 2,
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00C853)),
                  ),
                );
              }),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: episode.thumbnail ?? episode.coverImage ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 50,
                            height: 50,
                            color: const Color(0xFF252529),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 50,
                            height: 50,
                            color: const Color(0xFF252529),
                            child: const Icon(Icons.podcasts, color: Colors.white54, size: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              episode.title ?? 'Untitled',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              episode.podcastTitle ?? 'Unknown Podcast',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous, color: Colors.white),
                            onPressed: controller.playPrevious,
                          ),
                          Obx(() => IconButton(
                            icon: Icon(
                              controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                              color: const Color(0xFF00C853),
                              size: 32,
                            ),
                            onPressed: controller.togglePlayPause,
                          )),
                          IconButton(
                            icon: const Icon(Icons.skip_next, color: Colors.white),
                            onPressed: controller.playNext,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white60),
                            onPressed: controller.stop,
                          ),
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
    });
  }
}
