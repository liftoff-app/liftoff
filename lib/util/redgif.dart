import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

bool isRedGif(String? url) {
  return url != null && url.contains("redgif.com");
}

//TODO Get a real API Key
//TODO Cache this value (looks to be good for about a day)
Future<String> _getAuthtoken() async {
  final response = await http.get(
      Uri.parse('https://api.redgifs.com/v2/auth/temporary'),
      headers: {HttpHeaders.userAgentHeader: 'liftoff/1.0'});
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['token'];
  } else {
    throw Exception('Unable to request a redgif token');
  }
}

Future<Map<String, String>> _getUrls(Uri url) async {
  final token = await _getAuthtoken();
  final id = basename(url.path);

  final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
  if (Platform.isAndroid) {
    headers.putIfAbsent(HttpHeaders.userAgentHeader, () => 'ExoPlayer');
  }
  final response = await http
      .get(Uri.parse('https://api.redgifs.com/v2/gifs/$id'), headers: headers);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['gif']['urls'];
  } else {
    throw Exception('Unable to query redgifs for url');
  }
}

Future<Uri> getHDUrl(Uri url) async {
  final urls = await _getUrls(url);
  return Uri.parse(urls['hd']!);
}

Future<Uri> getSDUrl(Uri url) async {
  final urls = await _getUrls(url);
  return Uri.parse(urls['sd']!);
}
