# Contributing

...is welcome!

## Issue tracking / Repository

From issues to wikis: everything is on [GitHub](https://github.com/LemmurOrg/lemmur)

## Linting / Formatting

Everything is formatted with `dart format` (no flags) and linted with `dart analyze` ([see rules](analysis_options.yaml)). Both are enforced by the CI.

## Translations

### Time ago strings

Strings such as "_About one hour ago_" or "_~1h_" are localizable. We inherit a set of ready translations from [github.com/andresaraujo/timeago.dart/messages](https://github.com/andresaraujo/timeago.dart/tree/master/timeago/lib/src/messages) and provide our own in [lib/l10n/timeago](./lib/l10n/timeago).

To contribute time ago strings please send a PR containing a class that implements `timeago.LookupMessages`. Place it under [lib/l10n/timeago](./lib/l10n/timeago) with an appropriate name (locale tag) and finally register it in [main_common.dart](./lib/main_common.dart) in the `_setupTimeago` function. Each locale can have a normal (for example "_About one hour ago_") and a short (for example "_~1h_") variant, there are registered separately.

## Architecture

Lemmur is written in Dart using [Flutter](https://flutter.dev/docs). To communicate with Lemmy instances [lemmy_api_client](https://github.com/LemmurOrg/lemmy_api_client) is used.

### State management

[`MobX`](https://github.com/mobxjs/mobx.dart) + [Provider](https://github.com/rrousselGit/provider) is used for global state management, [flutter_hooks](https://github.com/rrousselGit/flutter_hooks) is used for local (widget-level) state management. `StatefulWidget`s are avoided all together and any state logic reuse is moved to a [custom hook](./lib/hooks).

### Project structure

(relative to `lib/`)

- `hooks/`: reusable state hooks
- `l10n/`: files with localized strings and localizations tools
- `pages/`: fullscreen pages that you navigate to
- `stores/`: global stores
- `util/`: utilities
- `widgets/`: reusable widgets; building blocks for pages
- `main_common.dart`: entrypoint of the app. Sets up the stores, initializes the themes, renders the first page

### Things to keep in mind

- Be aware that Lemmur supports arbitrary Lemmy instances, don't hardcode instance urls
- Remember that a user is not obligated to be logged in, contributed widgets should handle this case

### Lemmy API

LAC (Lemmy API Client) is used to communicate with Lemmy backends, more information can be found [here](https://github.com/LemmurOrg/lemmy_api_client).

### For React developers

If you come from a React background Flutter shouldn't be anything hard to grasp for you.

- Components are called 'widgets' in flutter
- `flutter_hooks` is a React hooks port to flutter. Though you will come to see that `flutter_hooks` are not as powerful
- There is no CSS. You compose your layout with other widgets and style them by passing properties to them
- There are no functional components, everything has to be a class
- Creating wrapping widgets is not as nice as in React, there is no `{ ...props }`. In flutter you need to pass each argument one by one
