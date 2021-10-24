import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReportDialog extends HookWidget {
  const ReportDialog();

  @override
  Widget build(BuildContext context) {
    final controller = useListenable(useTextEditingController());
    return AlertDialog(
      title: const Text('Report'),
      content: TextField(
        autofocus: true,
        controller: controller,
        decoration: const InputDecoration(
          label: Text('reason'),
        ),
        minLines: 1,
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: controller.text.trim().isEmpty
              ? null
              : () => Navigator.of(context).pop(controller.text.trim()),
          child: const Text('report'),
        ),
      ],
    );
  }

  static Future<String?> show(BuildContext context) async =>
      showDialog(context: context, builder: (context) => const ReportDialog());
}
