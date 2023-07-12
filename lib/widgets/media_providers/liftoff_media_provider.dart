abstract class LiftoffMediaProvider {
  bool providesFor(Uri url);
  Future<Uri> getMediaUrl(Uri url);
}
