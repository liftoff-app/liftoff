import 'dart:io';

Future<void> main(List<String> args) async {
  final res =
      await Process.run('git', ['diff-index', '--cached', '--quiet', 'HEAD']);
  if (res.exitCode != 0) {
    print('You have staged files, commit or unstage them.');
    exit(1);
  }

  if (args.isEmpty || !{'patch', 'minor', 'major'}.contains(args[0])) {
    print('Unknown version bump type');
    exit(1);
  }

  final pubspecFile = File('pubspec.yaml');
  final pubspecContents = await pubspecFile.readAsString();

  final versionMatch = RegExp(r'version: (\d+)\.(\d+)\.(\d+)\+(\d+)')
      .firstMatch(pubspecContents);

  var major = int.parse(versionMatch.group(1));
  var minor = int.parse(versionMatch.group(2));
  var patch = int.parse(versionMatch.group(3));
  var code = int.parse(versionMatch.group(4));

  switch (args[0]) {
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

  final newVersionName = '$major.$minor.$patch';
  final newVersionString = '$newVersionName+$code';

  confirm('Version looks good? $newVersionString');
  final updatedPubspec = pubspecContents.replaceFirst(
      versionMatch.group(0), 'version: $newVersionString');
  await pubspecFile.writeAsString(updatedPubspec);

  final changelogFile = File('CHANGELOG.md');
  final changelogContents = await changelogFile.readAsString();

  var thisChangelog =
      RegExp(r'^## Unreleased$.+?^##[^#]', multiLine: true, dotAll: true)
          .stringMatch(changelogContents);
  thisChangelog = thisChangelog.substring(0, thisChangelog.length - 4);

  final date = DateTime.now();
  final dateString =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  thisChangelog = thisChangelog.replaceFirst(
      'Unreleased', 'v$newVersionName - $dateString');
  confirm('Changelog looks good?\n$thisChangelog\n');

  await changelogFile.writeAsString(changelogContents.replaceFirst(
      'Unreleased', 'v$newVersionName - $dateString'));

  await File('fastlane/metadata/android/en-US/changelogs/$code.txt')
      .writeAsString(thisChangelog.split('\n').skip(2).join('\n'));

  stdout.write('Running git tag... ');
  await Process.run('git', ['tag', 'v$newVersionName']);
  print('done');

  stdout.write('Running git add... ');
  await Process.run('git', [
    'add',
    'CHANGELOG.md',
    'pubspec.yaml',
    'fastlane/metadata/android/en-US/changelogs/$code.txt'
  ]);
  print('done');

  print(
      'Review your staged files, commit them with a message of "Release v$newVersionName" push it and finish off with `git push --tags`');
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
