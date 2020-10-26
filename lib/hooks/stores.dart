import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../stores/accounts_store.dart';
import '../stores/config_store.dart';

AccountsStore useAccountsStore() => useContext().watch<AccountsStore>();
T useAccountsStoreSelect<T>(T selector(AccountsStore store)) =>
    useContext().select<AccountsStore, T>(selector);

ConfigStore useConfigStore() => useContext().watch<ConfigStore>();
T useConfigStoreSelect<T>(T selector(ConfigStore store)) =>
    useContext().select<ConfigStore, T>(selector);
