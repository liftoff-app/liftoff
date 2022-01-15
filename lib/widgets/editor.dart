import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'markdown_text.dart';

/// A text field with added functionality for ease of editing
class Editor extends HookWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final String? labelText;
  final bool autofocus;

  /// Whether the editor should be preview the contents
  final bool fancy;
  final String instanceHost;

  const Editor({
    Key? key,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.minLines = 5,
    this.maxLines,
    this.labelText,
    this.fancy = false,
    required this.instanceHost,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultController = useTextEditingController();
    final actualController = controller ?? defaultController;

    if (fancy) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: MarkdownText(
          actualController.text,
          instanceHost: instanceHost,
        ),
      );
    }

    return TextField(
      controller: actualController,
      focusNode: focusNode,
      autofocus: autofocus,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(labelText: labelText),
    );
  }
}
