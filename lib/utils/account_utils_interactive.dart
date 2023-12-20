import 'package:dart_extensions_methods/dart_extension_methods.dart';
import 'package:integer/integer.dart';

import '../account_ledger_kotlin_cli_operations.dart';
import '../common_utils/input_utils_interactive.dart';
import '../models/accounts_with_execution_status_model.dart';

Pair<u32, List<AccountHeadModel>> getValidAccountId(
    u32 Function() getValidUnsignedPositiveInteger,
    u32 userId,
    List<AccountHeadModel> accountHeads,
    void Function() actionsOnInvalidAccountId,
    {bool isNotRefresh = true,
    u32? accountIdToCheck}) {
  if (isNotRefresh) {
    accountIdToCheck = getValidUnsignedPositiveInteger();
  }
  for (AccountHeadModel accountHead in accountHeads) {
    if (accountHead.id == accountIdToCheck) {
      return Pair(accountIdToCheck!, accountHeads);
    }
  }
  if (isNotRefresh) {
    accountHeads = getUserAccountHeads(
      [],
      userId,
      (AccountsWithExecutionStatusModel accountsWithExecutionStatus) {
        printErrorMessage(accountsWithExecutionStatus.error!);
      },
      actionsBeforeExecution: () {
        print('Refreshing Account Heads...');
      },
    );
    return getValidAccountId(
      getValidUnsignedPositiveInteger,
      userId,
      accountHeads,
      actionsOnInvalidAccountId,
      isNotRefresh: false,
      accountIdToCheck: accountIdToCheck,
    );
  }

  actionsOnInvalidAccountId();

  return getValidAccountId(
    getValidUnsignedPositiveInteger,
    userId,
    accountHeads,
    actionsOnInvalidAccountId,
  );
}
