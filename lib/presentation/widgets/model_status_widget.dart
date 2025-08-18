import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/model_status.dart';
import '../../data/models/tts_model.dart';
import '../providers/model_providers.dart';
class ModelStatusWidget extends ConsumerWidget {
  final TTSModel model;

  const ModelStatusWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelStatus = ref.watch(modelStatusProvider(model.id));

    return modelStatus.when(
      data: (status) => _buildStatusCard(context, ref, status),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorCard(context, error),
    );
  }

  Widget _buildStatusCard(BuildContext context, WidgetRef ref, ModelStatus status) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [
            _buildStatusHeader(context, status),
            const SizedBox(height: 16),
            _buildStatusContent(context, ref, status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, ModelStatus status) {
    IconData icon;
    Color iconColor;
    String title;

    switch (status.state) {
      case ModelState.notInstalled:
        icon = Icons.cloud_download;
        iconColor = Theme.of(context).colorScheme.primary;
        title = '모델이 설치되지 않았습니다';
        break;
      case ModelState.downloading:
        icon = Icons.downloading;
        iconColor = Theme.of(context).colorScheme.secondary;
        title = '모델 다운로드 중';
        break;
      case ModelState.installed:
      case ModelState.ready:
        icon = Icons.check_circle;
        iconColor = Colors.green;
        title = '모델이 설치되었습니다';
        break;
      case ModelState.loading:
        icon = Icons.hourglass_bottom;
        iconColor = Theme.of(context).colorScheme.tertiary;
        title = '모델 로딩 중';
        break;
      case ModelState.error:
        icon = Icons.error_outline;
        iconColor = Theme.of(context).colorScheme.error;
        title = '오류 발생';
        break;
    }

    return Row(
      children: [
        Icon(icon, size: 32, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (status.installedAt != null)
                Text(
                  '설치일: ${DateFormat('yyyy년 MM월 dd일').format(status.installedAt!)}',
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

  Widget _buildStatusContent(BuildContext context, WidgetRef ref, ModelStatus status) {
    switch (status.state) {
      case ModelState.notInstalled:
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '모델이 앱에 포함되어 있습니다.\n초기화를 진행해주세요.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        
      case ModelState.downloading:
        return Column(
          children: [
            const SizedBox(height: 8),
            const Text('모델을 초기화하는 중입니다...'),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        );
        
      case ModelState.installed:
      case ModelState.ready:
        return Column(
          children: [
            if (status.modelPath != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '저장 위치: ${status.modelPath!.split('/').last}',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '모델이 앱에 포함되어 있습니다',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        
      case ModelState.error:
        return Column(
          children: [
            if (status.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _retry(ref),
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        );
        
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildErrorCard(BuildContext context, Object error) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(height: 8),
            Text(
              '상태를 불러올 수 없습니다',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              error.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _retry(WidgetRef ref) {
    ref.read(modelStatusProvider(model.id).notifier).refresh();
  }

}