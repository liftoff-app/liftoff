import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../stores/accounts_store.dart';
import '../stores/config_store.dart';

AccountsStore useAccountsStore() => useContext().watch<AccountsStore>();
ConfigStore useConfigStore() => useContext().watch<ConfigStore>();
