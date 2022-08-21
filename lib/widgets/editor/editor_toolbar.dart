import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logging/logging.dart';

import '../../formatter.dart';
import '../../hooks/logged_in_action.dart';
import '../../l10n/l10n.dart';
import '../../resources/links.dart';
import '../../url_launcher.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/extensions/spaced.dart';
import '../../util/files.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../util/text_lines_iterator.dart';
import 'editor_picking_dialog.dart';
import 'editor_toolbar_store.dart';

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

  String get firstSelectedLine {
    if (text.isEmpty) return '';
    return text.substring(text.getBeginningOfTheLine(selection.start - 1),
        text.getEndOfTheLine(selection.end));
  }

  void insertAtBeginningOfFirstSelectedLine(String s) {
    final lines = TextLinesIterator.fromController(this)..moveNext();
    lines.current = s + lines.current;
    value = value.copyWith(
      text: lines.text,
      selection: selection.copyWith(
        baseOffset: selection.baseOffset + s.length,
        extentOffset: selection.extentOffset + s.length,
      ),
    );
  }

  void removeAtBeginningOfEverySelectedLine(String s) {
    final lines = TextLinesIterator.fromController(this);
    var linesCount = 0;
    while (lines.moveNext()) {
      if (lines.isWithinSelection) {
        if (lines.current.startsWith(RegExp.escape(s))) {
          lines.current = lines.current.substring(s.length);
          linesCount++;
        }
      }
    }

    value = value.copyWith(
      text: lines.text,
      selection: selection.copyWith(
        baseOffset: selection.baseOffset - s.length,
        extentOffset: selection.extentOffset - s.length * linesCount,
      ),
    );
  }

  void insertAtBeginningOfEverySelectedLine(String s) {
    final lines = TextLinesIterator.fromController(this);
    var linesCount = 0;
    while (lines.moveNext()) {
      if (lines.isWithinSelection) {
        if (!lines.current.startsWith(RegExp.escape(s))) {
          lines.current = '$s${lines.current}';
          linesCount++;
        }
      }
    }

    value = value.copyWith(
      text: lines.text,
      selection: selection.copyWith(
        baseOffset: selection.baseOffset + s.length,
        extentOffset: selection.extentOffset + s.length * linesCount,
      ),
    );
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

  void reformatSimple(String text) =>
      reformat((selection) => Reformat(text: text));
}

enum HeaderLevel {
  h1(1),
  h2(2),
  h3(3),
  h4(4),
  h5(5),
  h6(6);

  const HeaderLevel(this.value);
  final int value;
}

class Toolbar extends HookWidget {
  final TextEditingController controller;
  final String instanceHost;
  final EditorToolbarStore store;
  static const _height = 50.0;

  Toolbar({
    required this.controller,
    required this.instanceHost,
  }) : store = EditorToolbarStore(instanceHost);

