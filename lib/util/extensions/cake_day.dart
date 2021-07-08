import 'package:lemmy_api_client/v3.dart';

// inspired by https://github.com/LemmyNet/lemmy-ui/blob/66c846ededef8c0afd5aaadca4aaedcbaeab3ee6/src/shared/utils.ts#L533
extension PersonSafeCakeDay on PersonSafe {
  bool get isCakeDay {
    final now = DateTime.now();

    return now.day == published.day &&
        now.month == published.month &&
        now.year != published.year;
  }
}
