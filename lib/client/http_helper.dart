import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

extension OkResponse on http.Response {
  bool get ok => statusCode >= 200 && statusCode < 300;
}

abstract class HttpHelper {
  String host;
  String extraPath;

  Future<Map<String, dynamic>> get(
      String path, Map<String, String> query) async {
    var res = await http.get(Uri.https(host, "$extraPath$path", query));

    if (!res.ok) {
      // failed request, handle here
    }

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
    var res = await http.post(
      Uri.https(host, "$extraPath$path"),
      body: jsonEncode(body),
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
    );

    if (!res.ok) {
      // failed request, handle here
    }

    return jsonDecode(res.body);
  }
}
