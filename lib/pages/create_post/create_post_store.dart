import 'package:lemmy_api_client/pictrs.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../util/async_store.dart';
import '../../util/pictrs.dart';

part 'create_post_store.g.dart';

class CreatePostStore = _CreatePostStore with _$CreatePostStore;

abstract class _CreatePostStore with Store {
  final Post? postToEdit;
  bool get isEdit => postToEdit != null;

  _CreatePostStore({
    required this.instanceHost,
    this.postToEdit,
    // ignore: unused_element
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
  final imageUploadState = AsyncStore<PictrsUploadFile>();

  @computed
  bool get hasUploadedImage => imageUploadState.map(
        loading: () => false,
        error: (_) => false,
        data: (_) => true,
      );

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
          limit: 10,
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
          limit: 10,
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

  @action
  Future<void> uploadImage(String filePath, Jwt token) async {
    final instanceHost = this.instanceHost;

    final upload = await imageUploadState.run(
      () => PictrsApi(instanceHost)
          .upload(
            filePath: filePath,
            auth: token.raw,
          )
          .then((value) => value.files.single),
    );

    if (upload != null) {
      url = pathToPictrs(instanceHost, upload.file);
    }
  }

  @action
  void removeImage() {
    final pictrsFile = imageUploadState.map<PictrsUploadFile?>(
      data: (data) => data,
      loading: () => null,
      error: (_) => null,
    );
    if (pictrsFile == null) return;

    PictrsApi(instanceHost).delete(pictrsFile).catchError((_) {});

    imageUploadState.reset();
    url = '';
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
