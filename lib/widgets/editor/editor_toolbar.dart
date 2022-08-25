import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../hooks/logged_in_action.dart';
import '../../l10n/l10n.dart';
import '../../markdown_formatter.dart';
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

class _Reformat {
  final String text;
  final int selectionBeginningShift;
  final int selectionEndingShift;
  _Reformat({
    required this.text,
    this.selectionBeginningShift = 0,
    this.selectionEndingShift = 0,
  });
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

class EditorToolbar extends HookWidget {
  final TextEditingController controller;
  final String instanceHost;
  final FocusNode editorFocusNode;
  static const _height = 50.0;

  const EditorToolbar({
    required this.controller,
    required this.instanceHost,
    required this.editorFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final visible = useListenable(editorFocusNode).hasFocus;

    return MobxProvider(
      create: (context) => EditorToolbarStore(instanceHost),
      child: Builder(builder: (context) {
        return AsyncStoreListener(
          asyncStore: context.read<EditorToolbarStore>().imageUploadState,
          child: AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            transitionBuilder: (child, animation) {
              final offsetAnimation =
                  Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero)
                      .animate(animation);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            child: visible
                ? Material(
                    color: Theme.of(context).canvasColor,
                    child: SizedBox(
                      height: _height,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _ToolbarBody(
                          controller: controller,
                          instanceHost: instanceHost,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      }),
    );
  }

  static const safeArea = SizedBox(height: _height);
}

class BottomSticky extends StatelessWidget {
  final Widget child;
  const BottomSticky({required this.child});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            child,
          ],
        ),
      );
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
          onPressed: () => controller.surround(
              before: '**',
              placeholder: L10n.of(context).insert_text_here_placeholder),
          icon: const Icon(Icons.format_bold),
          tooltip: L10n.of(context).editor_bold,
        ),
        IconButton(
          onPressed: () => controller.surround(
              before: '*',
              placeholder: L10n.of(context).insert_text_here_placeholder),
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
                  final pic = await pickImage();
                  // pic is null when the picker was cancelled

                  if (pic != null) {
                    final picUrl = await store.uploadImage(pic.path, token);

                    if (picUrl != null) {
                      controller.reformatSimple('![]($picUrl)');
                    }
                  }
                } on Exception catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(L10n.of(context).failed_to_upload_image)));
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
                child: Text(h.name.toUpperCase()),
                onTap: () {
                  final header = '${'#' * h.value} ';

                  if (!controller.firstSelectedLine.startsWith(header)) {
                    controller.insertAtBeginningOfFirstSelectedLine(header);
                  }
                },
              ),
          ],
          tooltip: L10n.of(context).editor_header,
          child: const Icon(Icons.h_mobiledata),
        ),
        IconButton(
          onPressed: () => controller.surround(
            before: '~~',
            placeholder: L10n.of(context).insert_text_here_placeholder,
          ),
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

            // if theres a list in place, remove it
            final listRemoved = () {
              for (final c in unorderedListTypes) {
                if (line.startsWith('$c ')) {
                  controller.removeAtBeginningOfEverySelectedLine('$c ');
                  return true;
                }
              }
              return false;
            }();

            // if no list, then let's add one
            if (!listRemoved) {
              controller.insertAtBeginningOfEverySelectedLine(
                  '${unorderedListTypes.last} ');
            }
          },
          icon: const Icon(Icons.format_list_bulleted),
          tooltip: L10n.of(context).editor_list,
        ),
        IconButton(
          onPressed: () => controller.surround(
            before: '`',
            placeholder: L10n.of(context).insert_text_here_placeholder,
          ),
          icon: const Icon(Icons.code),
          tooltip: L10n.of(context).editor_code,
        ),
        IconButton(
          onPressed: () => controller.surround(
            before: '~',
            placeholder: L10n.of(context).insert_text_here_placeholder,
          ),
          icon: const Icon(Icons.subscript),
          tooltip: L10n.of(context).editor_subscript,
        ),
        IconButton(
          onPressed: () => controller.surround(
            before: '^',
            placeholder: L10n.of(context).insert_text_here_placeholder,
          ),
          icon: const Icon(Icons.superscript),
          tooltip: L10n.of(context).editor_superscript,
        ),
        //spoiler
        IconButton(
          onPressed: () {
            controller.reformat((selection) {
              const textBeg = '\n::: spoiler spoiler\n';
              final textMid = selection.isNotEmpty ? selection : '___';
              const textEnd = '\n:::\n';

              return _Reformat(
                text: textBeg + textMid + textEnd,
                selectionBeginningShift: textBeg.length,
                selectionEndingShift:
                    textBeg.length + textMid.length - selection.length,
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
  final String label;
  final String url;
  final String selection;

  static final _websiteRegex = RegExp(r'https?:\/\/', caseSensitive: false);

  AddLinkDialog(this.selection)
      : label = selection.startsWith(_websiteRegex) ? '' : selection,
        url = selection.startsWith(_websiteRegex) ? selection : '';

  @override
  Widget build(BuildContext context) {
    final labelController = useTextEditingController(text: label);
    final urlController = useTextEditingController(text: url);

    void submit() {
      final link = () {
        if (urlController.text.startsWith(RegExp('https?://'))) {
          return urlController.text;
        } else {
          return 'https://${urlController.text}';
        }
      }();
      final finalString = '[${labelController.text}]($link)';
      Navigator.of(context).pop(_Reformat(
        text: finalString,
        selectionBeginningShift: finalString.length,
        selectionEndingShift: finalString.length - selection.length,
      ));
    }

    return AlertDialog(
      title: Text(L10n.of(context).add_link),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: labelController,
            decoration: InputDecoration(
                hintText: L10n.of(context).editor_add_link_label),
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
            child: Text(L10n.of(context).cancel)),
        ElevatedButton(
          onPressed: submit,
          child: Text(L10n.of(context).add_link),
        )
      ],
    );
  }

  static Future<_Reformat?> show(BuildContext context, String selection) async {
    return showDialog(
      context: context,
      builder: (context) => AddLinkDialog(selection),
    );
  }
}

extension on TextEditingController {
  String get selectionText =>
      text.substring(selection.baseOffset, selection.extentOffset);
  String get beforeSelectionText => text.substring(0, selection.baseOffset);
  String get afterSelectionText => text.substring(selection.extentOffset);

  /// surrounds selection with given strings. If nothing is selected, placeholder is used in the middle
  void surround({
    required String before,
    required String placeholder,

    /// after = before if null
    String? after,
  }) {
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
    if (text.isEmpty) {
      return '';
    }
    final val = text.substring(text.getBeginningOfTheLine(selection.start - 1),
        text.getEndOfTheLine(selection.end) - 1);
    return val;
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
        if (lines.current.startsWith(s)) {
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
        if (!lines.current.startsWith(s)) {
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

  void reformat(_Reformat Function(String selection) reformatter) {
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
      reformat((selection) => _Reformat(text: text));
}
