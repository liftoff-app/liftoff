import 'package:flutter/services.dart';

const unorderedListTypes = ['*', '+', '-'];
const orderedListTypes = [')', '.'];

extension Utilities on String {
  int getBeginningOfTheLine(int from) {
    if (from <= 0) return 0;
    for (var i = from; i >= 0; i--) {
      if (this[i] == '\n') return i + 1;
    }
    return 0;
  }

  int getEndOfTheLine(int from) {
    for (var i = from; i < length; i++) {
      if (this[i] == '\n') return i;
    }

    return length - 1;
  }

  /// returns the line that ends at endingIndex
  String lineUpTo(int characterIndex) {
    return substring(getBeginningOfTheLine(characterIndex), characterIndex + 1);
  }
}

extension on TextEditingValue {
  /// Append a string after the cursor
  TextEditingValue append(String s) {
    final beg = text.substring(0, selection.baseOffset);
    final end = text.substring(selection.baseOffset);

    return copyWith(
      text: '$beg$s$end',
      selection: selection.copyWith(
        baseOffset: selection.baseOffset + s.length,
        extentOffset: selection.extentOffset + s.length,
      ),
    );
  }

  /// cuts [characterCount] number of chars from before the cursor
  TextEditingValue trimBeforeCursor(int characterCount) {
    final beg = text.substring(0, selection.baseOffset);
    final end = text.substring(selection.baseOffset);

    return copyWith(
        text: beg.substring(0, beg.length - characterCount - 1) + end,
        selection: selection.copyWith(
          baseOffset: selection.baseOffset - characterCount,
          extentOffset: selection.extentOffset - characterCount,
        ));
  }
}

/// Provides convenience formatting in markdown text fields
class MarkdownFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length > newValue.text.length) return newValue;

    var newVal = newValue;

    final char = newValue.text[newValue.selection.baseOffset - 1];

    if (char == '\n') {
      final lineBefore =
          newValue.text.lineUpTo(newValue.selection.baseOffset - 2);

      TextEditingValue unorderedListContinuation(
          String listChar, TextEditingValue tev) {
        final regex = RegExp(r'(\s*)' '${RegExp.escape(listChar)} (.*)');
        final match = regex.matchAsPrefix(lineBefore);

        if (match == null) {
          return tev;
        }

        final listItemBody = match.group(2);
        final indent = match.group(1);

        if (listItemBody == null || listItemBody.isEmpty) {
          return tev.trimBeforeCursor(listChar.length + (indent?.length ?? 1));
        }

        return tev.append('$indent$listChar ');
      }

      TextEditingValue orderedListContinuation(
          String afterNumberChar, TextEditingValue tev) {
        final regex =
            RegExp(r'(\s*)(\d+)' '${RegExp.escape(afterNumberChar)} (.*)');
        final match = regex.matchAsPrefix(lineBefore);

        if (match == null) {
          return tev;
        }

        final listItemBody = match.group(3)!;
        final indent = match.group(1)!;
        final numberStr = match.group(2)!;

        if (listItemBody.isEmpty) {
          return tev.trimBeforeCursor(
              indent.length + numberStr.length + afterNumberChar.length + 1);
        }

        final number = (int.tryParse(match.group(2)!) ?? 0) + 1;
        return tev.append('$indent$number$afterNumberChar ');
      }

      for (final c in unorderedListTypes) {
        newVal = unorderedListContinuation(c, newVal);
      }
      for (final c in orderedListTypes) {
        newVal = orderedListContinuation(c, newVal);
      }
    }

    return newVal;
  }
}
