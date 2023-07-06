import 'package:flutter/material.dart';

import '../../stores/accounts_store.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/radio_picker.dart';
import 'create_post_store.dart';

class CreatePostInstancePicker extends StatelessWidget {
  const CreatePostInstancePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedInInstances =
        context.watch<AccountsStore>().loggedInInstances.toList();

    return ObserverBuilder<CreatePostStore>(
      builder: (context, store) => RadioPicker<String>(
        values: loggedInInstances,
        groupValue: store.instanceHost,
        onChanged: store.isEdit ? null : (value) => store.instanceHost = value,
        buttonBuilder: (context, displayValue, onPressed) => FilledButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(displayValue),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
