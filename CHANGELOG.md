## Unreleased

### Changed

- Changed image viewer dismissal to be more fun. The image now also moves on the x axis, changes scale and rotates a bit for more user enjoyment

## v0.2.2 - 2021-02-03

Minimum Lemmy version supported: `v0.9.4`

### Added

- Online users count is now correctly displayed
- APKs are now signed

### Fixed

- Fixed a bug where replying to a comment would instead reply to the parent of that comment
- Fixed a bug where comments would be displayed as a grey block
- Fixed a bug where adding/removing accounts could cause the home/communities/search tabs to crash
- Fixed a bug where up/down voting twice cause the comment/post to crash

## v0.2.1 - 2021-02-03

[YANKED]

## v0.2.0 - 2021-01-27

### Breaking changes

- Lemmur now works exclusively with Lemmy API v2

### Added

- You can now manage account-specific settings, such as username, avatar, etc.

### Fixed

- Fixed a bug where in some circumstances removal of an instance would fail

## v0.1.1 - 2021-01-17

### Added

#### Pages

- Instance page
- Community page
- Post page
- User profile page
- Home tab
- Communities tab
- Search tab
- Profile tab
- Settings

#### Actions

- Create comment
- Create post
- Upvote/Downvote
- Save comments/posts
- Follow/Unfollow communities

#### Other

- Light/dark/AMOLED themes
- Manage multiple accounts/instances

### Notable things that don't work / are not implemented yet

- No notifications page
- No way to browse saved posts/comments
- Themes are not yet finalized so they might not look great in some situations
- Other than pictures, there is absolutely no caching

Remember: there's always option to open instance/community/post/comment in web browser from the app if there is a missing feature
