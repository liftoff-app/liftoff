import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/src/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  final PostView post;
  final String hostUrl;

  /// nullable
  final String linkPostDomain;

  ThemeData _theme;
//https://images-assets.nasa.gov/image/PIA04921/PIA04921~orig.jpg
  PostWidget(this.post)
      : hostUrl = post.communityActorId.split('/')[2],
        linkPostDomain = post.url != null ? post.url.split('/')[2] : null;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black54)],
        color: _theme.colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: () {
          print('GO TO POST');
        },
        child: Column(
          children: [
            _info(),
            _title(),
            _content(),
            _actions(),
          ],
        ),
      ),
    );
  }

  Widget _info() => Column(children: [
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
                      onTap: () => print('GO TO COMMUNITY'),
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
                    overflow: TextOverflow.ellipsis, // @TODO: fix overflowing
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 15,
                          color: _theme.textTheme.bodyText1.color),
                      children: [
                        TextSpan(
                            text: '!',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                        TextSpan(
                            text: post.communityName,
                            style: TextStyle(fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print('GO TO COMMUNITY')),
                        TextSpan(
                            text: '@',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                        TextSpan(
                            text: hostUrl,
                            style: TextStyle(fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print('GO TO INSTANCE')),
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
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print('GO TO USER'),
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
                  onPressed: () => print('POPUP MENU'),
                  icon: Icon(Icons.more_vert),
                )
              ],
            )
          ]),
        ),
      ]);

  Widget _title() => Padding(
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
            if (post.thumbnailUrl != null)
              InkWell(
                onTap: () => print('OPEN LINK'),
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

  Widget _content() {
    if (post.url == null) return Container();
    // naive implementation for now but will have
    // to add system for detecting type of media
    if (post.url.endsWith('.jpg') ||
        post.url.endsWith('.png') ||
        post.url.endsWith('.gif')) {
      return CachedNetworkImage(
        imageUrl: post.url,
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(value: progress.progress),
      );
    } else {
      return _linkPreview();
    }
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
        onTap: () => print('OPEN LINK'),
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

  Widget _actions() => Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: [
            Icon(Icons.comment),
            post.numberOfComments == 1
                ? Text('  1 comment')
                : Text('  ${post.numberOfComments} comments'),
            Spacer(),
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () => Share.text('Share post url', post.apId,
                    'text/plain')), // @TODO: find a way to mark it as url
            IconButton(
                icon: post.saved == true
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border),
                onPressed: () => print('SAVE')),
            IconButton(
                icon: Icon(Icons.arrow_upward),
                onPressed: () => print('UPVOTE')),
            Text(post.score.toString()),
            IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () => print('DOWNVOTE')),
          ],
        ),
      );
}
