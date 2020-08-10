import 'package:flutter/foundation.dart' show required;
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
