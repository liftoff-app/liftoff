import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension on TextEditingController {
  /// surroungs selection with given strings. If nothing is selected, placeholder is used in the middle
  void surround(String before, String after,
      [String placeholder = '[write text here]']) {
    final beg = text.substring(0, selection.baseOffset);
    final mid = text.substring(selection.baseOffset, selection.extentOffset);
    final end = text.substring(selection.extentOffset);

    if (mid.isEmpty) {
      value = value.copyWith(
        text: '$beg$before$placeholder$after$end',
        selection: selection.copyWith(
          baseOffset: selection.baseOffset + before.length,
          extentOffset:
              selection.baseOffset + before.length + placeholder.length,
        ),
      );
    } else {
      value = value.copyWith(
          text: '$beg$before$mid$after$end',
          selection: selection.copyWith(
            baseOffset: selection.baseOffset + before.length,
            extentOffset: selection.extentOffset + before.length,
          ));
    }
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
                  onPressed: () {
                    controller.surround('**', '**');
                  },
                  icon: const Icon(Icons.format_bold)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.format_italic)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.link)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.image)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.h_mobiledata)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.format_strikethrough)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.format_quote)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.format_list_bulleted)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.code)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.subscript)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.superscript)),
              // IconButton(onPressed: () {}, icon: const Icon(Icons.warning)),//spoiler
              IconButton(onPressed: () {}, icon: const Icon(Icons.superscript)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.question_mark)),
            ],
          ),
        ),
      ),
    );
  }
}
