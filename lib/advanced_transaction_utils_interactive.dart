
import 'package:account_ledger_library_dart/date_time_utils.dart';
import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import 'base_transaction_utils_interactive.dart';
import 'transaction_modal.dart';

//1 -> 2, 3 -> 1
void insertOneTwoThreeOneTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 party1accountId,
  u32 party2accountId,
  u32 party3accountId,
) {
  insertTransaction(
    TransactionModal(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  insertNextTransaction(
    userId,
    normalDateTimeFormat.format(
      normalDateTimeFormat.parse(eventDateTime).add(Duration(minutes: 5)),
    ),
    particulars,
    amount,
    party3accountId,
    party1accountId,
  );
}

//1 -> 2, 2 -> 3, 3 -> 4, 4 -> 1
void insertOneTwoTwoThreeThreeFourFourOneTransaction(
    u32 userId,
    String eventDateTime,
    String particulars,
    double amount,
    u32 party1accountId,
    u32 party2accountId,
    u32 party3accountId,
    u32 party4accountId) {
  insertTransaction(
    TransactionModal(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  Tuple2<String, String> insertNextTransactionResult = insertNextTransaction(
    userId,
    normalDateTimeFormat.format(
      normalDateTimeFormat.parse(eventDateTime).add(Duration(minutes: 5)),
    ),
    particulars,
    amount,
    party2accountId,
    party3accountId,
  );

  eventDateTime = insertNextTransactionResult.item1;
  particulars = insertNextTransactionResult.item2;

  insertNextTransactionResult = insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party3accountId,
    party4accountId,
  );

  eventDateTime = insertNextTransactionResult.item1;
  particulars = insertNextTransactionResult.item2;

  insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party4accountId,
    party1accountId,
  );
}
