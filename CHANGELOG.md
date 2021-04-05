## Unreleased

### Added

- Share buttons on windows/linux now copy the data to the clipboard

### Changed

- Transitioned to Lemmy API v3

### Fixed

- Quote blocks in posts and comments are now much prettier
- Code blocks now have monospace font. As they should
- Switching accounts in the profile tab now correctly reacts to the change

## v0.3.0 - 2021-02-25

WARNING: due to some internal changes your local settings will be reset (logged out of accounts, removed instances, theme back to default)

### Added

- Added inbox page, that can be accessed by tapping bell in the home tab
- Added page with saved posts/comments. It can be accessed from the profile tab under the bookmark icon
- Added ability to send private messages
- Added modlog page. Can be visited in the context of an instance or community from the about tab
- You can now create posts from the community page

### Changed

- Titles on some pages, have an appear effect when scrolling down
- Long pressing comments now has a ripple effect
- Nerd stuff now contains more nerd stuff
- Communities that a user follows will no longer appear on a user's profile in most scenarios

### Fixed

- Time of posts is now displayed properly. Unless you live in UTC zone, then you won't notice a difference
- Fixed a bug where links would not work on Android 11

## v0.2.3 - 2021-02-09

Lemmur is now available on the [play store](https://play.google.com/store/apps/details?id=com.krawieck.lemmur) and [f-droid](https://f-droid.org/packages/com.krawieck.lemmur)

### Changed

- Posts with large amount of text are now truncated in infinite scroll views
- Changed image viewer dismissal to be more fun. The image now also moves on the x axis, changes scale and rotates a bit for more user enjoyment

### Fixed

- Fixed issue where the "About lemmur" tile would not appear on Windows/Linux
- Added a bigger bottom margin in the comment section to prevent the floating action button from covering the last comment

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
