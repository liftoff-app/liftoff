import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../widgets/sortable_infinite_list.dart';

/// Page with saved posts/comments. Fetches such saved data from the default user
/// Assumes there is at least one logged in user
class SavedPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final accountStore = useAccountsStore();

    if (accountStore.hasNoAccount) {
      Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('no account found'),
        ),
      );
    }

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
                  LemmyApiV3(accountStore.defaultInstanceHost!).run(
                GetPosts(
                  type: PostListingType.all,
                  sort: sortType,
                  savedOnly: true,
                  page: page,
                  limit: batchSize,
                  auth: accountStore.defaultUserData!.jwt.raw,
                ),
              ),
            ),
            InfiniteCommentList(
              fetcher: (page, batchSize, sortType) =>
                  LemmyApiV3(accountStore.defaultInstanceHost!).run(
                GetComments(
                  type: CommentListingType.all,
                  sort: sortType,
                  savedOnly: true,
                  page: page,
                  limit: batchSize,
                  auth: accountStore.defaultUserData!.jwt.raw,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
