// ignore_for_file: avoid_print
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

Never printError(String message) {
  stderr.writeln('\x1B[31m$message\x1B[0m');

  exit(1);
}
