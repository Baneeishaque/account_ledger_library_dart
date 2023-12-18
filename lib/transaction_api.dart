import 'dart:convert';

import 'package:account_ledger_library/modals/accounts_url_with_execution_status_modal.dart';
import 'package:account_ledger_library/utils/account_ledger_kotlin_cli_utils.dart';
import 'package:integer/integer.dart';

import 'common_utils/date_time_utils.dart';
import 'modals/account_ledger_api_result_message_modal.dart';
import 'modals/accounts_with_execution_status_modal.dart';
import 'modals/transaction_modal.dart';

//1->2
String runAccountLedgerInsertTransactionOperation(
  TransactionModal transaction,
) {
  return runAccountLedgerKotlinCliOperation(
      getInsertTransactionArguments(transaction));
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

AccountsWithExecutionStatusModal runAccountLedgerGetAccountsOperation(
    [u32? userId]) {
  return AccountsWithExecutionStatusModal.fromJson(jsonDecode(
      runAccountLedgerOperationWithUserId(
          ([userId]) => getGetAccountsArguments(userId), userId)));
}

AccountsUrlWithExecutionStatusModal runAccountLedgerGetAccountsUrlOperation(
    [u32? userId]) {
  return AccountsUrlWithExecutionStatusModal.fromJson(jsonDecode(
      runAccountLedgerOperationWithUserId(
          ([userId]) => getGetAccountsUrlArguments(userId), userId)));
}

String runAccountLedgerOperationWithUserId(
    List<String> Function([u32? userId]) getOperationArgumentsWithUserId,
    [u32? userId]) {
  return runAccountLedgerKotlinCliOperation(
      getOperationArgumentsWithUserId(userId));
}

List<String> getGetAccountsArguments([u32? userId]) {
  if (userId == null) {
    return getOperationArgumentsWithUserId("GetAccounts");
  } else {
    return getOperationArgumentsWithUserId("GetAccounts", userId);
  }
}

List<String> getGetAccountsUrlArguments([u32? userId]) {
  if (userId == null) {
    return getOperationArgumentsWithUserId("GetAccountsUrl");
  } else {
    return getOperationArgumentsWithUserId("GetAccountsUrl", userId);
  }
}

List<String> getOperationArgumentsWithUserId(String operation, [u32? userId]) {
  if (userId == null) {
    return [
      operation,
    ];
  } else {
    return [
      operation,
      userId.toString(),
    ];
  }
}

//1->2 With Time+5 Minutes on Success
AccountLedgerApiResultMessageModal
    runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
  TransactionModal transaction,
) {
  AccountLedgerApiResultStatusModal accountLedgerApiResultStatus =
      AccountLedgerApiResultStatusModal.fromJson(jsonDecode(
          runAccountLedgerKotlinCliOperation(
              getInsertTransactionArguments(transaction))));

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
AccountLedgerApiResultMessageModal
    runAccountLedgerInsertTwoWayTransactionOperationAsync(
  TransactionModal transaction,
  String secondParticulars,
  double secondAmount,
) {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModal(
                transaction.userId,
                accountLedgerApiResultMessage.newDateTime,
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
AccountLedgerApiResultMessageModal
    runAccountLedgerInsertOneTwoThreeOneTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  String secondParticulars,
  double secondAmount,
) {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModal(
                transaction.userId,
                accountLedgerApiResultMessage.newDateTime,
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
AccountLedgerApiResultMessageModal
    runAccountLedgerInsertOneTwoTwoThreeTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  String secondParticulars,
  double secondAmount,
) {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    return (runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
      TransactionModal(
        transaction.userId,
        accountLedgerApiResultMessage.newDateTime,
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
AccountLedgerApiResultMessageModal
    runAccountLedgerInsertOneTwoTwoThreeThreeFourTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
) {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModal(
                transaction.userId,
                accountLedgerApiResultMessage.newDateTime,
                secondParticulars,
                secondAmount,
                transaction.toAccountId,
                party3AccountId));
    if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status ==
        0) {
      accountLedgerApiResultMessage =
          runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
              TransactionModal(
                  transaction.userId,
                  accountLedgerApiResultMessage.newDateTime,
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
AccountLedgerApiResultMessageModal
    runAccountLedgerInsertOneTwoTwoThreeFourOneTransactionOperationAsync(
  TransactionModal transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
) {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModal(
                transaction.userId,
                accountLedgerApiResultMessage.newDateTime,
                secondParticulars,
                secondAmount,
                transaction.toAccountId,
                party3AccountId));
    if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status ==
        0) {
      accountLedgerApiResultMessage =
          runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
              TransactionModal(
                  transaction.userId,
                  accountLedgerApiResultMessage.newDateTime,
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
AccountLedgerApiResultMessageModal
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
) {
  AccountLedgerApiResultMessageModal accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModal(
                transaction.userId,
                accountLedgerApiResultMessage.newDateTime,
                secondParticulars,
                secondAmount,
                transaction.toAccountId,
                party3AccountId));
    if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status ==
        0) {
      accountLedgerApiResultMessage =
          runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
              TransactionModal(
                  transaction.userId,
                  accountLedgerApiResultMessage.newDateTime,
                  thirdParticulars,
                  thirdAmount,
                  party3AccountId,
                  party4AccountId));
      if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status ==
          0) {
        accountLedgerApiResultMessage =
            runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
                TransactionModal(
                    transaction.userId,
                    accountLedgerApiResultMessage.newDateTime,
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
