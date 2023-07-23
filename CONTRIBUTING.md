# Contributing

...is welcome!

## Issue tracking / Repository

From issues to wikis: everything is on [GitHub](https://github.com/liftoff-app/liftoff)

## Linting / Formatting

Everything is formatted with `dart format` (no flags) and linted with `flutter analyze` ([see rules](analysis_options.yaml)). Both are enforced by the CI.

## Translations

We intend to eventually use Weblate to allow you to contribute translation strings to Liftoff, but in the meantime you can look at the files in /assets/i10n -- intl_en.arb is our master file, which contains all the strings that should be translated, and the others are translation files contributed by our users. If you want to add or update a translation file before we get Weblate up and running, you can create an issue in GitHub with the translation file attached and we can add it into the build.

<!-- ### Weblate

Lemmy devs are kindly hosting liftoff translation strings on their [Weblate instance](https://weblate.yerbamate.ml/projects/liftoff/liftoff/). Feel free to contribute strings there, we regularly sync string changes with Weblate.
-->
We use flutter's native file format for translations: ARB, which itself uses the ICU message syntax. In most cases you will be able to deduce the syntax based on the source string. Here are 3 important examples:

1. Placeholders

`Hello there {name}!` - placeholders are put in a pair of braces, it will be later replaced with an appropriate value.

2. Plurals

`You have {amount} new {amount, plural, =0{messages} =1{message} =2{messages} few{messages} many{messages} other{message}}` - plurals are checked against their quantifier and provide 6 possible forms to choose from. In english this example does not make much sense, since we could just provide the `=1{message}` and `other{messages}` case. `other` case always has to be specified, it acts as a fallback.

3. Selects

`I will take a {distance_name, select, close{bus} far{train} veryFar{plane}}.` - selects allow for arbitrary matching against some predefined cases. All cases should be the same as in the source string.

### Time ago strings

Strings such as "_About one hour ago_" or "_~1h_" are localizable. We inherit a set of ready translations from [github.com/andresaraujo/timeago.dart/messages](https://github.com/andresaraujo/timeago.dart/tree/master/timeago/lib/src/messages) and provide our own in [lib/l10n/timeago](./lib/l10n/timeago).

To contribute time ago strings please send a PR containing a class that implements `timeago.LookupMessages`. Place it under [lib/l10n/timeago](./lib/l10n/timeago) with an appropriate name (locale tag) and finally register it in [main_common.dart](./lib/main_common.dart) in the `_setupTimeago` function. Each locale can have a normal (for example "_About one hour ago_") and a short (for example "_~1h_") variant, there are registered separately.

## Architecture

Liftoff is written in Dart using [Flutter](https://flutter.dev/docs). To communicate with Lemmy instances [lemmy_api_client](https://github.com/liftoff-app/lemmy_api_client) is used.

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

- Be aware that Liftoff supports arbitrary Lemmy instances, don't hardcode instance urls
- Remember that a user is not obligated to be logged in, contributed widgets should handle this case

### Lemmy API

LAC (Lemmy API Client) is used to communicate with Lemmy backends, more information can be found [here](https://github.com/liftoff-app/lemmy_api_client).

### For React developers

If you come from a React background Flutter shouldn't be anything hard to grasp for you.

- Components are called 'widgets' in flutter
- `flutter_hooks` is a React hooks port to flutter. Though you will come to see that `flutter_hooks` are not as powerful
- There is no CSS. You compose your layout with other widgets and style them by passing properties
- There are no functional components, everything needs to be a class
- Creating wrapping widgets is not as nice as in React, there is no `{ ...props }`. In flutter you need to pass each argument one by one
