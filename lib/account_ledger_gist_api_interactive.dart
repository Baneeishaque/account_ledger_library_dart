import 'dart:async';
import 'dart:convert';

import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

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
Map<String, Future<void> Function()> _skipOperationsMap = {
  'S': () async {},
  'ST': () async {
    _currentEventTime = get5MinutesIncrementedNormalTimeTextFromNormalTimeText(
        _currentEventTime);
  },
};
String? _currentParticulars;

late AccountLedgerGistV2Model _accountLedgerGistV2;
late String _currentEventDate;
late TransactionOnDateModel _currentTransactionOnDate;
late u32 _fromAccountId;
late u32 _toAccountId;

String _timeInputPrompt = 'Enter T to Change Time, '
    'Enter T5 to add 5 Minutes to Current Time, ';
Map<String, Future<void> Function()> _timeOperationsMap = {
  'T': () async {
    _currentEventTime = inputValidTimeInNormalTimeFormatAsText(
      inputPromptPrefix: 'Current Event Date Time is $_currentEventDate, ',
      dataSpecification: 'New Event Time',
    );
    await processTransactionForTime();
  },
  'T5': () async {
    _currentEventTime = get5MinutesIncrementedNormalTimeTextFromNormalTimeText(
        _currentEventTime);
    await processTransactionForTime();
  },
};

bool _reloadGistRequested = false;
String _reloadGistPrompt = 'Enter RG to reload Gist Contents, ';
Map<String, Future<void> Function()> _reloadGistOperationMap = {
  'RG': () async {
    _reloadGistRequested = true;
  }
};

Future<void> processAccountLedgerGistV2InterActive(
    AccountLedgerGistV2Model accountLedgerGistV2,
    {bool isNotFromReloadGist = true,
    bool isVersion3 = false}) async {
  _accountLedgerGistV2 = accountLedgerGistV2;
  if (isNotFromReloadGist) {
    _accountHeads = await getUserAccountHeads(
      [],
      _accountLedgerGistV2.userId,
      (AccountsWithExecutionStatusModel accountsWithExecutionStatus) {
        printErrorMessage(accountsWithExecutionStatus.error!);
      },
      actionsBeforeExecution: () {
        print('Running GetAccounts Operation...');
      },
    );
  }

  if (true) {
    for (AccountLedgerPageModel currentAccountLedgerPage
        in _accountLedgerGistV2.accountLedgerPages) {
      if (_reloadGistRequested) {
        break;
      }
      for (AccountLedgerDatePageModel currentAccountLedgerDatePage
          in currentAccountLedgerPage.accountLedgerDatePages) {
        if (_reloadGistRequested) {
          break;
        }
        for (TransactionOnDateModel localCurrentTransactionOnDate
            in currentAccountLedgerDatePage.transactionsOnDate) {
          if (_reloadGistRequested) {
            break;
          }
          _currentTransactionOnDate = localCurrentTransactionOnDate;
          if (isVersion3) {
            _fromAccountId = currentAccountLedgerPage.accountId;
            // TODO: Check Particulars contains =>, if it is - error
            int particularsEndIndex = _currentTransactionOnDate
                .transactionParticulars
                .indexOf(' => ');
            _toAccountId = u32.tryParse(_currentTransactionOnDate
                .transactionParticulars
                .substring(particularsEndIndex + 4)
                .trim())!;
            String transactionContents = _currentTransactionOnDate
                .transactionParticulars
                .substring(0, particularsEndIndex)
                .trim();
            int timeEndIndicator = transactionContents.indexOf(' ');
            _currentEventTime =
                transactionContents.substring(0, timeEndIndicator);
            _currentParticulars =
                transactionContents.substring(timeEndIndicator + 1);
          } else {
            if (_currentTransactionOnDate.transactionAmount.isNegative) {
              _fromAccountId = currentAccountLedgerPage.accountId;
              _toAccountId = u32(0);
            } else {
              _fromAccountId = u32(0);
              _toAccountId = currentAccountLedgerPage.accountId;
            }
          }

          _currentEventDate =
              currentAccountLedgerDatePage.accountLedgerPageDate;
          await processTransactionForTime();
        }
      }
    }
  }
  if (_reloadGistRequested) {
    _reloadGistRequested = false;
    await processAccountLedgerGistV2InterActive(
        AccountLedgerGistV2Model.fromJson(
            jsonDecode(runAccountLedgerGistV2Operation(
          actionsBeforeExecution: () {
            print('Running GistV2 Operation');
          },
          actionsAfterExecution: (String result) {
            // print('Result : $result');
          },
        ))),
        isNotFromReloadGist: false);
  }
}

