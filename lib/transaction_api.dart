import 'dart:convert';

import 'package:account_ledger_library/common_utils/mysql_utils.dart';
import 'package:account_ledger_library/models/get_accounts_from_server_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:integer/integer.dart';

import 'common_utils/common_utils.dart';
import 'common_utils/date_time_utils.dart';
import 'models/account_ledger_api_result_message_model.dart';
import 'models/accounts_url_with_execution_status_model.dart';
import 'models/accounts_with_execution_status_model.dart';
import 'models/transaction_model.dart';
import 'utils/account_ledger_kotlin_cli_utils.dart';

//1->2
Future<String> runAccountLedgerInsertTransactionOperation(
    TransactionModel transaction,
    {void Function()? beforeOperationActions = dummyFunction}) async {
  return (await http.post(
          Uri.parse('INSERT_TRANSACTION_FULL_URL'),
          body: {
        'user_id': transaction.userId.toString(),
        'event_date_time':
            normalDateTimeTextToMySqlDateTimeText(transaction.eventDateTime),
        'particulars': transaction.particulars,
        'amount': transaction.amount.abs().toString(),
        'from_account_id': transaction.fromAccountId.toString(),
        'to_account_id': transaction.toAccountId.toString(),
      }))
      .body;
}

Future<AccountsWithExecutionStatusModel> runAccountLedgerGetAccountsOperation(
    {u32? userId,
    void Function() actionsBeforeExecution = dummyFunction,
    void Function(String)? actionsAfterExecution}) async {
  http.Response getAccountsFromServerHttpResponse = await http.get(Uri.parse(
      'SELECT_USER_ACCOUNTS_FULL_FULL_URL'));
  if (getAccountsFromServerHttpResponse.statusCode == 200) {
    GetAccountsFromServerResponseModel getAccountsFromServerResponse =
        GetAccountsFromServerResponseModel.fromJson(
            jsonDecode((getAccountsFromServerHttpResponse).body));

    bool isOK = getAccountsFromServerResponse.status == 0;
    return AccountsWithExecutionStatusModel(
        isOK: isOK,
        data: isOK ? getAccountsFromServerResponse.accounts : null,
        error:
            isOK ? null : 'status => ${getAccountsFromServerResponse.status}');
  } else {
    return AccountsWithExecutionStatusModel(
        isOK: false,
        error:
            'HTTP Status Code => ${getAccountsFromServerHttpResponse.statusCode}');
  }
}

AccountsUrlWithExecutionStatusModel runAccountLedgerGetAccountsUrlOperation(
    [u32? userId]) {
  return AccountsUrlWithExecutionStatusModel.fromJson(
      jsonDecode(runAccountLedgerOperationWithUserId(
    ([userId]) => getGetAccountsUrlArguments(userId),
    userId: userId,
  )));
}

String runAccountLedgerOperationWithUserId(
    List<String> Function([u32? userId]) getOperationArgumentsWithUserId,
    {u32? userId,
    void Function() actionsBeforeExecution = dummyFunction,
    void Function(String)? actionsAfterExecution}) {
  return runAccountLedgerKotlinCliOperation(
    getOperationArgumentsWithUserId(userId),
    actionsBeforeExecution: actionsBeforeExecution,
    actionsAfterExecution: actionsAfterExecution,
  );
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
Future<AccountLedgerApiResultMessageModel>
    runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
        TransactionModel transaction,
        {void Function()? beforeOperationActions = dummyFunction}) async {
  AccountLedgerApiResultStatusModel accountLedgerApiResultStatus =
      AccountLedgerApiResultStatusModel.fromJson(jsonDecode(
          await runAccountLedgerInsertTransactionOperation(transaction)));

  if (accountLedgerApiResultStatus.status == 0) {
    return AccountLedgerApiResultMessageModel(
      get5MinutesIncrementedNormalDateTimeTextFromNormalDateTimeText(
          transaction.eventDateTime),
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
Future<AccountLedgerApiResultMessageModel>
    runAccountLedgerInsertTwoWayTransactionOperation(
  TransactionModel transaction,
  String secondParticulars,
  double secondAmount,
) async {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
Future<AccountLedgerApiResultMessageModel>
    runAccountLedgerInsertOneTwoThreeOneTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  String secondParticulars,
  double secondAmount,
) async {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
Future<AccountLedgerApiResultMessageModel>
    runAccountLedgerInsertOneTwoTwoThreeTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  String secondParticulars,
  double secondAmount,
) async {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    return (await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
Future<AccountLedgerApiResultMessageModel>
    runAccountLedgerInsertOneTwoTwoThreeThreeFourTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
) async {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
          await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
Future<AccountLedgerApiResultMessageModel>
    runAccountLedgerInsertOneTwoTwoThreeFourOneTransactionOperation(
  TransactionModel transaction,
  u32 party3AccountId,
  u32 party4AccountId,
  String secondParticulars,
  double secondAmount,
  String thirdParticulars,
  double thirdAmount,
) async {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
          await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
Future<AccountLedgerApiResultMessageModel>
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
) async {
  AccountLedgerApiResultMessageModel accountLedgerApiResultMessage =
      await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          transaction);
  if (accountLedgerApiResultMessage.accountLedgerApiResultStatus.status == 0) {
    accountLedgerApiResultMessage =
        await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
          await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
            await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
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
