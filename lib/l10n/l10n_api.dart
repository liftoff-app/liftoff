import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import 'gen/l10n.dart';

extension SortTypeL10n on SortType {
  String tr(BuildContext context) {
    switch (this) {
      case SortType.hot:
        return L10n.of(context).hot;
      case SortType.new_:
        return L10n.of(context).new_;
      case SortType.topYear:
        return L10n.of(context).top_year;
      case SortType.topMonth:
        return L10n.of(context).top_month;
      case SortType.topWeek:
        return L10n.of(context).top_week;
      case SortType.topDay:
        return L10n.of(context).top_day;
      case SortType.topAll:
        return L10n.of(context).top_all;
      case SortType.newComments:
        return L10n.of(context).new_comments;
      case SortType.active:
        return L10n.of(context).active;
      case SortType.mostComments:
        return L10n.of(context).most_comments;
      default:
        throw Exception('unreachable');
    }
  }
}

extension PostListingTypeL10n on PostListingType {
  String tr(BuildContext context) {
    switch (this) {
      case PostListingType.all:
        return L10n.of(context).all;
      case PostListingType.community:
        return L10n.of(context).community;
      case PostListingType.local:
        return L10n.of(context).local;
      case PostListingType.subscribed:
        return L10n.of(context).subscribed;
      default:
        throw Exception('unreachable');
    }
  }
}

extension SearchTypeL10n on SearchType {
  String tr(BuildContext context) {
    switch (this) {
      case SearchType.all:
        return L10n.of(context).all;
      case SearchType.comments:
        return L10n.of(context).comments;
      case SearchType.communities:
        return L10n.of(context).communities;
      case SearchType.posts:
        return L10n.of(context).posts;
      case SearchType.url:
        return L10n.of(context).url;
      case SearchType.users:
        return L10n.of(context).users;
      default:
        throw Exception('unreachable');
    }
  }
}
