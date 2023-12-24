import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import '../account_ledger_kotlin_cli_operations.dart';
import '../common_utils/input_utils_interactive.dart';
import '../models/accounts_with_execution_status_model.dart';

Future<Tuple3<u32, List<AccountHeadModel>, bool>> getValidAccountId(
    u32 userId,
    List<AccountHeadModel> accountHeads,
    void Function() actionsOnInvalidAccountId,
    {bool isNotRefresh = true,
    u32 Function()? getValidUnsignedPositiveIntegerFunction,
    u32? accountIdToCheck,
    bool isZeroUsedForBack = false}) async {
  if (isNotRefresh && (getValidUnsignedPositiveIntegerFunction != null)) {
    accountIdToCheck = getValidUnsignedPositiveIntegerFunction();
  }
  if (isZeroUsedForBack && (accountIdToCheck?.value == 0)) {
    return Tuple3(u32(0), accountHeads, false);
  }
  for (AccountHeadModel accountHead in accountHeads) {
    if (accountHead.id == accountIdToCheck) {
      return Tuple3(accountIdToCheck!, accountHeads, true);
    }
  }
  if (isNotRefresh) {
    accountHeads = await getUserAccountHeads(
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
      userId,
      accountHeads,
      actionsOnInvalidAccountId,
      isNotRefresh: false,
      accountIdToCheck: accountIdToCheck,
    );
  }

  actionsOnInvalidAccountId();

  if (getValidUnsignedPositiveIntegerFunction == null) {
    return Tuple3(accountIdToCheck!, accountHeads, false);
  } else {
    return getValidAccountId(userId, accountHeads, actionsOnInvalidAccountId,
        getValidUnsignedPositiveIntegerFunction:
            getValidUnsignedPositiveIntegerFunction);
  }
}
