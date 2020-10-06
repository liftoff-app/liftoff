String cleanUpUrl(String url) {
  if (url.startsWith('https://')) {
    url = url.substring(8);
  }
  if (url.startsWith('www.')) {
    url = url.substring(4);
  }
  if (url.endsWith('/')) {
    url = url.substring(0, url.length - 1);
  }

  return url;
}
