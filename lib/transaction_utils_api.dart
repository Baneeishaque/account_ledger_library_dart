import 'dart:convert';
import 'dart:io';

import 'account_ledger_api_result_status_modal.dart';
import 'constants.dart';
import 'transaction_modal.dart';

String runAccountLedgerInsertTransactionOperation(
  TransactionModal transaction,
) {
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

Future<String> runAccountLedgerInsertTransactionOperationAsync(
  TransactionModal transaction,
) async {
  return (await Process.run(
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
  ))
      .stdout;
}

Future<String> runAccountLedgerTwoWayInsertTransactionOperation(
  TransactionModal transaction,
  String secondParticulars,
  double secondAmount,
) async {
  AccountLedgerApiResultStatusModal accountLedgerApiResultStatus = jsonDecode(
      await runAccountLedgerInsertTransactionOperationAsync(transaction));
  if (accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultStatus = jsonDecode(
        await runAccountLedgerInsertTransactionOperationAsync(TransactionModal(
            transaction.userId,
            transaction.eventDateTime,
            secondParticulars,
            secondAmount,
            transaction.toAccountId,
            transaction.fromAccountId)));
    return accountLedgerApiResultStatus.toJson().toString();
  } else {
    return accountLedgerApiResultStatus.toJson().toString();
  }
}
