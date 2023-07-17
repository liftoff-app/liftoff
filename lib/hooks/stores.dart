import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../stores/accounts_store.dart';

AccountsStore useAccountsStore() => useContext().watch<AccountsStore>();
T useAccountsStoreSelect<T>(T selector(AccountsStore store)) =>
    useContext().select<AccountsStore, T>(selector);

V useStore<S extends Store, V>(V Function(S value) selector) {
  final context = useContext();
  final store = context.read<S>();
  final state = useState(selector(store));

  useEffect(() {
    return autorun((_) {
      state.value = selector(store);
    });
  }, []);

  return state.value;
}
