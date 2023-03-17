import 'package:integer/integer.dart';

class TransactionModal {
  u32 userId;
  String eventDateTime;
  String particulars;
  double amount;
  u32 fromAccountId;
  u32 toAccountId;

  TransactionModal(
    this.userId,
    this.eventDateTime,
    this.particulars,
    this.amount,
    this.fromAccountId,
    this.toAccountId,
  );

  @override
  String toString() {
    return 'Transaction{userId: $userId, eventDateTime: $eventDateTime, particulars: $particulars, amount: $amount, fromAccountId: $fromAccountId, toAccountId: $toAccountId}';
  }
}
