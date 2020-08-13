import 'v1/main.dart';

export 'v1/main.dart';

class LemmyAPI {
  /// host uri of this lemmy instance
  String host;

  V1 v1;

  /// initialize lemmy api instance
  LemmyAPI(this.host)
      : assert(host != null),
        v1 = V1(host);
}
