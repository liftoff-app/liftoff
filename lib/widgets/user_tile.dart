import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../util/extensions/api.dart';
import '../util/goto.dart';
import 'avatar.dart';
import 'markdown_text.dart';

class PersonTile extends StatelessWidget {
  final PersonSafe person;
  final bool expanded;
  const PersonTile(
    this.person, {
    this.expanded = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(person.originPreferredName),
      subtitle: person.bio != null && expanded
          ? Opacity(
              opacity: 0.7,
              child:
                  MarkdownText(person.bio!, instanceHost: person.instanceHost),
            )
          : null,
      onTap: () => goToUser.fromPersonSafe(context, person),
      leading: Avatar(url: person.avatar),
    );
  }
}
