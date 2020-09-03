import 'dart:math' show log, max, pow, ln10;

import 'package:lemmy_api_client/lemmy_api_client.dart';

double _calculateHotRank(int score, DateTime time) {
  log10(num x) => log(x) / ln10;

  final elapsed = (time.difference(DateTime.now()).inMilliseconds).abs() / 36e5;

  // log instead of log10 in web version. does log == log10?

  return (10000 * log10(max(1, 3 + score))) / pow(elapsed + 2, 1.8);
}

extension CommentHotRank on CommentView {
  double get computedHotRank => _calculateHotRank(score, published);
}
