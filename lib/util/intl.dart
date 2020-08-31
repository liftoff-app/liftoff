import 'package:intl/intl.dart';

String pluralS(int howMany) => howMany == 1 ? '' : 's';

String compactNumber(int number) => NumberFormat.compact().format(number);
