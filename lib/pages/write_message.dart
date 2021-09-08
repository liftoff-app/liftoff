import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/logged_in_action.dart';
import '../l10n/l10n.dart';
import '../util/extensions/api.dart';
import '../widgets/markdown_mode_icon.dart';
import '../widgets/markdown_text.dart';

/// Page for writing and editing a private message
class WriteMessagePage extends HookWidget {
  final PersonSafe recipient;
  final String instanceHost;

  /// if it's non null then this page is used for edit
  final PrivateMessage? privateMessage;

  final bool _isEdit;

  const WriteMessagePage.send({
    required this.recipient,
    required this.instanceHost,
  })  : privateMessage = null,
        _isEdit = false;

  WriteMessagePage.edit(PrivateMessageView pmv)
      : privateMessage = pmv.privateMessage,
        recipient = pmv.recipient,
        instanceHost = pmv.instanceHost,
        _isEdit = true;

  @override
  Widget build(BuildContext context) {
    final showFancy = useState(false);
    final bodyController =
        useTextEditingController(text: privateMessage?.content);
    final loading = useState(false);
    final loggedInAction = useLoggedInAction(instanceHost);
    final submit = _isEdit ? L10n.of(context)!.save : 'send';
    final title = _isEdit ? 'Edit message' : L10n.of(context)!.send_message;

    handleSubmit(Jwt token) async {
      if (_isEdit) {
        loading.value = true;
        try {
          final msg = await LemmyApiV3(instanceHost).run(EditPrivateMessage(
            auth: token.raw,
            privateMessageId: privateMessage!.id,
            content: bodyController.text,
          ));
          Navigator.of(context).pop(msg);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }
        loading.value = false;
      } else {
        loading.value = true;
        try {
          await LemmyApiV3(instanceHost).run(CreatePrivateMessage(
            auth: token.raw,
            content: bodyController.text,
            recipientId: recipient.id,
          ));
          Navigator.of(context).pop();
          // TODO: maybe send notification so that infinite list
          //       containing this widget adds new message?
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        } finally {
          loading.value = false;
        }
      }
    }

    final body = IndexedStack(
      index: showFancy.value ? 1 : 0,
      children: [
        TextField(
          controller: bodyController,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          minLines: 5,
          autofocus: true,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: MarkdownText(
            bodyController.text,
            instanceHost: instanceHost,
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: const CloseButton(),
        actions: [
          IconButton(
            icon: markdownModeIcon(fancy: showFancy.value),
            onPressed: () => showFancy.value = !showFancy.value,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text('to ${recipient.preferredName}'),
            const SizedBox(height: 16),
            body,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: loading.value ? () {} : loggedInAction(handleSubmit),
                child: loading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())
                    : Text(submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
