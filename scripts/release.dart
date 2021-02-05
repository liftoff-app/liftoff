import 'dart:io';

Future<void> main(List<String> args) async {
  await assertNoStagedGit();

  if (args.isEmpty || !{'patch', 'minor', 'major'}.contains(args[0])) {
    print('Unknown version bump type');
    exit(1);
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
    print('You have staged files, commit or unstage them.');
    exit(1);
  }
}

class Version {
  int major, minor, patch, code;
  String toString() => '$major.$minor.$patch+$code';
  String toStringNoCode() => '$major.$minor.$patch';
}

Future<Version> bumpedVersion(String versionBumpType) async {
  final pubspecFile = File('pubspec.yaml');
  final pubspecContents = await pubspecFile.readAsString();

  final versionMatch = RegExp(r'version: (\d+)\.(\d+)\.(\d+)\+(\d+)')
      .firstMatch(pubspecContents);

  var major = int.parse(versionMatch.group(1));
  var minor = int.parse(versionMatch.group(2));
  var patch = int.parse(versionMatch.group(3));
  var code = int.parse(versionMatch.group(4));

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

  return Version()
    ..major = major
    ..minor = minor
    ..patch = patch
    ..code = code;
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

void confirm(String message) {
  stdout.write('$message [y/n] ');

  switch (stdin.readLineSync()) {
    case 'y':
    case 'yes':
      break;
    default:
      print('Exiting');
      exit(1);
  }
}
