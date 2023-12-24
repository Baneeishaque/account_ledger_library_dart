import 'package:integer/integer.dart';

import 'common_utils/common_utils.dart';
import 'models/accounts_with_execution_status_model.dart';
import 'transaction_api.dart';

Future<List<AccountHeadModel>> getUserAccountHeads(
  List<AccountHeadModel> accountHeads,
  u32 userId,
  void Function(AccountsWithExecutionStatusModel accountsWithExecutionStatus)
      actionsOnApiError, {
  String? filter,
  void Function() actionsBeforeExecution = dummyFunction,
  void Function(String)? actionsAfterExecution,
}) async {
  if (accountHeads.isEmpty) {
    AccountsWithExecutionStatusModel accountsWithExecutionStatus =
        await runAccountLedgerGetAccountsOperation(
      userId: userId,
      actionsBeforeExecution: actionsBeforeExecution,
      actionsAfterExecution: actionsAfterExecution,
    );
    if (accountsWithExecutionStatus.isOK) {
      accountHeads = accountsWithExecutionStatus.data!;
    } else {
      actionsOnApiError(accountsWithExecutionStatus);
      return [];
    }
  }
  if (filter != null) {
    var accountId = int.tryParse(filter);
    if (accountId == null) {
      return accountHeads
          .where((element) => element.name
              .toLowerCase()
              .contains(filter.toString().toLowerCase()))
          .toList();
    } else {
      return accountHeads
          .where((element) =>
              ((element.id.toString().contains(filter.toString())) ||
                  (element.name
                      .toLowerCase()
                      .contains(filter.toString().toLowerCase()))))
          .toList();
    }
  }
  return accountHeads;
}
