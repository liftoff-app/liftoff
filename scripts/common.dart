import 'dart:io';

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

void printError(String message, {bool shouldExit = true}) {
  stderr.writeln('\x1B[31m$message\x1B[0m');

  if (shouldExit) exit(1);
}
