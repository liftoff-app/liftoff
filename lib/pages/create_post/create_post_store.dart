import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../util/async_store.dart';

part 'create_post_store.g.dart';

class CreatePostStore = _CreatePostStore with _$CreatePostStore;

abstract class _CreatePostStore with Store {
  final Post? postToEdit;
  bool get isEdit => postToEdit != null;

  _CreatePostStore({
    required this.instanceHost,
    this.postToEdit,
    this.selectedCommunity,
  })  : title = postToEdit?.name ?? '',
        nsfw = postToEdit?.nsfw ?? false,
        body = postToEdit?.body ?? '',
        url = postToEdit?.url ?? '';

  @observable
  bool showFancy = false;
  @observable
  String instanceHost;
  @observable
  CommunityView? selectedCommunity;
  @observable
  String url;
  @observable
  String title;
  @observable
  String body;
  @observable
  bool nsfw;

  final submitState = AsyncStore<PostView>();
  final searchCommunitiesState = AsyncStore<List<CommunityView>>();

  @action
  Future<List<CommunityView>?> searchCommunities(
    String searchTerm,
    Jwt? token,
  ) {
    if (searchTerm.isEmpty) {
      return searchCommunitiesState.runLemmy(
        instanceHost,
        ListCommunities(
          type: PostListingType.all,
          sort: SortType.topAll,
          limit: 20,
          auth: token?.raw,
        ),
      );
    } else {
      return searchCommunitiesState.runLemmy(
        instanceHost,
        SearchCommunities(
          q: searchTerm,
          sort: SortType.topAll,
          listingType: PostListingType.all,
          limit: 20,
          auth: token?.raw,
        ),
      );
    }
  }

  @action
  Future<void> submit(Jwt token) async {
    await submitState.runLemmy(
      instanceHost,
      isEdit
          ? EditPost(
              url: url.isEmpty ? null : url,
              body: body.isEmpty ? null : body,
              nsfw: nsfw,
              name: title,
              postId: postToEdit!.id,
              auth: token.raw,
            )
          : CreatePost(
              url: url.isEmpty ? null : url,
              body: body.isEmpty ? null : body,
              nsfw: nsfw,
              name: title,
              communityId: selectedCommunity!.community.id,
              auth: token.raw,
            ),
    );
  }
}

class SearchCommunities implements LemmyApiQuery<List<CommunityView>> {
  final Search base;

  SearchCommunities({
    required String q,
    PostListingType? listingType,
    SortType? sort,
    int? page,
    int? limit,
    String? auth,
  }) : base = Search(
          q: q,
          type: SearchType.communities,
          listingType: listingType,
          sort: sort,
          page: page,
          limit: limit,
          auth: auth,
        );

  @override
  String get path => base.path;

  @override
  HttpMethod get httpMethod => base.httpMethod;

  @override
  List<CommunityView> responseFactory(Map<String, dynamic> json) =>
      base.responseFactory(json).communities;

  @override
  Map<String, dynamic> toJson() => base.toJson();
}