Future<void> processTransactionForTime() async {
  if (isNonZeroUnsignedNumbers([_fromAccountId, _toAccountId])) {
    await processTransactionForAccountIds();
  } else {
    await handleInput(
      displayPrompt: () {
        printTransactionDetails();

        print('$_timeInputPrompt'
            '$_skipInputPrompt'
            '$_reloadGistPrompt'
            'Enter to Continue : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: {
        '': () async {
          await processTransactionForAccountIds();
        },
      }
        ..addAll(_timeOperationsMap)
        ..addAll(_skipOperationsMap)
        ..addAll(_reloadGistOperationMap),
    );
  }
}

Future<void> processTransactionForAccountIds() async {
  _fromAccountId = _fromAccountId == u32(0)
      ? await getValidAccountIdFromRelations(
          'From A/C ID',
          _toAccountId,
        )
      : _fromAccountId;

  _toAccountId = _toAccountId == u32(0)
      ? await getValidAccountIdFromRelations(
          'To A/C ID',
          _fromAccountId,
        )
      : _toAccountId;

  if (isNonZeroUnsignedNumbers([_fromAccountId, _toAccountId])) {
    await handleInput(
      displayPrompt: () {
        printTransactionDetails();

        print('$_timeInputPrompt'
            'Enter AF to Change From A/C ID, '
            'Enter AT to Change To A/C ID, '
            '$_skipInputPrompt'
            '$_reloadGistPrompt'
            'Enter to Continue : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: {
        'AF': () async {
          _fromAccountId = await getValidAccountIdFromRelations(
            'From A/C ID',
            _toAccountId,
          );
          await processTransactionForAccountIds();
        },
        'AT': () async {
          _toAccountId = await getValidAccountIdFromRelations(
            'To A/C ID',
            _fromAccountId,
          );
          await processTransactionForAccountIds();
        },
        '': () async {
          await insertTransactionWithRetryOption(
            _toAccountId,
          );
        },
      }
        ..addAll(_timeOperationsMap)
        ..addAll(_skipOperationsMap)
        ..addAll(_reloadGistOperationMap),
    );
  } else {
    await processTransactionForAccountIds();
  }
}

Future<void> insertTransactionWithRetryOption(
  u32 toAccountId,
) async {
  AccountLedgerApiResultMessageModel insertTransactionResult =
      await runAccountLedgerInsertTransactionOperationWithTimeIncrementOnSuccess(
    TransactionModel(
      _accountLedgerGistV2.userId,
      '$_currentEventDate $_currentEventTime',
      _currentParticulars ?? _currentTransactionOnDate.transactionParticulars,
      _currentTransactionOnDate.transactionAmount,
      _fromAccountId,
      _toAccountId,
    ),
    beforeOperationActions: () {
      print('Running Account Ledger Insert Transaction Operation...');
    },
  );
  if (insertTransactionResult.accountLedgerApiResultStatus.status == 0) {
    print(insertTransactionResult);
    _currentEventTime =
        insertTransactionResult.newDateTime.split(' ').elementAt(1);
  } else {
    await handleInput(
      displayPrompt: () {
        print(
            'Insert Transaction Operation Failure due to ${insertTransactionResult.accountLedgerApiResultStatus.error}, '
            '$_skipInputPrompt'
            'E to Exit, '
            'Enter to Retry : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: {
        'E': () async {
          printExitMessage();
        },
        '': () async {
          await insertTransactionWithRetryOption(
            _toAccountId,
          );
        },
      }..addAll(_skipOperationsMap),
    );
  }
}

void printTransactionDetails() {
  print('\nTransaction Details');
  print('-----------------------');
  print('userId: ${_accountLedgerGistV2.userId}'
      '\neventDateTime: $_currentEventDate $_currentEventTime'
      '\nparticulars: ${_currentParticulars ?? _currentTransactionOnDate.transactionParticulars}'
      '\namount: ${_currentTransactionOnDate.transactionAmount}'
      '\nfromAccountId: $_fromAccountId'
      '\ntoAccountId: $_toAccountId\n');
}

Future<u32> getValidAccountIdFromRelations(
  String dataSpecification,
  u32 alreadyKnownAccountId,
) async {
  late u32 desiredAccountId;
  List<AccountRelationModel>? accountRelations = getDetailedAccountRelations(
      _accountLedgerGistV2.userId,
      alreadyKnownAccountId,
      _currentTransactionOnDate.transactionParticulars,
      _accountHeads);

  Map<String, Future<void> Function()> actionsWithKeys = {
    'R': () async {
      desiredAccountId = await getValidAccountIdFromRelations(
        dataSpecification,
        alreadyKnownAccountId,
      );
    },
    '': () async {
      desiredAccountId = await getValidAccountIdFromUserInput(
        dataSpecification,
        _accountLedgerGistV2.userId,
        _accountHeads,
        isZeroUsedForBack: true,
      );
    },
    'I': () async {
      if ((accountRelations == null) || accountRelations.isEmpty) {
        printInvalidInputMessage();
      } else {
        Tuple3<u32, List<AccountHeadModel>, bool> getValidAccountIdResult =
            await getValidAccountId(
          _accountLedgerGistV2.userId,
          _accountHeads,
          () {
            printInvalidMessage(dataSpecification: 'A/C ID');
          },
          accountIdToCheck: desiredAccountId,
          isZeroUsedForBack: true,
        );
        _accountHeads = getValidAccountIdResult.item2;
        if (getValidAccountIdResult.item3) {
          desiredAccountId = getValidAccountIdResult.item1;
        } else {
          desiredAccountId = await getValidAccountIdFromUserInput(
            dataSpecification,
            _accountLedgerGistV2.userId,
            _accountHeads,
            isZeroUsedForBack: true,
          );
        }
      }
    }
  };

  if ((accountRelations == null) || accountRelations.isEmpty) {
    await handleInput(
      displayPrompt: () {
        print(
            'A/C ID $alreadyKnownAccountId not Associated any A/Cs for Particulars: ${_currentTransactionOnDate.transactionParticulars}, '
            'Enter R to Refresh Relation of Accounts, '
            'Enter to Continue : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: actionsWithKeys,
    );
  } else {
    await handleInput(
      displayPrompt: () {
        print('A/C ID $alreadyKnownAccountId Associated A/Cs');
        print('=============================================');
        for (int i = 0; i < accountRelations.length; i++) {
          print('\nFor Indicator "${accountRelations[i].indicator}"');
          print('----------------------------------------------------');
          for (Tuple2<u32, String> accountRelation
              in accountRelations[i].associatedAccountIds) {
            desiredAccountId = accountRelation.item1;
            print('${accountRelation.item1} : ${accountRelation.item2}');
          }
        }
        print('Enter R to Refresh Relation of Accounts, '
            'Enter I to Continue with $desiredAccountId, '
            'Enter to Continue : ');
      },
      invalidInputActions: printInvalidInputMessage,
      actionsWithKeys: actionsWithKeys,
    );
  }
  return desiredAccountId;
}

Future<u32> getValidAccountIdFromUserInput(
    String dataSpecification, u32 userId, List<AccountHeadModel> accountHeads,
    {bool isZeroUsedForBack = false}) async {
  Tuple3<u32, List<AccountHeadModel>, bool> getValidAccountIdResult =
      await getValidAccountId(
    userId,
    accountHeads,
    () {
      printInvalidMessage(dataSpecification: 'A/C ID');
    },
    getValidUnsignedPositiveIntegerFunction: () {
      return inputValidUnsignedPositiveInteger(
        dataSpecification: dataSpecification,
        isZeroUsedForBack: isZeroUsedForBack,
      );
    },
    isZeroUsedForBack: isZeroUsedForBack,
  );
  _accountHeads = getValidAccountIdResult.item2;
  return getValidAccountIdResult.item1;
}
