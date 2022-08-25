import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../markdown_formatter.dart';
import '../markdown_text.dart';

export 'editor_toolbar.dart';

class EditorController {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String instanceHost;

  EditorController({
    required this.textEditingController,
    required this.focusNode,
    required this.instanceHost,
  });
}

EditorController useEditorController({
  required String instanceHost,
  String? text,
}) {
  final focusNode = useFocusNode();
  final textEditingController = useTextEditingController(text: text);
  return EditorController(
      textEditingController: textEditingController,
      focusNode: focusNode,
      instanceHost: instanceHost);
}

/// A text field with added functionality for ease of editing
class Editor extends HookWidget {
  final EditorController controller;

  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final String? labelText;
  final String? initialValue;
  final bool autofocus;

  /// Whether the editor should be preview the contents
  final bool fancy;

  const Editor({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.minLines = 5,
    this.maxLines,
    this.labelText,
    this.initialValue,
    this.fancy = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (fancy) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: MarkdownText(
          controller.textEditingController.text,
          instanceHost: controller.instanceHost,
        ),
      );
    }

    return TextField(
      focusNode: controller.focusNode,
      controller: controller.textEditingController,
      autofocus: autofocus,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(labelText: labelText),
      inputFormatters: [MarkdownFormatter()],
    );
  }
}
