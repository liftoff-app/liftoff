import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../pages/inbox.dart';
import '../util/goto.dart';
import '../widgets/radio_picker.dart';

typedef AccountChangeAction = void Function();

class LiftoffAppBar extends HookWidget implements PreferredSizeWidget {
  final double height;

  const LiftoffAppBar({
    super.key,
    this.height = 60,
    this.backgroundColor,
    this.backButton = false,
    this.closeButton = false,
    this.title,
    this.flexibleSpace,
    this.actions,
    this.bottom,
    this.canChangeAccount = true,
    this.onAccountChange,
  });
  final Color? backgroundColor;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final bool backButton;
  final bool closeButton;
  final PreferredSizeWidget? bottom;
  final bool canChangeAccount;
  final AccountChangeAction? onAccountChange;

  @override
  Widget build(BuildContext context) {
    final bgc = backgroundColor ?? Theme.of(context).canvasColor;

    final accStore = useAccountsStore();
    final defaultInstance = accStore.defaultInstanceHost!;
    final defaultUserData = accStore.defaultUserDataFor(defaultInstance)!;
    final personDetails = useMemoFuture(() async {
      return await LemmyApiV3(defaultInstance).run(GetPersonDetails(
        personId: defaultUserData.userId,
        savedOnly: false,
        sort: SortType.active,
        auth: defaultUserData.jwt.raw,
      ));
    }, [defaultUserData, defaultInstance]);

    final plainIcon = IconButton(
      iconSize: 30,
      icon: personDetails.hasData &&
              personDetails.data != null &&
              personDetails.data!.personView.person.avatar != null
          ? CircleAvatar(
              backgroundImage:
                  NetworkImage(personDetails.data!.personView.person.avatar!))
          : const CircleAvatar(
              backgroundColor: Colors.grey,
            ),
      onPressed: () {},
    );

    Widget buttonBuilder(context, displayValue, onPressed) {
      final avi = personDetails.hasData &&
              personDetails.data != null &&
              personDetails.data!.personView.person.avatar != null
          ? CircleAvatar(
              backgroundImage:
                  NetworkImage(personDetails.data!.personView.person.avatar!))
          : const CircleAvatar(
              // TODO: copy @jcgurango's initicon work.
              backgroundColor: Colors.grey,
            );
      final button = GestureDetector(
        onTap: () => goTo(context, (_) => const InboxPage()),
        onLongPress: onPressed,
        // TODO: Lasath :-)
        // onHorizontalDragDown: ,
        child: avi,
      );
      if (accStore.totalNotificationCount == 0) return button;
      return Badge(
        offset: const Offset(5, 0),
        label: Text(accStore.totalNotificationCount.toString()),
        child: button,
      );
    }

    // TODO: Wrap with GestureDetector?
    final accountChanger = RadioPicker<String>(
      values: accStore.loggedInInstances
          .expand(
            (instanceHost) => accStore
                .usernamesFor(instanceHost)
                .map((username) => '$username@$instanceHost'),
          )
          .toList(),
      groupValue: '${accStore.defaultUsername}@${accStore.defaultInstanceHost}',
      onChanged: (value) {
        final [user, instance] = value.split('@');
        accStore.setDefaultAccount(instance, user);
        if (onAccountChange != null) onAccountChange!();
        // TODO: refresh page somehow.
      },
      buttonBuilder: buttonBuilder,
    );
    final leadingActions = Row(children: [
      if (canChangeAccount) accountChanger else plainIcon,
      if (backButton || closeButton)
        IconButton(
          visualDensity: VisualDensity.compact,
          //padding: EdgeInsets.zero,
          icon: Icon(backButton ? Icons.adaptive.arrow_back : Icons.close),
          onPressed: () => Navigator.pop(context, null),
        ),
    ]);

    return SafeArea(
      child: Column(
        children: [
          ColoredBox(
            color: bgc,
            // everything down to AppBar is to allow TabBars to render okay.
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: preferredSize.height),
                    child: AppBar(
                      centerTitle: false,
                      titleSpacing: 5,
                      leading: leadingActions,
                      leadingWidth: (backButton || closeButton) ? 90 : null,
                      title: title,
                      flexibleSpace: flexibleSpace,
                      actions: actions,
                      bottom: bottom,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      // Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));
      Size.fromHeight(height + (bottom != null ? 40 : 0));
}
