import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'liftoff_media_provider.dart';

class RedgifProvider implements LiftoffMediaProvider {
  const RedgifProvider();
  static String? _authToken;

  Future<Uri> _getRedgifUrl(Uri url, {allowRetries = true}) async {
    final token = await _getAuthtoken();
    final id = basename(url.path);

    final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
    var requestUrl = 'https://api.redgifs.com/v2/gifs/$id';
    if (Platform.isAndroid) {
      requestUrl = '$requestUrl?user-agent=ExoPlayer';
    }

    final response = await http.get(Uri.parse(requestUrl), headers: headers);

    final statusCode = response.statusCode;
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Uri.parse(json['gif']['urls']['hd']);
    } else if (allowRetries && (statusCode == 401 || statusCode == 403)) {
      _authToken = null;
      return _getRedgifUrl(url, allowRetries: false);
    } else {
      throw Exception('Unable to query redgifs for url');
    }
  }

  @override
  Future<Uri> getMediaUrl(Uri url) async {
    return _getRedgifUrl(url);
  }

  @override
  bool providesFor(Uri url) {
    return url.host == 'redgifs.com';
  }

  //TODO Get a real API Key
  Future<String> _getAuthtoken() async {
    if (_authToken != null) {
      return _authToken!;
    }

    final response =
        await http.get(Uri.parse('https://api.redgifs.com/v2/auth/temporary'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final token = json['token'];
      _authToken = token;
      return token;
    } else {
      throw Exception('Unable to request a redgif token');
    }
  }
}
