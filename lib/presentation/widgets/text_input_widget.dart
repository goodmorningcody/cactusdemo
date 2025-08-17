import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../providers/tts_providers.dart';

class TextInputWidget extends ConsumerStatefulWidget {
  const TextInputWidget({super.key});

  @override
  ConsumerState<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends ConsumerState<TextInputWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    
    // Sync with provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.text = ref.read(ttsTextProvider);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    ref.read(ttsTextProvider.notifier).state = text;
  }

  void _clearText() {
    _controller.clear();
    ref.read(ttsTextProvider.notifier).state = '';
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final characterCount = ref.watch(characterCountProvider);
    final text = ref.watch(ttsTextProvider);
    final isOverLimit = text.length > AppConstants.maxTextLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: 5,
          minLines: 3,
          maxLength: AppConstants.maxTextLength,
          onChanged: _onTextChanged,
          inputFormatters: [
            LengthLimitingTextInputFormatter(AppConstants.maxTextLength),
          ],
          decoration: InputDecoration(
            hintText: AppConstants.textInputHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
            counterText: '',
            suffixIcon: text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearText,
                    tooltip: '텍스트 지우기',
                  )
                : null,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (text.isNotEmpty)
              Text(
                '${text.split(' ').where((word) => word.isNotEmpty).length}개 단어',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              )
            else
              const SizedBox.shrink(),
            Text(
              characterCount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isOverLimit
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isOverLimit ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
        if (isOverLimit)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '최대 ${AppConstants.maxTextLength}자까지 입력 가능합니다',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}