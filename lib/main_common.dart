import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart';

import 'app.dart';
import 'app_config.dart';
import 'l10n/timeago/pl.dart';
import 'pages/log_console/log_console_page_store.dart';
import 'stores/accounts_store.dart';
import 'stores/config_store.dart';
import 'util/mobx_provider.dart';

Future<void> mainCommon(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();

  final logConsoleStore = LogConsolePageStore();
  final sharedPrefs = await SharedPreferences.getInstance();

  _setupLogger(appConfig, logConsoleStore);
  _setupTimeago();

  final accountsStore = await AccountsStore.load();

  runApp(
    MultiProvider(
      providers: [
        MobxProvider(create: (context) => ConfigStore.load(sharedPrefs)),
        ChangeNotifierProvider.value(value: accountsStore),
        MobxProvider.value(value: logConsoleStore),
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

void _setupTimeago() {
  setLocaleMessages('ar', ArMessages());
  setLocaleMessages('ar_short', ArShortMessages());
  setLocaleMessages('az', AzMessages());
  setLocaleMessages('az_short', AzShortMessages());
  setLocaleMessages('ca', CaMessages());
  setLocaleMessages('ca_short', CaShortMessages());
  setLocaleMessages('cs', CsMessages());
  setLocaleMessages('cs_short', CsShortMessages());
  setLocaleMessages('da', DaMessages());
  setLocaleMessages('da_short', DaShortMessages());
  setLocaleMessages('de', DeMessages());
  setLocaleMessages('de_short', DeShortMessages());
  setLocaleMessages('dv', DvMessages());
  setLocaleMessages('dv_short', DvShortMessages());
  setLocaleMessages('en', EnMessages());
  setLocaleMessages('en_short', EnShortMessages());
  setLocaleMessages('es', EsMessages());
  setLocaleMessages('es_short', EsShortMessages());
  setLocaleMessages('fa', FaMessages());
  setLocaleMessages('fr', FrMessages());
  setLocaleMessages('fr_short', FrShortMessages());
  setLocaleMessages('gr', GrMessages());
  setLocaleMessages('gr_short', GrShortMessages());
  setLocaleMessages('he', HeMessages());
  setLocaleMessages('he_short', HeShortMessages());
  setLocaleMessages('hi', HiMessages());
  setLocaleMessages('hi_short', HiShortMessages());
  setLocaleMessages('id', IdMessages());
  setLocaleMessages('it', ItMessages());
  setLocaleMessages('it_short', ItShortMessages());
  setLocaleMessages('ja', JaMessages());
  setLocaleMessages('km', KmMessages());
  setLocaleMessages('km_short', KmShortMessages());
  setLocaleMessages('ko', KoMessages());
  setLocaleMessages('ku', KuMessages());
  setLocaleMessages('ku_short', KuShortMessages());
  setLocaleMessages('mn', MnMessages());
  setLocaleMessages('mn_short', MnShortMessages());
  setLocaleMessages('nl', NlMessages());
  setLocaleMessages('nl_short', NlShortMessages());
  setLocaleMessages('pl', PlMessages());
  setLocaleMessages('pl_short', PlShortMessages());
  setLocaleMessages('ro', RoMessages());
  setLocaleMessages('ro_short', RoShortMessages());
  setLocaleMessages('ru', RuMessages());
  setLocaleMessages('ru_short', RuShortMessages());
  setLocaleMessages('rw', RwMessages());
  setLocaleMessages('rw_short', RwShortMessages());
  setLocaleMessages('sv', SvMessages());
  setLocaleMessages('sv_short', SvShortMessages());
  setLocaleMessages('ta', TaMessages());
  setLocaleMessages('th', ThMessages());
  setLocaleMessages('th_short', ThShortMessages());
  setLocaleMessages('tr', TrMessages());
  setLocaleMessages('uk', UkMessages());
  setLocaleMessages('uk_short', UkShortMessages());
  setLocaleMessages('vi', ViMessages());
  setLocaleMessages('vi_short', ViShortMessages());
  setLocaleMessages('zh', ZhMessages());
  setLocaleMessages('ms-MY', MsMyMessages());
  setLocaleMessages('ms-MY_short', MsMyShortMessages());
  setLocaleMessages('nb-NO', NbNoMessages());
  setLocaleMessages('nb-NO_short', NbNoShortMessages());
  setLocaleMessages('nn-NO', NnNoMessages());
  setLocaleMessages('nn-NO_short', NnNoShortMessages());
  setLocaleMessages('pt-BR', PtBrMessages());
  setLocaleMessages('pt-BR_short', PtBrShortMessages());
  setLocaleMessages('zh-CN', ZhCnMessages());
}
