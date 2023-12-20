import 'models/account_ledger_gist_model_v2.dart';
import 'models/account_ledger_gist_verification_result_model.dart';
import 'utils/account_ledger_kotlin_cli_utils.dart';

String runAccountLedgerGistOperation() {
  return runAccountLedgerKotlinCliOperation(["Gist"]);
}

String runAccountLedgerGistV2Operation() {
  return runAccountLedgerKotlinCliOperation(["GistV2"]);
}

AccountLedgerGistVerificationResultModel verifyAccountLedgerGist(
    AccountLedgerGistModel accountLedgerGist,
    void Function(AccountLedgerPageModel, AccountLedgerDatePageModel)
        actionsOnVerificationSuccessForAccountLedgerDatePage) {
  AccountLedgerGistVerificationResultModel accountLedgerVerificationResult =
      AccountLedgerGistVerificationResultModel(status: true);
  double accountLedgerDatePageInitialBalance = 0;
  for (AccountLedgerPageModel accountLedgerPage
      in accountLedgerGist.accountLedgerPages) {
    if (accountLedgerVerificationResult.status) {
      for (AccountLedgerDatePageModel accountLedgerDatePage
          in accountLedgerPage.accountLedgerDatePages) {
        if (accountLedgerDatePage.initialBalanceOnDate != null) {
          accountLedgerDatePageInitialBalance =
              accountLedgerDatePage.initialBalanceOnDate!;
        }
        for (TransactionOnDateModel transactionOnDate
            in accountLedgerDatePage.transactionsOnDate) {
          accountLedgerDatePageInitialBalance =
              accountLedgerDatePageInitialBalance +
                  transactionOnDate.transactionAmount;
        }
        if (accountLedgerDatePage.finalBalanceOnDate != null) {
          if (accountLedgerDatePageInitialBalance.round() !=
              accountLedgerDatePage.finalBalanceOnDate?.round()) {
            accountLedgerVerificationResult.status = false;
            accountLedgerVerificationResult.failedAccountLedgerPage =
                AccountLedgerPageModel.withRemarks(
              accountId: accountLedgerPage.accountId,
              accountLedgerDatePages: [accountLedgerDatePage],
              remarks:
                  "finalBalance ${accountLedgerDatePage.finalBalanceOnDate} found instead of $accountLedgerDatePageInitialBalance",
            );
            break;
          } else {
            actionsOnVerificationSuccessForAccountLedgerDatePage(
                accountLedgerPage, accountLedgerDatePage);
          }
        }
      }
    } else {
      break;
    }
  }
  return accountLedgerVerificationResult;
}

AccountLedgerGistVerificationResultModel verifyAccountLedgerGistV2(
    AccountLedgerGistV2Model accountLedgerGistV2,
    void Function(AccountLedgerPageModel, AccountLedgerDatePageModel)
        actionsOnVerificationSuccessForAccountLedgerDatePage) {
  return verifyAccountLedgerGist(
      AccountLedgerGistModel(
          userName: accountLedgerGistV2.userName,
          accountLedgerPages: accountLedgerGistV2.accountLedgerPages),
      actionsOnVerificationSuccessForAccountLedgerDatePage);
}
