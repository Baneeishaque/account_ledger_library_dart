import 'dart:io';

import 'constants.dart';
import 'transaction_modal.dart';

void insertTransactionViaApi(TransactionModal transaction) {
  // print(transaction.toString());
  print(runAccountLedgerInsertTransactionOperation(transaction));
}

String runAccountLedgerInsertTransactionOperation(
    TransactionModal transaction) {
  return (Process.runSync(
    accountLedgerCliExecutable,
    [
      "InsertTransaction",
      transaction.userId.toString(),
      transaction.eventDateTime,
      transaction.particulars,
      transaction.amount.toString(),
      transaction.fromAccountId.toString(),
      transaction.toAccountId.toString()
    ],
    environment: {"JAVA_HOME": r"C:\Users\dk\.jabba\jdk\19.0.2"},
  )).stdout;
}
