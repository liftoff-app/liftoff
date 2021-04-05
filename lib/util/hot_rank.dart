import 'dart:math' show log, max, pow, ln10;

import 'package:lemmy_api_client/v3.dart';

/// Calculates hot rank
/// because API always claims it's `0`
/// and web version of lemmy also calculates it when loading comments
///
/// implementation taken from here:
/// https://github.com/LemmyNet/lemmy/blob/main/ui/src/utils.ts#L182-L203
double _calculateHotRank(int score, DateTime time) {
  log10(num x) => log(x) / ln10;

  final elapsed = (time.difference(DateTime.now()).inMilliseconds).abs() / 36e5;

  return (10000 * log10(max(1, 3 + score))) / pow(elapsed + 2, 1.8);
}

extension CommentHotRank on CommentView {
  double get computedHotRank =>
      _calculateHotRank(counts.score, comment.published);
}
