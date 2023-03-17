import 'dart:convert';
import 'dart:io';

import 'package:account_ledger_library_dart/account_ledger_gist_verification_result_modal.dart';
import 'package:account_ledger_library_dart/constants.dart';

import 'account_ledger_gist_model.dart';

String runAccountLedgerGistOperation() {
  return (Process.runSync(
    accountLedgerCliExecutable,
    ["Gist"],
    workingDirectory: r"C:\Programs\Account-Ledger-Cli\bin",
  )).stdout;
}

AccountLedgerGistModal processAccountLedgerGist() {
  AccountLedgerGistModal accountLedgerGist = AccountLedgerGistModal.fromJson(
      jsonDecode(runAccountLedgerGistOperation()));
  accountLedgerGist.accountLedgerPages
      ?.forEach((AccountLedgerPageModal accountLedgerPage) {
    accountLedgerPage.accountLedgerDatePages
        ?.forEach((AccountLedgerDatePageModal accountLedgerDatePage) {
      print("Initial Balance - ${accountLedgerDatePage.initialBalanceOnDate}");
      accountLedgerDatePage.transactionsOnDate
          ?.forEach((TransactionOnDateModal transactionOnDate) {
        print(
            "${transactionOnDate.transactionParticulars} - ${transactionOnDate.transactionAmount}");
      });
      print("Final Balance - ${accountLedgerDatePage.finalBalanceOnDate}");
    });
  });
  return accountLedgerGist;
}

AccountLedgerGistVerificationResultModal verifyAccountLedgerGist(
    AccountLedgerGistModal accountLedgerGist) {
  AccountLedgerGistVerificationResultModal accountLedgerVerificationResult =
      AccountLedgerGistVerificationResultModal(status: true);
  accountLedgerGist.accountLedgerPages
      ?.forEach((AccountLedgerPageModal accountLedgerPage) {
    accountLedgerPage.accountLedgerDatePages
        ?.forEach((AccountLedgerDatePageModal accountLedgerDatePage) {
      double accountLedgerDatePageInitialBalance =
          accountLedgerDatePage.initialBalanceOnDate!;
      accountLedgerDatePage.transactionsOnDate
          ?.forEach((TransactionOnDateModal transactionOnDate) {
        accountLedgerDatePageInitialBalance =
            accountLedgerDatePageInitialBalance +
                transactionOnDate.transactionAmount!;
      });
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
            currentAccountLedgerPage.accountLedgerDatePages!
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
    });
  });
  return accountLedgerVerificationResult;
}
