import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'app_config.dart';
import 'pages/log_console_page/log_console_page_store.dart';
import 'stores/accounts_store.dart';
import 'stores/config_store.dart';

Future<void> mainCommon(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();

  final logConsoleStore = LogConsolePageStore();

  _setupLogger(appConfig, logConsoleStore);

  final configStore = await ConfigStore.load();
  final accountsStore = await AccountsStore.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: configStore),
        ChangeNotifierProvider.value(value: accountsStore),
        Provider.value(value: logConsoleStore),
      ],
      child: const MyApp(),
    ),
  );
}

void _setupLogger(AppConfig appConfig, LogConsolePageStore logConsoleStore) {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((logRecord) {
    // ignore: avoid_print
    print(logRecord);
    logConsoleStore.addLog(logRecord);
  });

  final flutterErrorLogger = Logger('FlutterError');

  FlutterError.onError = (details) {
    if (appConfig.debugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      flutterErrorLogger.warning(
        details.summary.name,
        details.exception,
        details.stack,
      );
    }
  };
}
