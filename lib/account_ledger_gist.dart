import 'dart:convert';

import 'package:account_ledger_library/modals/account_ledger_gist_verification_result_modal.dart';
import 'package:account_ledger_library/utils/account_ledger_kotlin_cli_utils.dart';

String runAccountLedgerGistOperation() {
  return runAccountLedgerKotlinCliOperation(["Gist"]);
}

AccountLedgerGistModal processAccountLedgerGist() {
  AccountLedgerGistModal accountLedgerGist = AccountLedgerGistModal.fromJson(
      jsonDecode(runAccountLedgerGistOperation()));
  return accountLedgerGist;
}

AccountLedgerGistVerificationResultModal verifyAccountLedgerGist(
    AccountLedgerGistModal accountLedgerGist,
    void Function(AccountLedgerPageModal, AccountLedgerDatePageModal)
        actionsOnVerificationSuccessForAccountLedgerDatePage) {
  AccountLedgerGistVerificationResultModal accountLedgerVerificationResult =
      AccountLedgerGistVerificationResultModal(status: true);
  double accountLedgerDatePageInitialBalance = 0;
  for (AccountLedgerPageModal accountLedgerPage
      in accountLedgerGist.accountLedgerPages) {
    for (AccountLedgerDatePageModal accountLedgerDatePage
        in accountLedgerPage.accountLedgerDatePages) {
      if (accountLedgerDatePage.initialBalanceOnDate != null) {
        accountLedgerDatePageInitialBalance =
            accountLedgerDatePage.initialBalanceOnDate!;
      }
      for (TransactionOnDateModal transactionOnDate
          in accountLedgerDatePage.transactionsOnDate) {
        accountLedgerDatePageInitialBalance =
            accountLedgerDatePageInitialBalance +
                transactionOnDate.transactionAmount;
      }
      if (accountLedgerDatePage.finalBalanceOnDate != null) {
        if (accountLedgerDatePageInitialBalance !=
            accountLedgerDatePage.finalBalanceOnDate) {
          accountLedgerVerificationResult.status = false;
          if (accountLedgerVerificationResult.failedAccountLedgerPages ==
              null) {
            accountLedgerVerificationResult.failedAccountLedgerPages = [
              AccountLedgerPageModal(
                  accountId: accountLedgerPage.accountId,
                  accountLedgerDatePages: [accountLedgerDatePage])
            ];
          } else {
            bool isExistingAccountLedgerPage = true;
            AccountLedgerPageModal currentAccountLedgerPage =
                accountLedgerVerificationResult.failedAccountLedgerPages!
                    .firstWhere(
                        (localAccountLedgerPage) =>
                            localAccountLedgerPage.accountId ==
                            accountLedgerPage.accountId, orElse: () {
              isExistingAccountLedgerPage = false;
              return AccountLedgerPageModal(
                  accountId: accountLedgerPage.accountId,
                  accountLedgerDatePages: [accountLedgerDatePage]);
            });
            if (isExistingAccountLedgerPage) {
              currentAccountLedgerPage.accountLedgerDatePages
                  .add(accountLedgerDatePage);

              accountLedgerVerificationResult.failedAccountLedgerPages!
                  .removeWhere((localAccountLedgerPage) =>
                      localAccountLedgerPage.accountId ==
                      accountLedgerPage.accountId);
            }
            accountLedgerVerificationResult.failedAccountLedgerPages!
                .add(currentAccountLedgerPage);
          }
        } else {
          actionsOnVerificationSuccessForAccountLedgerDatePage(
              accountLedgerPage, accountLedgerDatePage);
        }
      }
    }
  }
  return accountLedgerVerificationResult;
}
