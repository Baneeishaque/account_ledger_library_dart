import 'dart:convert';

import 'package:dart_extensions_methods/dart_extension_methods.dart';
import 'package:integer/integer.dart';

import 'account_ledger_gist_api.dart';
import 'account_ledger_kotlin_cli_operations.dart';
import 'common_utils/date_time_utils.dart';
import 'common_utils/input_utils.dart';
import 'common_utils/input_utils_interactive.dart';
import 'common_utils/u32_utils.dart';
import 'models/account_ledger_api_result_message_model.dart';
import 'models/account_ledger_gist_model_v2.dart';
import 'models/account_ledger_gist_verification_result_model.dart';
import 'models/accounts_with_execution_status_model.dart';
import 'models/relation_of_accounts_model.dart';
import 'models/transaction_model.dart';
import 'relations_of_accounts_operations.dart';
import 'transaction_api.dart';
import 'utils/account_utils_interactive.dart';

late List<AccountHeadModel> _accountHeads;

bool verifyAccountLedgerGistInteractive({
  AccountLedgerGistV2Model? accountLedgerGistV2,
  bool isVersion2 = false,
}) {
  var verifyAccountLedgerGistResult = isVersion2
      ? verifyAccountLedgerGistV2(
          accountLedgerGistV2 ??
              AccountLedgerGistV2Model.fromJson(
                  jsonDecode(runAccountLedgerGistV2Operation(
                actionsBeforeExecution: () {
                  print('Running GistV2 Operation...');
                },
              ))),
          (AccountLedgerPageModel accountLedgerPage,
              AccountLedgerDatePageModel accountLedgerDatePage) {
            print(
                "Gist Account Ledger Verification is Success Up-to Account ID ${accountLedgerPage.accountId} - ${accountLedgerDatePage.accountLedgerPageDate}, The Final Balance is ${accountLedgerDatePage.finalBalanceOnDate}");
          },
        )
      : verifyAccountLedgerGist(AccountLedgerGistModel.fromJson(
          jsonDecode(runAccountLedgerGistOperation(
          actionsBeforeExecution: () {
            print('Running Gist Operation...');
          },
        ))), (AccountLedgerPageModel accountLedgerPage,
          AccountLedgerDatePageModel accountLedgerDatePage) {
          print(
              "Gist Account Ledger Verification is Success Up-to Account ID ${accountLedgerPage.accountId} - ${accountLedgerDatePage.accountLedgerPageDate}, The Final Balance is ${accountLedgerDatePage.finalBalanceOnDate}");
        });
  if (verifyAccountLedgerGistResult.status) {
    print("Gist Account Ledger Verification Success...");
    return true;
  } else {
    print("Gist Account Ledger Verification Failure...");
    print(verifyAccountLedgerGistResult.failedAccountLedgerPage);
    return false;
  }
}

String _currentEventTime = '09:00:00';
String _skipInputPrompt = 'Enter S to Skip, '
    'Enter ST to Skip with Time Increment fo 5 Minutes, ';
Map<String, void Function()> _skipMap = {
  'S': () {},
  'ST': () {
    _currentEventTime = get5MinutesIncrementedNormalTimeTextFromNormalTimeText(
        _currentEventTime);
  }
};

void processAccountLedgerGistV2InterActive(
  AccountLedgerGistV2Model accountLedgerGistV2,
) {
  _accountHeads = getUserAccountHeads(
    [],
    accountLedgerGistV2.userId,
    (AccountsWithExecutionStatusModel accountsWithExecutionStatus) {
      printErrorMessage(accountsWithExecutionStatus.error!);
    },
    actionsBeforeExecution: () {
      print('Running GetAccounts Operation...');
    },
  );

  if (verifyAccountLedgerGistInteractive(
    accountLedgerGistV2: accountLedgerGistV2,
    isVersion2: true,
  )) {
    for (AccountLedgerPageModel currentAccountLedgerPage
        in accountLedgerGistV2.accountLedgerPages) {
      for (AccountLedgerDatePageModel currentAccountLedgerDatePage
          in currentAccountLedgerPage.accountLedgerDatePages) {
        for (TransactionOnDateModel currentTransactionOnDate
            in currentAccountLedgerDatePage.transactionsOnDate) {
          u32 fromAccountId, toAccountId;
          if (currentTransactionOnDate.transactionAmount.isNegative) {
            fromAccountId = currentAccountLedgerPage.accountId;
            toAccountId = u32(0);
          } else {
            fromAccountId = u32(0);
            toAccountId = currentAccountLedgerPage.accountId;
          }

          processTransactionForTime(
            accountLedgerGistV2,
            currentAccountLedgerDatePage.accountLedgerPageDate,
            currentTransactionOnDate,
            fromAccountId,
            toAccountId,
          );
        }
      }
    }
  }
}

