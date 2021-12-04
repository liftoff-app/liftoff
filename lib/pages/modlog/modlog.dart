import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/bottom_safe.dart';
import '../../widgets/failed_to_load.dart';
import 'modlog_page_store.dart';
import 'modlog_table.dart';

class ModlogPage extends StatelessWidget {
  final String name;

  const ModlogPage._({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$name's modlog")),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                ObserverBuilder<ModlogPageStore>(
                  builder: (context, store) {
                    if (!store.hasNextPage) {
                      return const Center(child: Text('no more logs to show'));
                    }

                    return store.modlogState.map(
                      loading: () => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      error: (errorTerm) => Center(
                        child: FailedToLoad(
                          message: errorTerm.tr(context),
                          refresh: store.fetchPage,
                        ),
                      ),
                      data: (modlog) => ModlogTable(modlog: modlog),
                    );
                  },
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ObserverBuilder<ModlogPageStore>(
                        builder: (context, store) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: store.hasPreviousPage &&
                                      !store.modlogState.isLoading
                                  ? store.previousPage
                                  : null,
                              child: const Icon(Icons.skip_previous),
                            ),
                            TextButton(
                              onPressed: store.hasNextPage &&
                                      !store.modlogState.isLoading
                                  ? store.nextPage
                                  : null,
                              child: const Icon(Icons.skip_next),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const BottomSafe(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Route forInstanceRoute(String instanceHost) {
    return MaterialPageRoute(
      builder: (context) => MobxProvider(
        create: (context) => ModlogPageStore(instanceHost)..fetchPage(),
        child: ModlogPage._(name: instanceHost),
      ),
    );
  }

  static Route forCommunityRoute({
    required String instanceHost,
    required int communityId,
    required String communityName,
  }) {
    return MaterialPageRoute(
      builder: (context) => MobxProvider(
        create: (context) =>
            ModlogPageStore(instanceHost, communityId)..fetchPage(),
        child: ModlogPage._(name: '!$communityName'),
      ),
    );
  }
}
