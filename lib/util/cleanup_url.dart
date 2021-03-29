/// Strips protocol, 'www.', and trailing '/' from [url] aka. cleans it up
String cleanUpUrl(String url) {
  var newUrl = url.toLowerCase();

  if (newUrl.startsWith('https://')) {
    newUrl = newUrl.substring(8);
  }
  if (newUrl.startsWith('www.')) {
    newUrl = newUrl.substring(4);
  }
  if (newUrl.endsWith('/')) {
    newUrl = newUrl.substring(0, newUrl.length - 1);
  }

  return newUrl;
}

// Returns host of a url without a leading 'www.' if present
String urlHost(String url) {
  final host = Uri.parse(url).host;

  if (host.startsWith('www.')) {
    return host.substring(4);
  }

  return host;
}
