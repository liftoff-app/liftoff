import 'package:flutter/foundation.dart' show required;
import 'v1/main.dart';

export 'v1/comment_endpoint.dart';
export 'v1/post_endpoint.dart';
export 'v1/user_endpoint.dart';

class LemmyAPI {
  /// url of this lemmy instance
  String instanceUrl;

  V1 v1;

  /// initialize lemmy api instance
  LemmyAPI(this.instanceUrl)
      : assert(instanceUrl != null),
        v1 = V1(instanceUrl);
}
