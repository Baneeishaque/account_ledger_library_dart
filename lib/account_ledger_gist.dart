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
    if (accountLedgerVerificationResult.status) {
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
          if (accountLedgerDatePageInitialBalance.round() !=
              accountLedgerDatePage.finalBalanceOnDate?.round()) {
            accountLedgerVerificationResult.status = false;
            accountLedgerVerificationResult.failedAccountLedgerPage =
                AccountLedgerPageModal.withRemarks(
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
