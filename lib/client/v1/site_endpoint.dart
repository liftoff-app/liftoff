import '../models/site.dart';
import '../v1/main.dart';

extension SiteEndpoint on V1 {
  /// GET /site
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-site
  Future<FullSiteView> getSite({String auth}) async {
    var res = await get('/site', {
      if (auth != null) 'auth': auth,
    });

    return FullSiteView.fromJson(res);
  }

  /// GET /site/config
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-site-config
  /// admin stuff
  Future<String> getSiteConfig() {
    throw UnimplementedError();
  }
}
