import 'package:flutter/services.dart';

extension on String {
  int getBeginningOfPreviousLine(int startingIndex) {
    for (var i = startingIndex; i >= 0; i--) {
      if (this[i] == '\n') return i + 1;
    }
    return 0;
  }

  // returns the line that ends at endingIndex
  String lineBefore(int endingIndex) {
    return substring(getBeginningOfPreviousLine(endingIndex), endingIndex + 1);
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

    final char = newValue.text[newValue.selection.baseOffset - 1];
    if (char == '\n') {
      final lineBefore =
          newValue.text.lineBefore(newValue.selection.baseOffset - 2);
      if (lineBefore.startsWith('- ')) {
        return newValue.append('- ');
      }
      if (lineBefore.startsWith('* ')) {
        return newValue.append('* ');
      }
    }

    return newValue;
  }
}
