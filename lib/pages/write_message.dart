import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v2.dart';

import '../hooks/stores.dart';
import '../util/extensions/api.dart';
import '../widgets/markdown_mode_icon.dart';
import '../widgets/markdown_text.dart';

/// Page for writing and editing a private message
class WriteMessagePage extends HookWidget {
  final UserSafe recipient;
  final String instanceHost;

  /// if it's non null then this page is used for edit
  final PrivateMessage privateMessage;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final bool _isEdit;

  WriteMessagePage.send({
    @required this.recipient,
    @required this.instanceHost,
  })  : assert(recipient != null),
        assert(instanceHost != null),
        privateMessage = null,
        _isEdit = false;

  WriteMessagePage.edit(PrivateMessageView pmv)
      : privateMessage = pmv.privateMessage,
        recipient = pmv.recipient,
        instanceHost = pmv.instanceHost,
        _isEdit = true;

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();
    final showFancy = useState(false);
    final bodyController =
        useTextEditingController(text: privateMessage?.content);
    final loading = useState(false);

    final submit = _isEdit ? 'save' : 'send';
    final title = _isEdit ? 'Edit message' : 'Send message';

    handleSubmit() async {
      if (_isEdit) {
        loading.value = true;
        try {
          final msg = await LemmyApiV2(instanceHost).run(EditPrivateMessage(
            auth: accStore.defaultTokenFor(instanceHost)?.raw,
            privateMessageId: privateMessage.id,
            content: bodyController.text,
          ));
          Navigator.of(context).pop(msg);

          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }
        loading.value = false;
      } else {
        loading.value = true;
        try {
          await LemmyApiV2(instanceHost).run(CreatePrivateMessage(
            auth: accStore.defaultTokenFor(instanceHost)?.raw,
            content: bodyController.text,
            recipientId: recipient.id,
          ));
          Navigator.of(context).pop();
          // TODO: maybe send notification so that infinite list
          //       containing this widget adds new message?
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
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
      key: scaffoldKey,
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
            Text('to ${recipient.displayName}'),
            const SizedBox(height: 16),
            body,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: loading.value ? () {} : handleSubmit,
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
