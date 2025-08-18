import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/model_status.dart';
import '../../../routes/app_router.dart';
import '../../providers/model_providers.dart';
import '../../widgets/text_input_widget.dart';
import '../../widgets/playback_control_widget.dart';
import '../../widgets/status_message_widget.dart';

class TTSDemoScreen extends ConsumerWidget {
  const TTSDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.modelManagement);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text Input Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(AppConstants.padding),
                  child: TextInputWidget(),
                ),
              ),
              const SizedBox(height: 32),
              
              // Playback Control Section
              Center(
                child: Column(
                  children: [
                    const PlaybackControlWidget(),
                    const SizedBox(height: 16),
                    const StatusMessageWidget(),
                    const SizedBox(height: 32),
                    
                    // Model Status Info
                    Consumer(
                      builder: (context, ref, child) {
                        final defaultModel = ref.watch(defaultModelProvider);
                        
                        return defaultModel.when(
                          data: (model) {
                            final modelStatus = ref.watch(
                              modelStatusProvider(model.id),
                            );
                            
                            return modelStatus.when(
                              data: (status) {
                                if (status.state != ModelState.installed &&
                                    status.state != ModelState.ready) {
                                  return Card(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onErrorContainer,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '모델을 먼저 다운로드하세요',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onErrorContainer,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) => const SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Info Section
              const SizedBox(height: 48),
              Card(
                elevation: 1,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '정보',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• 모델: ${AppConstants.modelName}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '• 프레임워크: ${AppConstants.framework}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '• 지원 언어: 한국어, 영어, 일본어, 중국어',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}