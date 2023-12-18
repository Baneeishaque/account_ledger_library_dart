import 'dart:convert';

import 'package:account_ledger_library/modals/account_ledger_gist_verification_result_modal.dart';
import 'package:account_ledger_library/utils/account_ledger_kotlin_cli_utils.dart';

String runAccountLedgerGistOperation() {
  return runAccountLedgerKotlinCliOperation(["Gist"]);
}

AccountLedgerGistModal processAccountLedgerGist() {
  AccountLedgerGistModal accountLedgerGist = AccountLedgerGistModal.fromJson(
      jsonDecode(runAccountLedgerGistOperation()));
  for (AccountLedgerPageModal accountLedgerPage
      in accountLedgerGist.accountLedgerPages) {
    for (AccountLedgerDatePageModal accountLedgerDatePage
        in accountLedgerPage.accountLedgerDatePages) {
      print("Initial Balance - ${accountLedgerDatePage.initialBalanceOnDate}");
      for (TransactionOnDateModal transactionOnDate
          in accountLedgerDatePage.transactionsOnDate) {
        print(
            "${transactionOnDate.transactionParticulars} - ${transactionOnDate.transactionAmount}");
      }
      print("Final Balance - ${accountLedgerDatePage.finalBalanceOnDate}");
    }
  }
  return accountLedgerGist;
}

AccountLedgerGistVerificationResultModal verifyAccountLedgerGist(
    AccountLedgerGistModal accountLedgerGist) {
  AccountLedgerGistVerificationResultModal accountLedgerVerificationResult =
      AccountLedgerGistVerificationResultModal(status: true);
  for (AccountLedgerPageModal accountLedgerPage
      in accountLedgerGist.accountLedgerPages) {
    for (AccountLedgerDatePageModal accountLedgerDatePage
        in accountLedgerPage.accountLedgerDatePages) {
      double accountLedgerDatePageInitialBalance =
          accountLedgerDatePage.initialBalanceOnDate!;
      for (TransactionOnDateModal transactionOnDate
          in accountLedgerDatePage.transactionsOnDate) {
        accountLedgerDatePageInitialBalance =
            accountLedgerDatePageInitialBalance +
                transactionOnDate.transactionAmount;
      }
      if (accountLedgerDatePageInitialBalance !=
          accountLedgerDatePage.finalBalanceOnDate) {
        accountLedgerVerificationResult.status = false;
        if (accountLedgerVerificationResult.failedAccountLedgerPages == null) {
          accountLedgerVerificationResult.failedAccountLedgerPages = [
            AccountLedgerPageModal(
                accountId: accountLedgerPage.accountId,
                accountLedgerDatePages: [accountLedgerDatePage])
          ];
        } else {
          bool isExistingAccountLedgerPage = true;
          var currentAccountLedgerPage = accountLedgerVerificationResult
              .failedAccountLedgerPages!
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
      }
    }
  }
  return accountLedgerVerificationResult;
}
