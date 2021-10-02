import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';

import '../../../hooks/stores.dart';
import '../../../util/extensions/api.dart';
import '../../../util/goto.dart';
import '../../../widgets/avatar.dart';
import 'blocks_store.dart';

class BlockPersonTile extends HookWidget {
  final PersonSafe person;
  const BlockPersonTile(this.person, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final token = useAccountsStoreSelect(
        (store) => store.defaultUserDataFor(person.instanceHost)!.jwt);

    void showSnackBar(String e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
    }

    final pending = useState(false);

    unblock() async {
      if (pending.value) return;
      pending.value = true;
      try {
        await LemmyApiV3(person.instanceHost).run(
            BlockPerson(auth: token.raw, block: false, personId: person.id));
        context.read<BlocksStore>().userUnblocked(person.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${person.preferredName} unblocked'),
          ),
        );
      } on SocketException {
        showSnackBar('Network error');
      } on LemmyApiException catch (e) {
        showSnackBar(e.message);
      } catch (e) {
        showSnackBar(e.toString());
      } finally {
        pending.value = false;
      }
    }

    return ListTile(
      leading: Avatar(url: person.avatar),
      title: Text(person.originPreferredName),
      trailing: IconButton(
        icon: pending.value
            ? const CircularProgressIndicator.adaptive()
            : const Icon(Icons.cancel),
        tooltip: 'unblock',
        onPressed: unblock,
      ),
      onTap: () {
        goToUser.byId(context, person.instanceHost, person.id);
      },
    );
  }
}

class BlockCommunityTile extends HookWidget {
  final CommunitySafe community;

  const BlockCommunityTile(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = useAccountsStoreSelect(
        (store) => store.defaultUserDataFor(community.instanceHost)!.jwt);

    void showSnackBar(String e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
    }

    final pending = useState(false);

    unblock() async {
      if (pending.value) return;
      pending.value = true;
      try {
        await LemmyApiV3(community.instanceHost).run(BlockCommunity(
            auth: token.raw, block: false, communityId: community.id));
        context.read<BlocksStore>().communityUnblocked(community.id);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Community unblocked'),
        ));
      } on SocketException {
        showSnackBar('Network error');
      } on LemmyApiException catch (e) {
        showSnackBar(e.message);
      } catch (e) {
        showSnackBar(e.toString());
      } finally {
        pending.value = false;
      }
    }

    return ListTile(
      leading: Avatar(url: community.icon),
      title: Text(community.originPreferredName),
      trailing: IconButton(
        icon: pending.value
            ? const CircularProgressIndicator.adaptive()
            : const Icon(Icons.cancel),
        tooltip: 'unblock',
        onPressed: unblock,
      ),
      onTap: () {
        goToCommunity.byId(context, community.instanceHost, community.id);
      },
    );
  }
}
