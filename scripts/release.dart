import 'dart:io';

Future<void> main(List<String> args) async {
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

  final newVersion = '$major.$minor.$patch+$code';

  confirm('Version looks good? $newVersion');

  final updatedPubspec = pubspecContents.replaceFirst(
      versionMatch.group(0), 'version: $newVersion');

  await pubspecFile.writeAsString(updatedPubspec);
}

void confirm(String message) {
  print('$message [y/n]');

  switch (stdin.readLineSync()) {
    case 'y':
    case 'yes':
      break;
    default:
      print('Exiting');
      exit(1);
  }
}
