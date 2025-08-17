import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/model_status.dart';
import '../providers/tts_providers.dart';
import '../providers/model_providers.dart';

class StatusMessageWidget extends ConsumerWidget {
  const StatusMessageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(ttsStatusMessageProvider);
    final playbackState = ref.watch(ttsPlaybackProvider);
    final defaultModel = ref.watch(defaultModelProvider);

    return defaultModel.when(
      data: (model) {
        final modelStatus = ref.watch(modelStatusProvider(model.id));
        
        return modelStatus.when(
          data: (status) {
            String displayMessage = message;
            
            // Override message if model is not installed
            if (status.state != ModelState.installed &&
                status.state != ModelState.ready) {
              displayMessage = '모델을 먼저 다운로드하세요';
            }
            
            return AnimatedSwitcher(
              duration: AppConstants.animationDuration,
              child: Container(
                key: ValueKey(displayMessage),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(context, playbackState, status.state),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (playbackState == PlaybackState.loading)
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(right: 8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getTextColor(context, playbackState, status.state),
                          ),
                        ),
                      ),
                    Text(
                      displayMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _getTextColor(context, playbackState, status.state),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => Text(
            '오류가 발생했습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Color _getBackgroundColor(
    BuildContext context,
    PlaybackState playbackState,
    ModelState modelState,
  ) {
    if (modelState != ModelState.installed && modelState != ModelState.ready) {
      return Theme.of(context).colorScheme.errorContainer.withOpacity(0.3);
    }

    switch (playbackState) {
      case PlaybackState.playing:
        return Theme.of(context).colorScheme.primaryContainer;
      case PlaybackState.loading:
        return Theme.of(context).colorScheme.secondaryContainer;
      case PlaybackState.error:
        return Theme.of(context).colorScheme.errorContainer;
      default:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  Color _getTextColor(
    BuildContext context,
    PlaybackState playbackState,
    ModelState modelState,
  ) {
    if (modelState != ModelState.installed && modelState != ModelState.ready) {
      return Theme.of(context).colorScheme.error;
    }

    switch (playbackState) {
      case PlaybackState.playing:
        return Theme.of(context).colorScheme.onPrimaryContainer;
      case PlaybackState.loading:
        return Theme.of(context).colorScheme.onSecondaryContainer;
      case PlaybackState.error:
        return Theme.of(context).colorScheme.onErrorContainer;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }
}