import 'dart:convert';
import 'dart:io';

import 'package:integer/integer.dart';

import 'constants.dart';
import 'common_utils/date_time_utils.dart';
import 'modals/account_ledger_api_result_message_modal.dart';
import 'modals/accounts_with_execution_status_modal.dart';
import 'modals/transaction_modal.dart';

var executionEnvironment = {
  "JAVA_HOME": r"C:\Users\dk\.jabba\jdk\openjdk@20.0.1",
};

//1->2
String runAccountLedgerInsertTransactionOperation(
  TransactionModal transaction,
) {
  return (Process.runSync(
    accountLedgerCliExecutable,
    getInsertTransactionArguments(transaction),
    environment: executionEnvironment,
  )).stdout;
}

List<String> getInsertTransactionArguments(TransactionModal transaction) {
  return [
    "InsertTransaction",
    transaction.userId.toString(),
    transaction.eventDateTime,
    transaction.particulars,
    transaction.amount.abs().toString(),
    transaction.fromAccountId.toString(),
    transaction.toAccountId.toString()
  ];
}

String runAccountLedgerGetAccountsOperation(
  u32 userId,
) {
  return (Process.runSync(
    accountLedgerCliExecutable,
    getGetAccountsArguments(userId),
    environment: executionEnvironment,
  )).stdout;
}

List<String> getGetAccountsArguments(u32 userId) {
  return [
    "GetAccounts",
    userId.toString(),
  ];
}

Future<AccountsWithExecutionStatusModal> runAccountLedgerGetAccountsOperationAsync(
  u32 userId,
) async {
  return AccountsWithExecutionStatusModal.fromJson(jsonDecode((await Process.run(
    accountLedgerCliExecutable,
    getGetAccountsArguments(userId),
    environment: executionEnvironment,
  ))
      .stdout));
}

//1->2
Future<AccountLedgerApiResultMessageModal>
    runAccountLedgerInsertTransactionOperationAsync(
  TransactionModal transaction,
) async {
  AccountLedgerApiResultStatusModal accountLedgerApiResultStatus =
      AccountLedgerApiResultStatusModal.fromJson(
    jsonDecode(
      (await Process.run(
        accountLedgerCliExecutable,
        getInsertTransactionArguments(transaction),
        environment: executionEnvironment,
      ))
          .stdout,
    ),
  );

  if (accountLedgerApiResultStatus.status == 0) {
    return AccountLedgerApiResultMessageModal(
      normalDateTimeFormat.format(
        normalDateTimeFormat
            .parse(transaction.eventDateTime)
            .add(Duration(minutes: 5)),
      ),
      accountLedgerApiResultStatus = accountLedgerApiResultStatus,
    );
  } else {
    return AccountLedgerApiResultMessageModal(
      transaction.eventDateTime,
      accountLedgerApiResultStatus = accountLedgerApiResultStatus,
    );
  }
}

//1->2, 2->1
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

//1->2, 3->1
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

//1->2, 2->3
Future<AccountLedgerApiResultMessageModal>
    runAccountLedgerInsertOneTwoTwoThreeTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  String secondParticulars,
  double secondAmount,
) async {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationAsync(transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus!.status == 0) {
    return (await runAccountLedgerInsertTransactionOperationAsync(
      TransactionModal(
        transaction.userId,
        accountLedgerApiResultMessage.newDateTime!,
        secondParticulars,
        secondAmount,
        transaction.toAccountId,
        party3AccountId,
      ),
    ));
  } else {
    return accountLedgerApiResultMessage;
  }
}

//1 -> 2, 2 -> 3, 3 -> 4
Future<AccountLedgerApiResultMessageModal>
    runAccountLedgerInsertOneTwoTwoThreeThreeFourTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
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
            party3AccountId));
    if (accountLedgerApiResultMessage.accountLedgerApiResultStatus!.status ==
        0) {
      accountLedgerApiResultMessage =
          await runAccountLedgerInsertTransactionOperationAsync(
              TransactionModal(
                  transaction.userId,
                  accountLedgerApiResultMessage.newDateTime!,
                  thirdParticulars,
                  thirdAmount,
                  party3AccountId,
                  party4AccountId));

      return accountLedgerApiResultMessage;
    } else {
      return accountLedgerApiResultMessage;
    }
  } else {
    return accountLedgerApiResultMessage;
  }
}

//1 -> 2, 2 -> 3, 4 -> 1
Future<AccountLedgerApiResultMessageModal>
    runAccountLedgerInsertOneTwoTwoThreeFourOneTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
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
            party3AccountId));
    if (accountLedgerApiResultMessage.accountLedgerApiResultStatus!.status ==
        0) {
      accountLedgerApiResultMessage =
          await runAccountLedgerInsertTransactionOperationAsync(
              TransactionModal(
                  transaction.userId,
                  accountLedgerApiResultMessage.newDateTime!,
                  thirdParticulars,
                  thirdAmount,
                  party4AccountId,
                  transaction.fromAccountId));

      return accountLedgerApiResultMessage;
    } else {
      return accountLedgerApiResultMessage;
    }
  } else {
    return accountLedgerApiResultMessage;
  }
}

//1 -> 2, 2 -> 3, 3 -> 4, 4 -> 1
Future<AccountLedgerApiResultMessageModal>
    runAccountLedgerInsertOneTwoTwoThreeThreeFourFourOneTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
  String fourthParticulars,
  double fourthAmount,
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
            party3AccountId));
    if (accountLedgerApiResultMessage.accountLedgerApiResultStatus!.status ==
        0) {
      accountLedgerApiResultMessage =
          await runAccountLedgerInsertTransactionOperationAsync(
              TransactionModal(
                  transaction.userId,
                  accountLedgerApiResultMessage.newDateTime!,
                  thirdParticulars,
                  thirdAmount,
                  party3AccountId,
                  party4AccountId));
      if (accountLedgerApiResultMessage.accountLedgerApiResultStatus!.status ==
          0) {
        accountLedgerApiResultMessage =
            await runAccountLedgerInsertTransactionOperationAsync(
                TransactionModal(
                    transaction.userId,
                    accountLedgerApiResultMessage.newDateTime!,
                    fourthParticulars,
                    fourthAmount,
                    party4AccountId,
                    transaction.fromAccountId));
        return accountLedgerApiResultMessage;
      } else {
        return accountLedgerApiResultMessage;
      }
    } else {
      return accountLedgerApiResultMessage;
    }
  } else {
    return accountLedgerApiResultMessage;
  }
}
