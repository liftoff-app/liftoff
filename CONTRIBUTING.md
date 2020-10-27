# Contributing

...is welcome!

## Issue tracking / Repository

From issues to wikis: everything is on [GitHub](https://github.com/krawieck/lemmur)

## Architecture

Lemmur is written in Dart using [Flutter](https://flutter.dev/docs). To communicate with Lemmy instances [lemmy_api_client](https://github.com/krawieck/lemmy_api_client) is used.

### State management

`ChangeNotifier` + [Provider](https://github.com/rrousselGit/provider) is used for global state management, [flutter_hooks](https://github.com/rrousselGit/flutter_hooks) is used for local (widget-level) state management. `StatefulWidget`s are avoided all together and any state logic reuse is moved to a [custom hook](./lib/hooks).

### Project structure

(relative to `lib/`)

- `hooks/`: reusable state hooks
- `pages/`: fullscreen pages that you navigate to
- `stores/`: global stores
- `util/`: utilities
- `widgets/`: reusable widgets; building blocks for pages
- `main.dart`: entrypoint of the app. Sets up the stores, initializes the themes, renders the first page

### Things to keep in mind

- Be aware that Lemmur supports arbitrary Lemmy instances, don't hardcode instance urls
- Remember that a user is not obligated to be logged in, contributed widgets should handle this case

## Linting / Formatting

Everything is formatted with `dartfmt` (no flags) and linted with `dartanalyzer` ([see rules](analysis_options.yaml)). Both are enforced by the CI.
