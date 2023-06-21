# ⚠️ THIS PROJECT IS NOT MAINTAINED ANYMORE ⚠️

This project has been officially dropped due to lack of interest and political differences. If anyone is interested in continuing developement, feel free to fork it. For any questions you can message [krawieck](https://matrix.to/#/@krawieck:matrix.org) (who was responsible for the flutter app) or [shilangyu](https://matrix.to/#/@shilangyu:matrix.org) (who was responsible for lemmy_api_client).

---

<div align="center">

[![](https://github.com/zachatrocity/lemmynade/workflows/ci/badge.svg)](https://github.com/zachatrocity/lemmynade/actions)
[![Translation status](http://weblate.yerbamate.ml/widgets/lemmynade/-/lemmynade/svg-badge.svg)](http://weblate.yerbamate.ml/engage/lemmynade/)

<img width=200px height=200px src="https://raw.githubusercontent.com/LemmynadeOrg/lemmynade/master/assets/readme_icon.svg"/>

# lemmynade

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="80">](https://f-droid.org/packages/com.LemmynadeOrg.lemmynade)
[<img src="https://cdn.rawgit.com/steverichey/google-play-badge-svg/master/img/en_get.svg" height="80">](https://play.google.com/store/apps/details?id=com.LemmynadeOrg.lemmynade)
[<img src="https://raw.githubusercontent.com/andOTP/andOTP/master/assets/badges/get-it-on-github.png" height="80">](https://github.com/zachatrocity/lemmynade/releases/latest)

A mobile client for [Lemmy](https://github.com/LemmyNet/lemmy) - a federated reddit alternative

<a href=https://www.buymeacoffee.com/zachatrocity" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

</div>

- [lemmynade](#lemmynade)
  - [Build from source](#build-from-source)
    - [Prerequisites](#prerequisites)
    - [Android](#android)
    - [Linux](#linux)
    - [Windows](#windows)
  - [FAQ](#faq)
    - [Version x.x.x was released, why is it not yet on F-droid?](#version-xxx-was-released-why-is-it-not-yet-on-f-droid)
    - ["App not installed" - what to do?](#app-not-installed---what-to-do)


# Contributing
Please consider contributing! Even if you don't know flutter well use this as a chance to learn! [Contributing Guide](https://github.com/zachatrocity/lemmynade/CONTRIBUTING.md)

## Build from source

### Prerequisites

- Install [flutter](https://flutter.dev/docs/get-started/install): To check if this step was successful run `flutter doctor` (Installing android studio is not required if you setup the android SDK yourself)
- Clone this repo: `git clone https://github.com/zachatrocity/lemmynade`
- Enter the repo: `cd lemmynade`

### Android

1. Build: `flutter build apk --flavor prod --target lib/main_prod.dart --release`

The apk will be in `build/app/outputs/flutter-apk/app-prod-release.apk`

### Linux

1. Make sure you have the additional [linux requirements](https://flutter.dev/desktop#additional-linux-requirements) (verify with `flutter doctor`)
2. Build: `flutter build linux --target lib/main_prod.dart --release`

The executable will be in `build/linux/x64/release/bundle/lemmynade` (be aware, however, that this executable is not standalone)

### Windows

1. Make sure you have the additional [windows requirements](https://flutter.dev/desktop#additional-windows-requirements) (verify with `flutter doctor`)
2. Build: `flutter build windows --target lib/main_prod.dart --release`

The executable will be in `build\windows\runner\Release\lemmynade.exe` (be aware, however, that this executable is not standalone)

## FAQ

### Version x.x.x was released, why is it not yet on F-droid?

We have no control over F-droid's build process. This process is automatic and not always predictable in terms of time it takes. If a new version does not appear in F-droid a week after its release, then feel free to open an issue about it and we will look into it.

### "App not installed" - what to do?

When installing the APK directly you might get this message. This happens when you are trying to update lemmynade from a different source than where you originally got it from. To fix it simply uninstall the previous version (you will lose all local data) and then install the new one. Always make sure to install lemmynade APKs only from verified sources.
