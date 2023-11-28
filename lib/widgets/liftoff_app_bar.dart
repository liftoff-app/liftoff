import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/stores.dart';
import '../pages/inbox.dart';
import '../pages/profile_tab.dart';
import '../util/goto.dart';
import '../widgets/radio_picker.dart';

typedef AccountChangeAction = void Function();

/// Intended to be a simple drop-in replacement for AppBar, but with added
/// user icon functionality, so only needs to be used on screens where it's
/// helpful to show that information.
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
    final defaultInstance = accStore.defaultInstanceHost;
    late final CircleAvatar avi;
    late final bool validUser;
    const dragThreshold = 10;
    final dragStart = useState<double>(0);
    final dragEnd = useState<double>(0);
    const invalidAvi = CircleAvatar(backgroundColor: Colors.grey);

    // Generate the most suitable user image.
    if (defaultInstance == null) {
      avi = invalidAvi;
      validUser = false;
    } else {
      final defaultUserData = accStore.defaultUserDataFor(defaultInstance);
      if (defaultUserData == null) {
        avi = invalidAvi;
        validUser = false;
      } else {
        validUser = true;
        final avatar = accStore.avatarBytes;
        avi = avatar != null && avatar.isNotEmpty
            ? CircleAvatar(backgroundImage: Image.memory(avatar).image)
            : invalidAvi;
      }
    }

    final plainIcon = IconButton(
      iconSize: 30,
      icon: avi,
      onPressed: () {},
    );

    final userList = accStore.loggedInInstances
        .expand(
          (instanceHost) => accStore
              .usernamesFor(instanceHost)
              .map((username) => '$username@$instanceHost'),
        )
        .toList();

    changeAccount(value) {
      final [user, instance] = value.split('@');
      accStore.setDefaultAccount(instance, user);
      // Allow the caller to react if needed on account change.
      if (onAccountChange != null) onAccountChange!();
    }

    /// Renders the user image wrapped in a GestureDetector,
    /// suitable for calling from `RadioPicker`.
    Widget buttonBuilder(context, displayValue, onPressed) {
      final button = GestureDetector(
        onTap: () => goTo(context,
            (_) => !validUser ? const UserProfileTab() : const InboxPage()),
        onDoubleTap: () => goTo(context, (_) => const UserProfileTab()),
        onLongPress: !validUser ? () => const UserProfileTab() : onPressed,
        onVerticalDragStart: (details) {
          dragStart.value = details.localPosition.dy;
        },
        onVerticalDragUpdate: (details) {
          dragEnd.value = details.localPosition.dy;
        },
        onVerticalDragEnd: (details) {
          final delta = dragStart.value - dragEnd.value;
          if (delta.abs() > dragThreshold) {
            if (userList.length > 1 && validUser) {
              var currIndex = userList.indexOf(accStore.defaultUserAtInstance!);
              if (currIndex == -1) return;
              currIndex += delta.sign.toInt();
              if (currIndex < 0) currIndex = userList.length - 1;
              if (currIndex == userList.length) currIndex = 0;
              changeAccount(userList[currIndex]);
            }
          }
        },
        child: avi,
      );

      if (accStore.totalNotificationCount == 0) return button;

      return Badge(
        offset: const Offset(5, 0),
        label: Text(accStore.totalNotificationCount.toString()),
        child: button,
      );
    }

    final accountChanger = RadioPicker<String>(
      values: userList,
      groupValue: accStore.defaultUserAtInstance!,
      onChanged: changeAccount,
      buttonBuilder: buttonBuilder,
    );
    final leadingActions = Row(children: [
      if (canChangeAccount) accountChanger else plainIcon,
      if (backButton || closeButton)
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(backButton ? Icons.adaptive.arrow_back : Icons.close),
          onPressed: () => Navigator.pop(context, null),
        ),
    ]);

    return SafeArea(
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: preferredSize.height),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: AppBar(
                      centerTitle: false,
                      titleSpacing: 5,
                      backgroundColor: bgc,
                      leading: leadingActions,
                      leadingWidth: (backButton || closeButton) ? 90 : null,
                      title: title,
                      flexibleSpace: flexibleSpace,
                      actions: actions,
                      bottom: bottom,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));
}
