import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'markdown_text.dart';

enum MediaType {
  image,
  gallery,
  video,
  other,
}

MediaType whatType(String url) {
  if (url == null) return MediaType.other;

  // TODO: make detection more nuanced
  if (url.endsWith('.jpg') || url.endsWith('.png') || url.endsWith('.gif')) {
    return MediaType.image;
  }
  return MediaType.other;
}

class PostWidget extends StatelessWidget {
  final PostView post;
  final String hostUrl;

  /// nullable
  final String linkPostDomain;

  ThemeData _theme;
  BuildContext _context;

  PostWidget(this.post)
      : hostUrl = post.communityActorId.split('/')[2],
        linkPostDomain = post.url != null ? post.url.split('/')[2] : null;

  // == ACTIONS ==

  void _openLink() {
    print('OPEN LINK');
  }

  void _goToUser() {
    print('GO TO USER');
  }

  void _goToPost() {
    print('GO OT POST');
  }

  void _goToCommunity() {
    print('GO TO COMMUNITY');
  }

  void _goToInstance() {
    print('GO TO INSTANCE');
  }

  void _openFullImage() {
    print('OPEN FULL IMAGE');
  }

  // POST ACTIONS

  void _savePost() {
    print('SAVE POST');
  }

  void _upvotePost() {
    print('UPVOTE POST');
  }

  void _downvotePost() {
    print('DOWNVOTE POST');
  }

  void _showMoreMenu() {
    print('SHOW MORE MENU');
  }

  // == UI ==

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    _context = context;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black54)],
        color: _theme.colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: _goToPost,
        child: Column(
          children: [
            _info(),
            _title(),
            if (whatType(post.url) != MediaType.other)
              _postImage()
            else if (post.url != null)
              _linkPreview(),
            if (post.body != null) _textBody(),
            _actions(),
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (post.communityIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: _goToCommunity,
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                          ),
                        ),
                        imageUrl: post.communityIcon,
                        errorWidget: (context, url, error) =>
                            Text(error.toString()),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Column(
            children: [
              Row(children: [
                RichText(
                  overflow: TextOverflow.ellipsis, // TODO: fix overflowing
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 15, color: _theme.textTheme.bodyText1.color),
                    children: [
                      TextSpan(
                          text: '!',
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: post.communityName,
                          style: TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _goToCommunity),
                      TextSpan(
                          text: '@',
                          style: TextStyle(fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: hostUrl,
                          style: TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _goToInstance),
                    ],
                  ),
                )
              ]),
              Row(children: [
                RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 13,
                          color: _theme.textTheme.bodyText1.color),
                      children: [
                        TextSpan(
                            text: 'by',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                        TextSpan(
                          text:
                              ''' ${post.creatorPreferredUsername ?? post.creatorName}''',
                          style: TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()..onTap = _goToUser,
                        ),
                        TextSpan(
                            text:
                                ''' · ${timeago.format(post.published, locale: 'en_short')}'''),
                        if (linkPostDomain != null)
                          TextSpan(text: ' · $linkPostDomain'),
                        if (post.locked) TextSpan(text: ' · 🔒'),
                      ],
                    ))
              ]),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Spacer(),
          Column(
            children: [
              IconButton(
                onPressed: _showMoreMenu,
                icon: Icon(Icons.more_vert),
              )
            ],
          )
        ]),
      ),
    ]);
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          Flexible(
            child: Text(
              '${post.name}',
              textAlign: TextAlign.left,
              softWrap: true,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          if (post.url != null &&
              !(whatType(post.url) != MediaType.other) &&
              post.thumbnailUrl != null)
            Spacer(),
          if (post.url != null &&
              !(whatType(post.url) != MediaType.other) &&
              post.thumbnailUrl != null)
            InkWell(
              onTap: _openLink,
              child: Stack(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: post.thumbnailUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Text(error.toString()),
                    )),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.launch,
                    size: 20,
                  ),
                )
              ]),
            )
        ],
      ),
    );
  }

  Widget _postImage() {
    assert(post.url != null);

    return InkWell(
      onTap: _openFullImage,
      child: CachedNetworkImage(
        imageUrl: post.url,
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(value: progress.progress),
      ),
    );
  }

  Widget _linkPreview() {
    assert(post.url != null);

    var url = post.url.split('/')[2];
    if (url.startsWith('www.')) {
      url = url.substring(4);
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: _openLink,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(children: [
                  Spacer(),
                  Text('$url ',
                      style: _theme.textTheme.caption
                          .apply(fontStyle: FontStyle.italic)),
                  Icon(Icons.launch, size: 12),
                ]),
                Row(children: [
                  Flexible(
                      child: Text(post.embedTitle,
                          style: _theme.textTheme.subtitle1
                              .apply(fontWeightDelta: 2)))
                ]),
                Row(children: [Flexible(child: Text(post.embedDescription))]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: MarkdownText(post.body, _context),
    );
  }

  Widget _actions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: [
          Icon(Icons.comment),
          Expanded(
            flex: 999,
            child: Text(
              '''  ${NumberFormat.compact().format(post.numberOfComments)} comment${post.numberOfComments == 1 ? '' : 's'}''',
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          Spacer(),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () => Share.text('Share post url', post.apId,
                  'text/plain')), // TODO: find a way to mark it as url
          IconButton(
              icon: post.saved == true
                  ? Icon(Icons.bookmark)
                  : Icon(Icons.bookmark_border),
              onPressed: _savePost),
          IconButton(icon: Icon(Icons.arrow_upward), onPressed: _upvotePost),
          Text(NumberFormat.compact().format(post.score)),
          IconButton(
              icon: Icon(Icons.arrow_downward), onPressed: _downvotePost),
        ],
      ),
    );
  }
}
