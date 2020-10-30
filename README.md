# lemmur

[![](https://github.com/krawieck/lemmur/workflows/ci/badge.svg)](https://github.com/krawieck/lemmur/actions)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)

A lemmy mobile client

- [lemmur](#lemmur)
  - [Build from source](#build-from-source)
    - [Prerequisites](#prerequisites)
    - [Android](#android)
    - [Linux](#linux)
    - [Windows](#windows)

## Build from source

### Prerequisites

- Install [flutter](https://flutter.dev/docs/get-started/install): To check if this step was successful run `flutter doctor` (Installing android studio is not required if you setup the android SDK yourself)
- Clone this repo: `git clone https://github.com/krawieck/lemmur`
- Enter the repo: `cd lemmur`

### Android

1. Build: `flutter build apk`

The apk will be in `build/app/outputs/flutter-apk/app-release.apk`

### Linux

1. Make sure you have the additional [linux requirements](https://flutter.dev/desktop#additional-linux-requirements) (verify with `flutter doctor`)
2. Switch to dev channel of flutter:
   ```sh
   flutter channel dev
   flutter upgrade
   flutter config --enable-linux-desktop
   ```
3. Build: `flutter build linux`

The executable will be in `build/linux/release/bundle/lemmur` (be aware, however, that this executable is not standalone)

### Windows

1. Make sure you have the additional [windows requirements](https://flutter.dev/desktop#additional-windows-requirements) (verify with `flutter doctor`)
2. Switch to dev channel of flutter:
   ```sh
   flutter channel dev
   flutter upgrade
   flutter config --enable-windows-desktop
   ```
3. Build: `flutter build windows`

The executable will be in `build\windows\runner\Release\lemmur.exe` (be aware, however, that this executable is not standalone)
