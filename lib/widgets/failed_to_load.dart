import 'package:flutter/material.dart';

class FailedToLoad extends StatelessWidget {
  final String message;
  final VoidCallback refresh;

  const FailedToLoad({required this.refresh, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        const SizedBox(height: 5),
        ElevatedButton.icon(
          onPressed: refresh,
          icon: const Icon(Icons.refresh),
          label: const Text('try again'),
        )
      ],
    );
  }
}
