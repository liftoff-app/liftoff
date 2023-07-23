<div align="center">

[![](https://github.com/liftoff-app/liftoff/workflows/ci/badge.svg)](https://github.com/liftoff-app/liftoff/actions)

[![Chat on Matrix](https://matrix.to/img/matrix-badge.svg)](https://matrix.to/#/#liftoff-dev:matrix.org)
<!--
[![Translation status](http://weblate.yerbamate.ml/widgets/liftoff/-/liftoff/svg-badge.svg)](http://weblate.yerbamate.ml/engage/liftoff/)
-->

<img width=200px height=200px src="https://raw.githubusercontent.com/liftoff-app/liftoff/master/assets/app_icon.svg"/>

# Liftoff!

<!--
[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="80">](https://f-droid.org/packages/com.LiftoffOrg.liftoff)
-->
[<img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroid.png" alt="Get it on IzzyOnDroid" height="80">](https://apt.izzysoft.de/fdroid/index/apk/com.liftoffapp.liftoff)
[<img src="https://cdn.rawgit.com/steverichey/google-play-badge-svg/master/img/en_get.svg" height="80">](https://play.google.com/store/apps/details?id=com.liftoffapp.liftoff&pli=1)
[<img src="https://raw.githubusercontent.com/liftoff-app/liftoff/master/assets/download-on-app-store.svg" height="80">](https://apps.apple.com/gb/app/liftoff/id6450716376)
[<img src="https://raw.githubusercontent.com/andOTP/andOTP/master/assets/badges/get-it-on-github.png" height="80">](https://github.com/liftoff-app/liftoff/releases/latest)

A mobile client for [Lemmy](https://github.com/LemmyNet/lemmy) - a federated reddit alternative
</div>

## Screenshots

| Card View     | Compact       | Search         |
| ------------- | ------------- |  ------------- |
| ![109962ec-2859-4744-9941-4aad016b1a4a](https://github.com/liftoff-app/liftoff/assets/6200670/58298508-155b-431e-9538-ead6790a7a20)  |  ![b34bd59e-8097-416f-8fc0-5dcd980a1e1d](https://github.com/liftoff-app/liftoff/assets/6200670/132d9e10-15b2-4f4e-abd4-bcf8e6de8fab)  | ![7788ed7b-2054-4b93-afbf-dda3fe80c2e8](https://github.com/liftoff-app/liftoff/assets/6200670/e69ebc63-958e-4c1f-b496-df650c09c8c4)  |

- [Liftoff!](#liftoff)
  - [Screenshots](#screenshots)
- [Contributing](#contributing)
  - [Build from source](#build-from-source)
    - [Prerequisites](#prerequisites)
    - [iOS](#ios)
    - [Android](#android)
    - [Linux](#linux)
    - [Windows](#windows)
  - [FAQ](#faq)
    - [Version x.x.x was released, why is it not yet on F-droid?](#version-xxx-was-released-why-is-it-not-yet-on-f-droid)
    - ["App not installed" - what to do?](#app-not-installed---what-to-do)
- [What is your privacy policy?](#what-is-your-privacy-policy)
- [End User Code of Conduct](#end-user-code-of-conduct)

# Contributing

Please consider contributing! Even if you don't know flutter well use this as a chance to learn! [Contributing Guide](CONTRIBUTING.md)

Join us on the matrix for support in contributions! [#liftoff-dev:matrix.org](https://matrix.to/#/#liftoff-dev:matrix.org)

## Build from source

### Prerequisites

- Install [flutter](https://flutter.dev/docs/get-started/install): To check if this step was successful run `flutter doctor` (Installing android studio is not required if you setup the android SDK yourself)
- Clone this repo: `git clone https://github.com/liftoff-app/liftoff`
- Enter the repo: `cd liftoff`

### iOS

Visual Studio Code build configurations are provided for development testing.

For final release, run:

1. `flutter build ipa --flavor prod`

The .api will be in `build/ios/ipa`

### Android

1. Build: `flutter build apk --flavor prod --target lib/main_prod.dart --release`

The apk will be in `build/app/outputs/flutter-apk/app-prod-release.apk`

### Linux

1. Make sure you have the additional [linux requirements](https://flutter.dev/desktop#additional-linux-requirements) (verify with `flutter doctor`)
2. Build: `flutter build linux --target lib/main_prod.dart --release`

The executable will be in `build/linux/x64/release/bundle/liftoff` (be aware, however, that this executable is not standalone)

### Windows

1. Make sure you have the additional [windows requirements](https://flutter.dev/desktop#additional-windows-requirements) (verify with `flutter doctor`)
2. Build: `flutter build windows --target lib/main_prod.dart --release`

The executable will be in `build\windows\runner\Release\liftoff.exe` (be aware, however, that this executable is not standalone)

## FAQ

### Version x.x.x was released, why is it not yet on F-droid?

We have no control over F-droid's build process. This process is automatic and not always predictable in terms of time it takes. If a new version does not appear in F-droid a week after its release, then feel free to open an issue about it and we will look into it.

### "App not installed" - what to do?

When installing the APK directly you might get this message. This happens when you are trying to update liftoff from a different source than where you originally got it from. To fix it simply uninstall the previous version (you will lose all local data) and then install the new one. Always make sure to install liftoff APKs only from verified sources.

# What is your privacy policy?

As stated in our [Privacy Policy statement](PRIVACY_POLICY.md), we don't have access to any of your personal data or usage information from your device.

# End User Code of Conduct

We want Liftoff! to be a great way of interacting with the Lemmy network in a safe manner, so end-users of the packages that we produce and distribute are required to read and follow our [End User Code of Conduct](CODE_OF_CONDUCT.md).