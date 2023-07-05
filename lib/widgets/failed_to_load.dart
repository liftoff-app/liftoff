import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class FailedToLoad extends StatelessWidget {
  final String message;
  final VoidCallback refresh;

  const FailedToLoad({required this.refresh, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (message.contains('502'))
          SizedBox(
            height: 200,
            width: 300,
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 75),
                const SizedBox(height: 15),
                Text(
                  L10n.of(context).instance_error,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        else if (message.contains('404'))
          SizedBox(
            height: 200,
            width: 300,
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 75),
                const SizedBox(height: 15),
                Text(
                  L10n.of(context).instance_record_notfound,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        else
          Text(message),
        const SizedBox(height: 5),
        ElevatedButton.icon(
          onPressed: refresh,
          icon: const Icon(Icons.refresh),
          label: Text(L10n.of(context).try_again),
        )
      ],
    );
  }
}
