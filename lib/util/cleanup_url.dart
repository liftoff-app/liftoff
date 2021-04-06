/// Returns a normalized host of a (maybe) url without a leading www.
String normalizeInstanceHost(String maybeUrl) {
  try {
    return urlHost(
        maybeUrl.startsWith('https://') ? maybeUrl : 'https://$maybeUrl');
  } on FormatException {
    return '';
  }
}

// Returns host of a url without a leading 'www.' if present
String urlHost(String url) {
  final host = Uri.parse(url).host;

  if (host.startsWith('www.')) {
    return host.substring(4);
  }

  return host;
}
