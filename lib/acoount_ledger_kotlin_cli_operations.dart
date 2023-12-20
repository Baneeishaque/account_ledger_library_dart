import 'package:integer/integer.dart';

import 'models/account_ledger_gist_model_v2.dart';
import 'models/accounts_with_execution_status_model.dart';
import 'transaction_api.dart';

List<AccountHeadModel> getUserAccountHeadModels(
    List<AccountHeadModel> accountHeads,
    AccountLedgerGistV2Model accountLedgerGistModelV2,
    String filter,
    void Function(AccountsWithExecutionStatusModel accountsWithExecutionStatus)
        actionsOnApiError) {
  if (accountHeads.isEmpty) {
    AccountsWithExecutionStatusModel accountsWithExecutionStatus =
        runAccountLedgerGetAccountsOperation(
      u32(accountLedgerGistModelV2.userId),
    );
    if (accountsWithExecutionStatus.isOK) {
      accountHeads = accountsWithExecutionStatus.data!;
    } else {
      actionsOnApiError(accountsWithExecutionStatus);
      return [];
    }
  }
  if (filter.toString().isNotEmpty) {
    var accountId = int.tryParse(filter);
    if (accountId == null) {
      return accountHeads.where((element) => element.name
          .toLowerCase()
          .contains(filter.toString().toLowerCase())).toList();
    } else {
      return accountHeads.where((element) =>
          ((element.id.toString().contains(filter.toString())) ||
              (element.name
                  .toLowerCase()
                  .contains(filter.toString().toLowerCase())))).toList();
    }
  }
  return accountHeads;
}
