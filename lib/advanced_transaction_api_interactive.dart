import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import 'base_transaction_api_interactive.dart';
import 'common_utils/date_time_utils.dart';
import 'models/transaction_model.dart';

//1 -> 2, 3 -> 1
Future<void> insertOneTwoThreeOneTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 party1accountId,
  u32 party2accountId,
  u32 party3accountId,
) async {
  await insertTransaction(
    TransactionModel(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  await insertNextTransaction(
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

//1->2, 2->3
Future<void> insertOneTwoTwoThreeTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 party1accountId,
  u32 party2accountId,
  u32 party3accountId,
) async {
  await insertTransaction(
    TransactionModel(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  await insertNextTransaction(
    userId,
    normalDateTimeFormat.format(
      normalDateTimeFormat.parse(eventDateTime).add(Duration(minutes: 5)),
    ),
    particulars,
    amount,
    party2accountId,
    party3accountId,
  );
}

//1 -> 2, 2 -> 3, 3 -> 4, 4 -> 1
Future<void> insertOneTwoTwoThreeThreeFourFourOneTransaction(
    u32 userId,
    String eventDateTime,
    String particulars,
    double amount,
    u32 party1accountId,
    u32 party2accountId,
    u32 party3accountId,
    u32 party4accountId) async {
  await insertTransaction(
    TransactionModel(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  Tuple3<String, String, double> insertNextTransactionResult =
      await insertNextTransaction(
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
  amount = insertNextTransactionResult.item3;

  insertNextTransactionResult = await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party3accountId,
    party4accountId,
  );

  eventDateTime = insertNextTransactionResult.item1;
  particulars = insertNextTransactionResult.item2;
  amount = insertNextTransactionResult.item3;

  await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party4accountId,
    party1accountId,
  );
}

//1 -> 2, 2 -> 3, 3 -> 2, 2 -> 4, 4 -> 1
Future<void> insertOneTwoTwoThreeThreeTwoTwoFourFourOneTransaction(
    u32 userId,
    String eventDateTime,
    String particulars,
    double amount,
    u32 party1accountId,
    u32 party2accountId,
    u32 party3accountId,
    u32 party4accountId) async {
  await insertTransaction(
    TransactionModel(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  Tuple3<String, String, double> insertNextTransactionResult =
      await insertNextTransaction(
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
  amount = insertNextTransactionResult.item3;

  insertNextTransactionResult = await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party3accountId,
    party2accountId,
  );

  eventDateTime = insertNextTransactionResult.item1;
  particulars = insertNextTransactionResult.item2;
  amount = insertNextTransactionResult.item3;

  insertNextTransactionResult = await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party2accountId,
    party4accountId,
  );

  eventDateTime = insertNextTransactionResult.item1;
  particulars = insertNextTransactionResult.item2;
  amount = insertNextTransactionResult.item3;

  await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party4accountId,
    party1accountId,
  );
}

//1 -> 2, 2 -> 3, 3 -> 2, 2 -> 4, 4 -> 1, 4 -> 2
Future<void> insertOneTwoTwoThreeThreeTwoTwoFourFourOneFourTwoTransaction(
    u32 userId,
    String eventDateTime,
    String particulars,
    double amount,
    u32 party1accountId,
    u32 party2accountId,
    u32 party3accountId,
    u32 party4accountId) async {
  await insertTransaction(
    TransactionModel(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  Tuple3<String, String, double> insertNextTransactionResult =
      await insertNextTransaction(
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
  amount = insertNextTransactionResult.item3;

  insertNextTransactionResult = await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party3accountId,
    party2accountId,
  );

  eventDateTime = insertNextTransactionResult.item1;
  particulars = insertNextTransactionResult.item2;
  amount = insertNextTransactionResult.item3;

  insertNextTransactionResult = await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party2accountId,
    party4accountId,
  );

  eventDateTime = insertNextTransactionResult.item1;
  particulars = insertNextTransactionResult.item2;
  amount = insertNextTransactionResult.item3;

  insertNextTransactionResult = await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party4accountId,
    party1accountId,
  );

  eventDateTime = insertNextTransactionResult.item1;
  particulars = insertNextTransactionResult.item2;
  amount = insertNextTransactionResult.item3;

  await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party4accountId,
    party2accountId,
  );
}

//1 -> 2, 2 -> 3, 3 -> 4
Future<void> insertOneTwoTwoThreeThreeFourTransaction(
    u32 userId,
    String eventDateTime,
    String particulars,
    double amount,
    u32 party1accountId,
    u32 party2accountId,
    u32 party3accountId,
    u32 party4accountId) async {
  await insertTransaction(
    TransactionModel(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  Tuple3<String, String, double> insertNextTransactionResult =
      await insertNextTransaction(
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
  amount = insertNextTransactionResult.item3;

  await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party3accountId,
    party4accountId,
  );
}

//1 -> 2, 2 -> 3, 3 -> 1
Future<void> insertOneTwoTwoThreeThreeOneTransaction(
    u32 userId,
    String eventDateTime,
    String particulars,
    double amount,
    u32 party1accountId,
    u32 party2accountId,
    u32 party3accountId) async {
  await insertTransaction(
    TransactionModel(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );

  Tuple3<String, String, double> insertNextTransactionResult =
      await insertNextTransaction(
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
  amount = insertNextTransactionResult.item3;

  await insertNextTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party3accountId,
    party1accountId,
  );
}
