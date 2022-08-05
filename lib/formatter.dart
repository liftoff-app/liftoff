import 'package:flutter/services.dart';

extension Utilities on String {
  int getBeginningOfTheLine(int startingIndex) {
    if (startingIndex <= 0) return 0;
    for (var i = startingIndex; i >= 0; i--) {
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

  // returns the line that ends at endingIndex
  String lineBefore(int endingIndex) {
    return substring(getBeginningOfTheLine(endingIndex), endingIndex + 1);
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
}

/// Provides convinience formatting in markdown text fields
class MarkdownFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length > newValue.text.length) return newValue;

    var newVal = newValue;

    final char = newValue.text[newValue.selection.baseOffset - 1];

    if (char == '\n') {
      final lineBefore =
          newValue.text.lineBefore(newValue.selection.baseOffset - 2);

      TextEditingValue listContinuation(String listChar, TextEditingValue tev) {
        final regex = RegExp(r'(\s*)' '${RegExp.escape(listChar)} ');
        final match = regex.matchAsPrefix(lineBefore);
        if (match == null) {
          return tev;
        }
        final indent = match.group(1);

        return tev.append('$indent$listChar ');
      }

      TextEditingValue numberedListContinuation(
          String afterNumberChar, TextEditingValue tev) {
        final regex =
            RegExp(r'(\s*)(\d+)' '${RegExp.escape(afterNumberChar)} ');
        final match = regex.matchAsPrefix(lineBefore);
        if (match == null) {
          return tev;
        }
        final indent = match.group(1);
        final number = int.parse(match.group(2)!) + 1;

        return tev.append('$indent$number$afterNumberChar ');
      }

      newVal = listContinuation('-', newVal);
      newVal = listContinuation('*', newVal);
      newVal = numberedListContinuation('.', newVal);
      newVal = numberedListContinuation(')', newVal);
    }

    return newVal;
  }
}
