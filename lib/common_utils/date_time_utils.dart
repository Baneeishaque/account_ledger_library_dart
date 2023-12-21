import 'package:intl/intl.dart';

DateFormat normalDateTimeFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
DateFormat normalTimeFormat = DateFormat('HH:mm:ss');

String get5MinutesIncrementedNormalDateTimeTextFromNormalDateTimeText(
    String normalDateTimeText) {
  return normalDateTimeFormat.format(
    normalDateTimeFormat.parse(normalDateTimeText).add(Duration(minutes: 5)),
  );
}

String get5MinutesIncrementedNormalTimeTextFromNormalTimeText(
    String normalTimeText) {
  return normalTimeFormat.format(
    normalTimeFormat.parse(normalTimeText).add(Duration(minutes: 5)),
  );
}
