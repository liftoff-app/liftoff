import 'package:flutter/widgets.dart';

/// utililty class for traversing through multiline text
class TextLinesIterator extends Iterator {
  String text;
  int beg;
  int end;
  TextSelection? selection;

  TextLinesIterator(this.text, {this.selection})
      : end = -1,
        beg = -1;

  TextLinesIterator.fromController(TextEditingController controller)
      : this(controller.text, selection: controller.selection);

  bool get isWithinSelection {
    final selection = this.selection;
    if (selection == null || beg == -1) {
      return false;
    } else {
      return (selection.end >= beg && beg >= selection.start) ||
          (selection.end >= end && end >= selection.start) ||
          (end >= selection.start && selection.start >= beg) ||
          (end >= selection.end && selection.end >= beg) ||
          (beg <= selection.start &&
              selection.start <= end &&
              beg <= selection.end &&
              selection.end <= end);
    }
  }

  @override
  String get current {
    return text.substring(beg, end);
  }

  set current(String newVal) {
    final selected = isWithinSelection;
    text = text.replaceRange(beg, end, newVal);
    final wordLen = end - beg;
    final dif = newVal.length - wordLen;
    end += dif;

    final selection = this.selection;
    if (selection == null) return;

    if (selected || selection.baseOffset > end) {
      this.selection =
          selection.copyWith(extentOffset: selection.extentOffset + dif);
    }
  }

  void reset() {
    end = -1;
    beg = -1;
  }

  @override
  bool moveNext() {
    if (end == text.length) {
      return false;
    }
    if (beg == -1) {
      end = 0;
      beg = 0;
    } else {
      end += 1;
      beg = end;
    }
    for (; end < text.length; end++) {
      if (text[end] == '\n') {
        return true;
      }
    }
    end = text.length;
    return true;
  }

  /// returns the lines as a list but also moves the pointer to the back
  List<String> get asList {
    reset();
    final list = <String>[];
    while (moveNext()) {
      list.add(current);
    }
    return list;
  }
}