void processTransactionForTime(
  AccountLedgerGistV2Model accountLedgerGistV2,
  String currentEventDate,
  TransactionOnDateModel currentTransactionOnDate,
  u32 fromAccountId,
  u32 toAccountId,
) {
  if (isNonZeroUnsignedNumbers([fromAccountId, toAccountId])) {
    processTransactionForAccountIds(
      fromAccountId,
      accountLedgerGistV2,
      currentTransactionOnDate,
      toAccountId,
      currentEventDate,
    );
  } else {
    handleInput(
      displayPrompt: () {
        printTransactionDetails(
          accountLedgerGistV2.userId,
          '$currentEventDate $_currentEventTime',
          currentTransactionOnDate,
          fromAccountId,
          toAccountId,
        );

        print('Enter T to Change Time, '
            '$_skipInputPrompt'
            'Enter to Continue : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: {
        'T': () {
          _currentEventTime = inputValidTimeInNormalTimeFormatAsText(
            inputPromptPrefix: 'Current Event Date Time is $currentEventDate, ',
            dataSpecification: 'New Event Time',
          );
          processTransactionForTime(
            accountLedgerGistV2,
            currentEventDate,
            currentTransactionOnDate,
            fromAccountId,
            toAccountId,
          );
        },
        '': () {
          processTransactionForAccountIds(
            fromAccountId,
            accountLedgerGistV2,
            currentTransactionOnDate,
            toAccountId,
            currentEventDate,
          );
        }
      }..addAll(_skipMap),
    );
  }
}

void processTransactionForAccountIds(
  u32 fromAccountId,
  AccountLedgerGistV2Model accountLedgerGistV2,
  TransactionOnDateModel currentTransactionOnDate,
  u32 toAccountId,
  String currentEventDate,
) {
  fromAccountId = fromAccountId == u32(0)
      ? getValidAccountIdFromRelations(
          fromAccountId,
          accountLedgerGistV2,
          currentTransactionOnDate,
          'From A/C ID',
          toAccountId,
        )
      : fromAccountId;

  toAccountId = toAccountId == u32(0)
      ? getValidAccountIdFromRelations(
          toAccountId,
          accountLedgerGistV2,
          currentTransactionOnDate,
          'To A/C ID',
          fromAccountId,
        )
      : toAccountId;

  handleInput(
    displayPrompt: () {
      printTransactionDetails(
        accountLedgerGistV2.userId,
        '$currentEventDate $_currentEventTime',
        currentTransactionOnDate,
        fromAccountId,
        toAccountId,
      );

      print('Enter T to Change Time, '
          'Enter AF to Change From A/C ID, '
          'Enter AT to Change To A/C ID, '
          '$_skipInputPrompt'
          'Enter to Continue : ');
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'T': () {
        _currentEventTime = inputValidTimeInNormalTimeFormatAsText(
          inputPromptPrefix: 'Current Event Date Time is $currentEventDate, ',
          dataSpecification: 'New Event Time',
        );
        processTransactionForTime(
          accountLedgerGistV2,
          currentEventDate,
          currentTransactionOnDate,
          fromAccountId,
          toAccountId,
        );
      },
      'AF': () {
        processTransactionForAccountIds(
          getValidAccountIdFromRelations(
            fromAccountId,
            accountLedgerGistV2,
            currentTransactionOnDate,
            'From A/C ID',
            toAccountId,
          ),
          accountLedgerGistV2,
          currentTransactionOnDate,
          toAccountId,
          currentEventDate,
        );
      },
      'AT': () {
        processTransactionForAccountIds(
          fromAccountId,
          accountLedgerGistV2,
          currentTransactionOnDate,
          getValidAccountIdFromRelations(
            toAccountId,
            accountLedgerGistV2,
            currentTransactionOnDate,
            'To A/C ID',
            fromAccountId,
          ),
          currentEventDate,
        );
      },
      '': () {
        insertTransactionWithRetryOption(
          accountLedgerGistV2,
          currentEventDate,
          currentTransactionOnDate,
          fromAccountId,
          toAccountId,
        );
      },
    }..addAll(_skipMap),
  );
}

void insertTransactionWithRetryOption(
  AccountLedgerGistV2Model accountLedgerGistV2,
  String currentEventDate,
  TransactionOnDateModel currentTransactionOnDate,
  u32 fromAccountId,
  u32 toAccountId,
) {
  AccountLedgerApiResultMessageModel insertTransactionResult =
      runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
          TransactionModel(
    accountLedgerGistV2.userId,
    '$currentEventDate $_currentEventTime',
    currentTransactionOnDate.transactionParticulars,
    currentTransactionOnDate.transactionAmount,
    fromAccountId,
    toAccountId,
  ));
  if (insertTransactionResult.accountLedgerApiResultStatus.status == 0) {
    _currentEventTime =
        insertTransactionResult.newDateTime.split(' ').elementAt(1);
  } else {
    handleInput(
      displayPrompt: () {
        print(
            'Insert Transaction Operation Failure due to ${insertTransactionResult.accountLedgerApiResultStatus.error}, '
            '$_skipInputPrompt'
            'E to Exit, '
            'Enter to Retry : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: {
        'E': () {
          printExitMessage();
        },
        '': () {
          insertTransactionWithRetryOption(
            accountLedgerGistV2,
            currentEventDate,
            currentTransactionOnDate,
            fromAccountId,
            toAccountId,
          );
        },
      }..addAll(_skipMap),
    );
  }
}

void printTransactionDetails(
  u32 userId,
  String currentEventDateTime,
  TransactionOnDateModel currentTransactionOnDate,
  u32 fromAccountId,
  u32 toAccountId,
) {
  print('\nTransaction Details');
  print('-----------------------');
  print('userId: $userId'
      '\neventDateTime: $currentEventDateTime'
      '\nparticulars: ${currentTransactionOnDate.transactionParticulars}'
      '\namount: ${currentTransactionOnDate.transactionAmount}'
      '\nfromAccountId: $fromAccountId'
      '\ntoAccountId: $toAccountId\n');
}

u32 getValidAccountIdFromRelations(
  u32 desiredAccountId,
  AccountLedgerGistV2Model accountLedgerGistV2,
  TransactionOnDateModel currentTransactionOnDate,
  String dataSpecification,
  u32 alreadyKnownAccountId,
) {
  Map<String, void Function()> actionsWithKeys = {
    'R': () {
      getValidAccountIdFromRelations(
        desiredAccountId,
        accountLedgerGistV2,
        currentTransactionOnDate,
        dataSpecification,
        alreadyKnownAccountId,
      );
    },
    '': () {
      desiredAccountId = getValidAccountIdFromUserInput(
        dataSpecification,
        accountLedgerGistV2.userId,
        _accountHeads,
      );
    },
  };
  List<AccountRelationModel>? accountRelations = getDetailedAccountRelations(
      accountLedgerGistV2.userId,
      alreadyKnownAccountId,
      currentTransactionOnDate.transactionParticulars,
      _accountHeads);
  if ((accountRelations == null) || accountRelations.isEmpty) {
    handleInput(
      displayPrompt: () {
        print(
            'A/C ID $alreadyKnownAccountId not Associated any A/Cs for Particulars: ${currentTransactionOnDate.transactionParticulars}, '
            'Enter R to Refresh Relation of Accounts, '
            'Enter to Continue : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: actionsWithKeys,
    );
  } else {
    handleInput(
      displayPrompt: () {
        print('A/C ID $alreadyKnownAccountId Associated A/Cs');
        print('=============================================');
        for (int i = 0; i < accountRelations.length; i++) {
          print('For Indicator "${accountRelations[i].indicator}"');
          print('----------------------------------------------------');
          for (Pair<u32, String> element
              in accountRelations[i].associatedAccountIds) {
            print('${element.left} : ${element.right}');
          }
        }
        print('Enter R to Refresh Relation of Accounts, '
            'Enter to Continue : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: actionsWithKeys,
    );
  }
  return desiredAccountId;
}

u32 getValidAccountIdFromUserInput(
  String dataSpecification,
  u32 userId,
  List<AccountHeadModel> accountHeads,
) {
  Pair<u32, List<AccountHeadModel>> getValidAccountIdResult = getValidAccountId(
      () {
        return inputValidUnsignedPositiveInteger(
            dataSpecification: dataSpecification);
      },
      userId,
      accountHeads,
      () {
        printInvalidMessage(dataSpecification: 'A/C ID');
      });
  _accountHeads = getValidAccountIdResult.right!;
  return getValidAccountIdResult.left!;
}
