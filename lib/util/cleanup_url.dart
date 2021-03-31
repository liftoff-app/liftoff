/// Returns host of a url without a leading 'www.' or protocol if present also
/// removes trailing '/'
String cleanUpUrl(String url) =>
    urlHost(url.startsWith('https://') ? url : 'https://$url');

// Returns host of a url without a leading 'www.' if present
String urlHost(String url) {
  final host = Uri.parse(url).host;

  if (host.startsWith('www.')) {
    return host.substring(4);
  }

  return host;
}
