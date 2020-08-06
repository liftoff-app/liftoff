import 'package:flutter/material.dart';
import 'v1/main.dart';

class LemmyAPI {
  /// url of this lemmy instance
  String instanceUrl;

  V1 v1;

  /// initialize lemmy api instance
  LemmyAPI({@required this.instanceUrl})
      : assert(instanceUrl != null),
        v1 = V1(instanceUrl);
}
