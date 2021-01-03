/// Strips protocol, 'www.', and trailing '/' from [url] aka. cleans it up
String cleanUpUrl(String url) {
  var newUrl = url;

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
