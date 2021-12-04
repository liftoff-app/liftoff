// ignore_for_file: avoid_print
/// Used to create a new lemmur release. Bumps semver, build number, updates changelog, fastlane, pubspec, and finishes by adding a git tag
import 'dart:io';

import 'common.dart';

Future<void> main(List<String> args) async {
  await assertNoStagedGit();

  if (args.isEmpty || !{'patch', 'minor', 'major'}.contains(args[0])) {
    printError('Unknown version bump type');
  }

  final version = await bumpedVersion(args[0]);

  await updatePubspec(version);

  await updateChangelog(version);

  await runGitCommands(version);

  print(
      'Before pushing review the changes with `git show`. Once reviewed and pushed, push the new tag with `git push --tags`');
}

Future<void> assertNoStagedGit() async {
  final res =
      await Process.run('git', ['diff-index', '--cached', '--quiet', 'HEAD']);

  if (res.exitCode != 0) {
    printError('You have staged files, commit or unstage them.');
  }
}

class Version {
  final int major, minor, patch, code;
  Version(this.major, this.minor, this.patch, this.code);
  @override
  String toString() => '$major.$minor.$patch+$code';
  String toStringNoCode() => '$major.$minor.$patch';
}

Future<Version> bumpedVersion(String versionBumpType) async {
  final pubspecFile = File('pubspec.yaml');
  final pubspecContents = await pubspecFile.readAsString();

  final versionMatch = RegExp(r'version: (\d+)\.(\d+)\.(\d+)\+(\d+)')
      .firstMatch(pubspecContents);

  if (versionMatch == null) {
    printError('Failed to find version in pubspec.yaml');
  }

  var major = int.parse(versionMatch.group(1)!);
  var minor = int.parse(versionMatch.group(2)!);
  var patch = int.parse(versionMatch.group(3)!);
  var code = int.parse(versionMatch.group(4)!);

  switch (versionBumpType) {
    case 'patch':
      patch++;
      break;
    case 'minor':
      patch = 0;
      minor++;
      break;
    case 'major':
      patch = 0;
      minor = 0;
      major++;
      break;
  }
  code++;

  return Version(major, minor, patch, code);
}

Future<void> updatePubspec(Version version) async {
  final pubspecFile = File('pubspec.yaml');
  final pubspecContents = await pubspecFile.readAsString();

  confirm('Version looks good? $version');

  final updatedPubspec =
      pubspecContents.replaceFirst(RegExp('version: .+'), 'version: $version');
  await pubspecFile.writeAsString(updatedPubspec);
}

Future<void> updateChangelog(Version version) async {
  final changelogFile = File('CHANGELOG.md');
  final changelogContents = await changelogFile.readAsString();

  var currentChangelog =
      RegExp(r'^## Unreleased$.+?^##[^#]', multiLine: true, dotAll: true)
          .stringMatch(changelogContents);

  if (currentChangelog == null) {
    printError('No changelog found');
  }

  currentChangelog = currentChangelog.substring(0, currentChangelog.length - 4);

  final date = DateTime.now();
  final dateString =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  currentChangelog = currentChangelog.replaceFirst(
      'Unreleased', 'v${version.toStringNoCode()} - $dateString');

  confirm('Changelog looks good?\n$currentChangelog\n');

  await changelogFile.writeAsString(changelogContents.replaceFirst(
      'Unreleased', 'v${version.toStringNoCode()} - $dateString'));

  await File('fastlane/metadata/android/en-US/changelogs/${version.code}.txt')
      .writeAsString(currentChangelog.split('\n').skip(2).join('\n'));
}

Future<void> runGitCommands(Version version) async {
  stdout.write('Running git add... ');
  await Process.run('git', [
    'add',
    'CHANGELOG.md',
    'pubspec.yaml',
    'fastlane/metadata/android/en-US/changelogs/${version.code}.txt'
  ]);
  print('done');

  stdout.write('Running git commit... ');
  await Process.run(
      'git', ['commit', '-m', 'Release v${version.toStringNoCode()}']);
  print('done');

  stdout.write('Running git tag... ');
  await Process.run('git', ['tag', 'v${version.toStringNoCode()}']);
  print('done');
}
