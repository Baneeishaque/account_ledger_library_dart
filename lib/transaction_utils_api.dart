import 'dart:convert';
import 'dart:io';

import 'package:account_ledger_library_dart/account_ledger_api_result_message_modal.dart';
import 'package:integer/integer.dart';

import 'account_ledger_api_result_status_modal.dart';
import 'constants.dart';
import 'date_time_utils.dart';
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
      transaction.amount.abs().toString(),
      transaction.fromAccountId.toString(),
      transaction.toAccountId.toString()
    ],
    environment: {"JAVA_HOME": r"C:\Users\dk\.jabba\jdk\openjdk@20.0.1"},
  )).stdout;
}

Future<AccountLedgerApiResultMessageModal>
    runAccountLedgerInsertTransactionOperationAsync(
  TransactionModal transaction,
) async {
  AccountLedgerApiResultStatusModal accountLedgerApiResultStatus =
      AccountLedgerApiResultStatusModal.fromJson(jsonDecode((await Process.run(
    accountLedgerCliExecutable,
    [
      "InsertTransaction",
      transaction.userId.toString(),
      transaction.eventDateTime,
      transaction.particulars,
      transaction.amount.abs().toString(),
      transaction.fromAccountId.toString(),
      transaction.toAccountId.toString()
    ],
    environment: {"JAVA_HOME": r"C:\Users\dk\.jabba\jdk\openjdk@20.0.1"},
  ))
          .stdout));

  if (accountLedgerApiResultStatus.status == 0) {
    return AccountLedgerApiResultMessageModal(
        normalDateTimeFormat.format(
          normalDateTimeFormat
              .parse(transaction.eventDateTime)
              .add(Duration(minutes: 5)),
        ),
        accountLedgerApiResultStatus = accountLedgerApiResultStatus);
  } else {
    return AccountLedgerApiResultMessageModal(transaction.eventDateTime,
        accountLedgerApiResultStatus = accountLedgerApiResultStatus);
  }
}

Future<AccountLedgerApiResultMessageModal>
    runAccountLedgerInsertTwoWayTransactionOperationAsync(
  TransactionModal transaction,
  String secondParticulars,
  double secondAmount,
) async {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationAsync(transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus!.status == 0) {
    accountLedgerApiResultMessage =
        await runAccountLedgerInsertTransactionOperationAsync(TransactionModal(
            transaction.userId,
            accountLedgerApiResultMessage.newDateTime!,
            secondParticulars,
            secondAmount,
            transaction.toAccountId,
            transaction.fromAccountId));
    return accountLedgerApiResultMessage;
  } else {
    return accountLedgerApiResultMessage;
  }
}

Future<AccountLedgerApiResultMessageModal>
    runAccountLedgerInsertOneTwoThreeOneTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  String secondParticulars,
  double secondAmount,
) async {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationAsync(transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus!.status == 0) {
    accountLedgerApiResultMessage =
        await runAccountLedgerInsertTransactionOperationAsync(TransactionModal(
            transaction.userId,
            accountLedgerApiResultMessage.newDateTime!,
            secondParticulars,
            secondAmount,
            party3AccountId,
            transaction.fromAccountId));
    return accountLedgerApiResultMessage;
  } else {
    return accountLedgerApiResultMessage;
  }
}
