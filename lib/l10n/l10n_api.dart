import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:lemmy_api_client/v2.dart';

extension SortTypeL10n on SortType {
  String tr(BuildContext context) {
    switch (this) {
      case SortType.hot:
        return L10n.of(context).hot;
      case SortType.new_:
        return L10n.of(context).new_;
      case SortType.topYear:
      case SortType.topMonth:
      case SortType.topDay:
      case SortType.topAll:
      case SortType.newComments:
      case SortType.active:
      case SortType.mostComments:
      default:
        // TODO: l10n string
        return value;
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
