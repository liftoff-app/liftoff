<div align="center">

[![](https://github.com/LemmurOrg/lemmur/workflows/ci/badge.svg)](https://github.com/LemmurOrg/lemmur/actions)

<img width=200px height=200px src="https://raw.githubusercontent.com/LemmurOrg/lemmur/master/assets/readme_icon.svg"/>

# lemmur

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="80">](https://f-droid.org/packages/com.LemmurOrg.lemmur)
[<img src="https://cdn.rawgit.com/steverichey/google-play-badge-svg/master/img/en_get.svg" height="80">](https://play.google.com/store/apps/details?id=com.LemmurOrg.lemmur)
[<img src="https://raw.githubusercontent.com/andOTP/andOTP/master/assets/badges/get-it-on-github.png" height="80">](https://github.com/LemmurOrg/lemmur/releases/latest)

A mobile client for [Lemmy](https://github.com/LemmyNet/lemmy) - a federated reddit alternative

<a href="https://www.buymeacoffee.com/lemmur" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

</div>

- [lemmur](#lemmur)
  - [Build from source](#build-from-source)
    - [Prerequisites](#prerequisites)
    - [Android](#android)
    - [Linux](#linux)
    - [Windows](#windows)
  - [FAQ](#faq)
    - [Version x.x.x was released, why is it not yet on F-droid?](#version-xxx-was-released-why-is-it-not-yet-on-f-droid)
    - ["App not installed" - what to do?](#app-not-installed---what-to-do)

## Build from source

### Prerequisites

- Install [flutter](https://flutter.dev/docs/get-started/install): To check if this step was successful run `flutter doctor` (Installing android studio is not required if you setup the android SDK yourself)
- Clone this repo: `git clone https://github.com/LemmurOrg/lemmur`
- Enter the repo: `cd lemmur`

### Android

1. Build: `flutter build apk`

The apk will be in `build/app/outputs/flutter-apk/app-release.apk`

### Linux

1. Make sure you have the additional [linux requirements](https://flutter.dev/desktop#additional-linux-requirements) (verify with `flutter doctor`)
2. Enable linux desktop:
   ```sh
   flutter config --enable-linux-desktop
   ```
3. Build: `flutter build linux`

The executable will be in `build/linux/release/bundle/lemmur` (be aware, however, that this executable is not standalone)

### Windows

1. Make sure you have the additional [windows requirements](https://flutter.dev/desktop#additional-windows-requirements) (verify with `flutter doctor`)
2. Enable windows desktop:
   ```sh
   flutter config --enable-windows-desktop
   ```
3. Build: `flutter build windows`

The executable will be in `build\windows\runner\Release\lemmur.exe` (be aware, however, that this executable is not standalone)

## FAQ

### Version x.x.x was released, why is it not yet on F-droid?

We have no control over F-droid's build process. This process is automatic and not always predictable in terms of time it takes. If a new version does not appear in F-droid a week after its release, then feel free to open an issue about it and we will look into it.

### "App not installed" - what to do?

When installing the APK directly you might get this message. This happens when you are trying to update lemmur from a different source than where you originally got it from. To fix it simply uninstall the previous version (you will lose all local data) and then install the new one. Always make sure to install lemmur APKs only from verified sources.
