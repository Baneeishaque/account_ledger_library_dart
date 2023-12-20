import 'dart:convert';

import 'package:integer/integer.dart';

import 'common_utils/date_time_utils.dart';
import 'models/account_ledger_api_result_message_model.dart';
import 'models/accounts_url_with_execution_status_model.dart';
import 'models/accounts_with_execution_status_model.dart';
import 'models/transaction_model.dart';
import 'utils/account_ledger_kotlin_cli_utils.dart';

//1->2
String runAccountLedgerInsertTransactionOperation(
  TransactionModel transaction,
) {
  return runAccountLedgerKotlinCliOperation(
      getInsertTransactionArguments(transaction));
}

List<String> getInsertTransactionArguments(TransactionModel transaction) {
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

AccountsWithExecutionStatusModel runAccountLedgerGetAccountsOperation(
    [u32? userId]) {
  return AccountsWithExecutionStatusModel.fromJson(jsonDecode(
      runAccountLedgerOperationWithUserId(
          ([userId]) => getGetAccountsArguments(userId), userId)));
}

AccountsUrlWithExecutionStatusModel runAccountLedgerGetAccountsUrlOperation(
    [u32? userId]) {
  return AccountsUrlWithExecutionStatusModel.fromJson(jsonDecode(
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
AccountLedgerApiResultMessageModel
    runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
  TransactionModel transaction,
) {
  AccountLedgerApiResultStatusModel accountLedgerApiResultStatus =
      AccountLedgerApiResultStatusModel.fromJson(
          jsonDecode(runAccountLedgerInsertTransactionOperation(transaction)));

  if (accountLedgerApiResultStatus.status == 0) {
    return AccountLedgerApiResultMessageModel(
      normalDateTimeFormat.format(
        normalDateTimeFormat
            .parse(transaction.eventDateTime)
            .add(Duration(minutes: 5)),
      ),
      accountLedgerApiResultStatus = accountLedgerApiResultStatus,
    );
  } else {
    return AccountLedgerApiResultMessageModel(
      transaction.eventDateTime,
      accountLedgerApiResultStatus = accountLedgerApiResultStatus,
    );
  }
}

//1->2, 2->1
AccountLedgerApiResultMessageModel
    runAccountLedgerInsertTwoWayTransactionOperation(
  TransactionModel transaction,
  String secondParticulars,
  double secondAmount,
) {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModel(
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
AccountLedgerApiResultMessageModel
    runAccountLedgerInsertOneTwoThreeOneTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  String secondParticulars,
  double secondAmount,
) {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModel(
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
AccountLedgerApiResultMessageModel
    runAccountLedgerInsertOneTwoTwoThreeTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  String secondParticulars,
  double secondAmount,
) {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    return (runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
      TransactionModel(
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
AccountLedgerApiResultMessageModel
    runAccountLedgerInsertOneTwoTwoThreeThreeFourTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
) {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModel(
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
              TransactionModel(
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
AccountLedgerApiResultMessageModel
    runAccountLedgerInsertOneTwoTwoThreeFourOneTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
) {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModel(
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
              TransactionModel(
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
AccountLedgerApiResultMessageModel
    runAccountLedgerInsertOneTwoTwoThreeThreeFourFourOneTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
  String fourthParticulars,
  double fourthAmount,
) {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
            TransactionModel(
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
              TransactionModel(
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
                TransactionModel(
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
