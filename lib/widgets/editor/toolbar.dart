import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../util/extensions/spaced.dart';

class Reformat {
  final String text;
  final int selectionBeginningShift;
  final int selectionEndingShift;
  Reformat({
    required this.text,
    this.selectionBeginningShift = 0,
    this.selectionEndingShift = 0,
  });
}

extension on TextEditingController {
  String get selectionText =>
      text.substring(selection.baseOffset, selection.extentOffset);
  String get beforeSelectionText => text.substring(0, selection.baseOffset);
  String get afterSelectionText => text.substring(selection.extentOffset);

  /// surroungs selection with given strings. If nothing is selected, placeholder is used in the middle
  void surround(
    String before, [
    String? after,
    String placeholder = '[write text here]',
  ]) {
    after ??= before;
    final beg = text.substring(0, selection.baseOffset);
    final mid = () {
      final m = text.substring(selection.baseOffset, selection.extentOffset);
      if (m.isEmpty) return placeholder;
      return m;
    }();
    final end = text.substring(selection.extentOffset);

    value = value.copyWith(
        text: '$beg$before$mid$after$end',
        selection: selection.copyWith(
          baseOffset: selection.baseOffset + before.length,
          extentOffset: selection.baseOffset + before.length + mid.length,
        ));
  }

  void reformat(Reformat Function(String selection) reformatter) {
    final beg = beforeSelectionText;
    final mid = selectionText;
    final end = afterSelectionText;

    final r = reformatter(mid);
    value = value.copyWith(
      text: '$beg${r.text}$end',
      selection: selection.copyWith(
        baseOffset: selection.baseOffset + r.selectionBeginningShift,
        extentOffset: selection.extentOffset + r.selectionEndingShift,
      ),
    );
  }
}

class Toolbar extends HookWidget {
  final TextEditingController controller;

  const Toolbar(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Theme.of(context).cardColor,
      child: Material(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                onPressed: () => controller.surround('**'),
                icon: const Icon(Icons.format_bold),
              ),
              IconButton(
                onPressed: () => controller.surround('*'),
                icon: const Icon(Icons.format_italic),
              ),
              IconButton(
                onPressed: () async {
                  final r = await AddLinkDialog.show(
                      context, controller.selectionText);
                  if (r != null) controller.reformat((_) => r);
                },
                icon: const Icon(Icons.link),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.image),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person),
              ),
              IconButton(
                onPressed: () {
                  //
                },
                icon: const Icon(Icons.home),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.h_mobiledata),
              ),
              IconButton(
                onPressed: () => controller.surround('~~'),
                icon: const Icon(Icons.format_strikethrough),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.format_quote),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.format_list_bulleted)),
              IconButton(
                onPressed: () => controller.surround('`'),
                icon: const Icon(Icons.code),
              ),
              IconButton(
                onPressed: () => controller.surround('~'),
                icon: const Icon(Icons.subscript),
              ),
              IconButton(
                onPressed: () => controller.surround('^'),
                icon: const Icon(Icons.superscript),
              ),
              //spoiler
              IconButton(onPressed: () {}, icon: const Icon(Icons.warning)),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.question_mark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddLinkDialog extends HookWidget {
  final String title;
  final String url;
  final String selection;

  AddLinkDialog(this.selection)
      : title = selection.startsWith('http?s://') ? '' : selection,
        url = selection.startsWith('http?s://') ? selection : '';

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: title);
    final urlController = useTextEditingController(text: url);

    void submit() {
      final finalString = '(${titleController.text})[${urlController.text}]';
      Navigator.of(context).pop(Reformat(
        text: finalString,
        selectionBeginningShift: finalString.length,
        selectionEndingShift: finalString.length - selection.length,
      ));
    }

    return AlertDialog(
      title: const Text('Add link'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'title'),
            textInputAction: TextInputAction.next,
            autofocus: true,
          ),
          TextField(
            controller: urlController,
            decoration: const InputDecoration(hintText: 'https://example.com'),
            onEditingComplete: submit,
            autocorrect: false,
          ),
        ].spaced(10),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: submit,
          child: const Text('Add link'),
        )
      ],
    );
  }

  static Future<Reformat?> show(BuildContext context, String selection) async {
    return showDialog(
      context: context,
      builder: (context) => AddLinkDialog(selection),
    );
  }
}