  @override
  Widget build(BuildContext context) {
    return MobxProvider.value(
      value: store,
      child: AsyncStoreListener(
        asyncStore: store.imageUploadState,
        child: Container(
          height: _height,
          width: double.infinity,
          color: Theme.of(context).cardColor,
          child: Material(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _ToolbarBody(
                controller: controller,
                instanceHost: instanceHost,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget safeArea = const SizedBox(height: _height);
}

class _ToolbarBody extends HookWidget {
  const _ToolbarBody({
    required this.controller,
    required this.instanceHost,
  });

  final TextEditingController controller;
  final String instanceHost;

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(instanceHost);
    return Row(
      children: [
        IconButton(
          onPressed: () => controller.surround('**'),
          icon: const Icon(Icons.format_bold),
          tooltip: L10n.of(context).editor_bold,
        ),
        IconButton(
          onPressed: () => controller.surround('*'),
          icon: const Icon(Icons.format_italic),
          tooltip: L10n.of(context).editor_italics,
        ),
        IconButton(
          onPressed: () async {
            final r =
                await AddLinkDialog.show(context, controller.selectionText);
            if (r != null) controller.reformat((_) => r);
          },
          icon: const Icon(Icons.link),
          tooltip: L10n.of(context).editor_link,
        ),
        // Insert image
        ObserverBuilder<EditorToolbarStore>(
          builder: (context, store) {
            return IconButton(
              onPressed: loggedInAction((token) async {
                if (store.imageUploadState.isLoading) {
                  return;
                }
                try {
                  // FIXME: for some reason it doesn't go past this line on iOS. idk why
                  final pic = await pickImage();
                  // pic is null when the picker was cancelled

                  if (pic != null) {
                    final picUrl = await context
                        .read<EditorToolbarStore>()
                        .uploadImage(pic.path, token);

                    if (picUrl != null) {
                      controller.reformatSimple('![]($picUrl)');
                    }
                  }
                } on Exception catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to upload image')));
                }
              }),
              icon: store.imageUploadState.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Icon(Icons.image),
              tooltip: L10n.of(context).editor_image,
            );
          },
        ),
        IconButton(
          onPressed: () async {
            final person = await PickPersonDialog.show(context);

            if (person != null) {
              final name =
                  '@${person.person.name}@${person.person.originInstanceHost}';
              final link = person.person.actorId;

              controller.reformatSimple('[$name]($link)');
            }
          },
          icon: const Icon(Icons.person),
          tooltip: L10n.of(context).editor_user,
        ),
        IconButton(
          onPressed: () async {
            final community = await PickCommunityDialog.show(context);
            if (community != null) {
              final name =
                  '!${community.community.name}@${community.community.originInstanceHost}';
              final link = community.community.actorId;

              controller.reformatSimple('[$name]($link)');
            }
          },
          icon: const Icon(Icons.home),
          tooltip: L10n.of(context).editor_community,
        ),
        PopupMenuButton<HeaderLevel>(
          itemBuilder: (context) => [
            for (final h in HeaderLevel.values)
              PopupMenuItem(
                value: h,
                child: Text(describeEnum(h).toUpperCase()),
              ),
          ],
          onSelected: (val) {
            final header = '${'#' * val.value} ';

            if (!controller.firstSelectedLine.startsWith(header)) {
              controller.insertAtBeginningOfFirstSelectedLine(header);
            }
          },
          tooltip: L10n.of(context).editor_header,
          child: const Icon(Icons.h_mobiledata),
        ),
        IconButton(
          onPressed: () => controller.surround('~~'),
          icon: const Icon(Icons.format_strikethrough),
          tooltip: L10n.of(context).editor_strikethrough,
        ),
        IconButton(
          onPressed: () {
            controller.insertAtBeginningOfEverySelectedLine('> ');
          },
          icon: const Icon(Icons.format_quote),
          tooltip: L10n.of(context).editor_quote,
        ),
        IconButton(
          onPressed: () {
            final line = controller.firstSelectedLine;

            if (line.startsWith(RegExp.escape('* '))) {
              controller.removeAtBeginningOfEverySelectedLine('* ');
            } else if (line.startsWith('- ')) {
              controller.removeAtBeginningOfEverySelectedLine('- ');
            } else {
              controller.insertAtBeginningOfEverySelectedLine('- ');
            }
          },
          icon: const Icon(Icons.format_list_bulleted),
          tooltip: L10n.of(context).editor_list,
        ),
        IconButton(
          onPressed: () => controller.surround('`'),
          icon: const Icon(Icons.code),
          tooltip: L10n.of(context).editor_code,
        ),
        IconButton(
          onPressed: () => controller.surround('~'),
          icon: const Icon(Icons.subscript),
          tooltip: L10n.of(context).editor_subscript,
        ),
        IconButton(
          onPressed: () => controller.surround('^'),
          icon: const Icon(Icons.superscript),
          tooltip: L10n.of(context).editor_superscript,
        ),
        //spoiler
        IconButton(
          onPressed: () {
            controller.reformat((selection) {
              final insides = selection.isNotEmpty ? selection : '___';
              Logger.root
                  .info([21, 21 + insides.length, insides, insides.length]);
              return Reformat(
                text: '\n::: spoiler spoiler\n$insides\n:::\n',
                selectionBeginningShift: 21,
                selectionEndingShift: 21 + insides.length - selection.length,
              );
            });
          },
          icon: const Icon(Icons.warning),
          tooltip: L10n.of(context).editor_spoiler,
        ),
        IconButton(
          onPressed: () {
            launchLink(link: markdownGuide, context: context);
          },
          icon: const Icon(Icons.question_mark),
          tooltip: L10n.of(context).editor_help,
        ),
      ],
    );
  }
}

class AddLinkDialog extends HookWidget {
  final String title;
  final String url;
  final String selection;

  static final _websiteRegex = RegExp(r'https?:\/\/', caseSensitive: false);

  AddLinkDialog(this.selection)
      : title = selection.startsWith(_websiteRegex) ? '' : selection,
        url = selection.startsWith(_websiteRegex) ? selection : '';

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: title);
    final urlController = useTextEditingController(text: url);

    void submit() {
      final link = () {
        if (urlController.text.startsWith('http?s://')) {
          return urlController.text;
        } else {
          return 'https://${urlController.text}';
        }
      }();
      final finalString = '(${titleController.text})[$link]';
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
