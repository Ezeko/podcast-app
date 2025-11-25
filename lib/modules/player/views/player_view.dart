import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/player_controller.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/constants/app_strings.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;

    return Scaffold(
      body: Obx(() {
        // widgetBindings to reactively update UI based on controller state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PlayerController.instance.loadPlayer();
        });
        switch (controller.state.value) {
          case PodcastPlayerState.loading:
            return const LoadingIndicator(message: 'Loading episode...');
          case PodcastPlayerState.error:
            return ErrorDisplay(
              message: controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : AppStrings.episodeLoadError,
              onRetry: controller.loadEpisode,
            );
          default:
            return _buildPlayerUI(context, controller);
        }
      }),
    );
  }

  Widget _buildPlayerUI(BuildContext context, PlayerController controller) {
    final episode = controller.currentEpisode.value;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF00C853), // Bright green
            Color(0xFF009624), // Darker green
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            // Top bar with back button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Album Art
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                        episode?.thumbnail != null ||
                            episode?.coverImage != null
                        ? CachedNetworkImage(
                            imageUrl:
                                episode?.thumbnail ?? episode?.coverImage ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF1A1A1E),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF1A1A1E),
                              child: const Icon(
                                Icons.music_note_rounded,
                                size: 80,
                                color: Colors.white54,
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF1A1A1E),
                            child: const Icon(
                              Icons.music_note_rounded,
                              size: 80,
                              color: Colors.white54,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Track Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    episode?.title ?? 'Unknown Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    episode?.description ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Obx(() {
                final position = controller.position.value;
                final duration = controller.duration.value;
                final progress = duration.inMilliseconds > 0
                    ? position.inMilliseconds / duration.inMilliseconds
                    : 0.0;

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white30,
                        thumbColor: Colors.white,
                        overlayColor: Colors.white.withValues(alpha: 0.2),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                      ),
                      child: Slider(
                        value: progress.clamp(0.0, 1.0),
                        onChanged: (value) {
                          final newPosition = Duration(
                            milliseconds: (value * duration.inMilliseconds)
                                .round(),
                          );
                          controller.seek(newPosition);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.formatDuration(position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            controller.formatDuration(duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 24),

            // Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rewind
                IconButton(
                  icon: const Icon(Icons.fast_rewind_rounded, color: Colors.white, size: 28),
                  onPressed: controller.playPrevious,
                ),
                const SizedBox(width: 24),
                // Replay 10s
                IconButton(
                  icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 28),
                  onPressed: controller.skipBackward10,
                ),
                const SizedBox(width: 24),
                // Play/Pause
                Obx(() => GestureDetector(
                  onTap: controller.togglePlayPause,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white, // White background
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 40,
                      color: const Color(0xFF00C853), // Green icon
                    ),
                  ),
                )),
                const SizedBox(width: 24),
                // Forward 10s
                IconButton(
                  icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 28),
                  onPressed: controller.skipForward10,
                ),
                const SizedBox(width: 24),
                // Fast Forward
                IconButton(
                  icon: const Icon(Icons.fast_forward_rounded, color: Colors.white, size: 28),
                  onPressed: controller.playNext,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Action Buttons Row 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildPillButton(
                      icon: Icons.queue_music,
                      label: 'Add to queue',
                      onPressed: controller.addToQueue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPillButton(
                      icon: Icons.favorite_border,
                      label: 'Save',
                      onPressed: controller.saveEpisode,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPillButton(
                      icon: Icons.share_outlined,
                      label: 'Share episode',
                      onPressed: controller.shareEpisode,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons Row 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildPillButton(
                      icon: Icons.add_circle_outline,
                      label: 'Add to playlist',
                      onPressed: controller.addToPlaylist,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPillButton(
                      icon: Icons.arrow_forward,
                      label: 'Go to episode page',
                      onPressed: controller.goToEpisodePage,
                      isTrailingIcon: true,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildPillButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isTrailingIcon = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white38),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isTrailingIcon) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isTrailingIcon) ...[
            const SizedBox(width: 8),
            Icon(icon, size: 18),
          ],
        ],
      ),
    );
  }
}
