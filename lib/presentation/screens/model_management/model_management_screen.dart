import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/model_providers.dart';
import '../../widgets/model_info_widget.dart';
import '../../widgets/model_status_widget.dart';
import '../../widgets/download_progress_widget.dart';

class ModelManagementScreen extends ConsumerWidget {
  const ModelManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultModel = ref.watch(defaultModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TTS 모델 관리'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: defaultModel.when(
        data: (model) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Model Info Section
                ModelInfoWidget(model: model),
                const SizedBox(height: 24),
                
                // Model Status Section
                ModelStatusWidget(model: model),
                const SizedBox(height: 24),
                
                // Download Progress (if downloading)
                Consumer(
                  builder: (context, ref, child) {
                    final downloadProgress = ref.watch(downloadProgressProvider);
                    
                    if (downloadProgress != null &&
                        downloadProgress.modelId == model.id) {
                      return Column(
                        children: [
                          DownloadProgressWidget(progress: downloadProgress),
                          const SizedBox(height: 24),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                // Additional Info
                _buildAdditionalInfo(context),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                '모델 정보를 불러올 수 없습니다',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(defaultModelProvider);
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return Card(
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
                  Icons.help_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '도움말',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              context,
              Icons.download,
              '모델 다운로드',
              '처음 사용 시 TTS 모델을 다운로드해야 합니다. WiFi 연결을 권장합니다.',
            ),
            const SizedBox(height: 8),
            _buildHelpItem(
              context,
              Icons.storage,
              '저장 공간',
              '모델 파일은 약 2GB의 저장 공간이 필요합니다.',
            ),
            const SizedBox(height: 8),
            _buildHelpItem(
              context,
              Icons.offline_bolt,
              '오프라인 사용',
              '모델이 설치되면 인터넷 연결 없이도 TTS를 사용할 수 있습니다.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}