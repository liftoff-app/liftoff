import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v2.dart';

import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../widgets/sortable_infinite_list.dart';

/// Page with saved posts/comments. Fetches such saved data from the default user
/// Assumes there is at least one logged in user
class SavedPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final accountStore = useAccountsStore();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).saved),
          bottom: TabBar(
            tabs: [
              Tab(text: L10n.of(context).posts),
              Tab(text: L10n.of(context).comments),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InfinitePostList(
              fetcher: (page, batchSize, sortType) =>
                  LemmyApiV2(accountStore.defaultInstanceHost)
                      .run(
                        GetUserDetails(
                          userId: accountStore.defaultToken.payload.id,
                          sort: sortType,
                          savedOnly: true,
                          page: page,
                          limit: batchSize,
                          auth: accountStore.defaultToken.raw,
                        ),
                      )
                      .then((value) => value.posts),
            ),
            InfiniteCommentList(
              fetcher: (page, batchSize, sortType) =>
                  LemmyApiV2(accountStore.defaultInstanceHost)
                      .run(
                        GetUserDetails(
                          userId: accountStore.defaultToken.payload.id,
                          sort: sortType,
                          savedOnly: true,
                          page: page,
                          limit: batchSize,
                          auth: accountStore.defaultToken.raw,
                        ),
                      )
                      .then((value) => value.comments),
            ),
          ],
        ),
      ),
    );
  }
}
