import 'package:path/path.dart';

abstract class LiftoffMediaProvider {
  bool providesFor(Uri url);
  Future<Uri> getMediaUrl(Uri url);
}

class MP4MediaProvider implements LiftoffMediaProvider {
  const MP4MediaProvider();

  @override
  Future<Uri> getMediaUrl(Uri url) {
    return Future(() => url);
  }

  @override
  bool providesFor(Uri url) {
    return extension(url.path) == '.mp4';
  }
}
