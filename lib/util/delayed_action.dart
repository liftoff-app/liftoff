import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v2.dart';

import '../hooks/delayed_loading.dart';

/// Executes an API action that uses [DelayedLoading], has a try-catch
/// that displays a [SnackBar] on the Scaffold.of(context) when the action fails
Future<void> delayedAction<T>({
  @required BuildContext context,
  @required DelayedLoading delayedLoading,
  @required String instanceHost,
  @required LemmyApiQuery<T> query,
  Function(T) onSuccess,
  Function(T) cleanup,
}) async {
  assert(delayedLoading != null);
  assert(instanceHost != null);
  assert(query != null);
  assert(context != null);

  T val;
  try {
    delayedLoading.start();
    val = await LemmyApiV2(instanceHost).run<T>(query);
    onSuccess?.call(val);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
  cleanup?.call(val);
  delayedLoading.cancel();
}
