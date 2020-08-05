import 'package:flutter/material.dart';
import 'package:lemmur/client/v1/main.dart';
import 'package:lemmur/client/v1/user_endpoint.dart';

class LemmyAPI {
  /// url of this lemmy instance
  String instanceUrl;

  V1 v1;

  /// initialize lemmy api instance
  LemmyAPI({@required this.instanceUrl})
      : assert(instanceUrl != null),
        v1 = V1(instanceUrl);
}
