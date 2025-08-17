import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/model_status.dart';
import '../providers/tts_providers.dart';
import '../providers/model_providers.dart';

class PlaybackControlWidget extends ConsumerWidget {
  const PlaybackControlWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playbackState = ref.watch(ttsPlaybackProvider);
    final text = ref.watch(ttsTextProvider);
    final defaultModel = ref.watch(defaultModelProvider);

    return defaultModel.when(
      data: (model) {
        final modelStatus = ref.watch(modelStatusProvider(model.id));
        
        return modelStatus.when(
          data: (status) {
            final isModelReady = status.state == ModelState.installed ||
                                status.state == ModelState.ready;
            final canPlay = text.isNotEmpty && isModelReady;

            return GestureDetector(
              onTap: canPlay ? () => _handlePlayback(context, ref) : null,
              child: AnimatedContainer(
                duration: AppConstants.animationDuration,
                width: AppConstants.iconSize * 1.5,
                height: AppConstants.iconSize * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getButtonColor(context, playbackState, canPlay),
                  boxShadow: canPlay
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: _buildIcon(context, playbackState, canPlay),
                ),
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => _buildErrorButton(context),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => _buildErrorButton(context),
    );
  }

  Widget _buildIcon(BuildContext context, PlaybackState state, bool canPlay) {
    switch (state) {
      case PlaybackState.loading:
        return SpinKitWave(
          color: Theme.of(context).colorScheme.onPrimary,
          size: 30,
        );
      case PlaybackState.playing:
        return Icon(
          Icons.stop_rounded,
          size: AppConstants.iconSize * 0.7,
          color: Theme.of(context).colorScheme.onPrimary,
        );
      case PlaybackState.idle:
      case PlaybackState.stopped:
      case PlaybackState.error:
      default:
        return Icon(
          Icons.volume_up_rounded,
          size: AppConstants.iconSize * 0.7,
          color: canPlay
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        );
    }
  }

  Color _getButtonColor(
    BuildContext context,
    PlaybackState state,
    bool canPlay,
  ) {
    if (!canPlay) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }

    switch (state) {
      case PlaybackState.playing:
        return Theme.of(context).colorScheme.error;
      case PlaybackState.loading:
        return Theme.of(context).colorScheme.primary.withOpacity(0.8);
      case PlaybackState.error:
        return Theme.of(context).colorScheme.error.withOpacity(0.8);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  void _handlePlayback(BuildContext context, WidgetRef ref) {
    final playbackState = ref.read(ttsPlaybackProvider);
    final text = ref.read(ttsTextProvider);

    if (playbackState == PlaybackState.playing) {
      ref.read(ttsPlaybackProvider.notifier).stop();
    } else if (text.isNotEmpty) {
      ref.read(ttsPlaybackProvider.notifier).generateAndPlay(text);
    }
  }

  Widget _buildErrorButton(BuildContext context) {
    return Container(
      width: AppConstants.iconSize * 1.5,
      height: AppConstants.iconSize * 1.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.errorContainer,
      ),
      child: Icon(
        Icons.error_outline,
        size: AppConstants.iconSize * 0.7,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
    );
  }
}