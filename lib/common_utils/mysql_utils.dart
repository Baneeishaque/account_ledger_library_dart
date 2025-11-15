import 'package:intl/intl.dart';

import 'date_time_utils.dart';

DateFormat mysqlDateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

String normalDateTimeTextToMySqlDateTimeText(String normalDateTimeText) {
  return mysqlDateTimeFormat.format(
    normalDateTimeFormat.parse(normalDateTimeText),
  );
}
