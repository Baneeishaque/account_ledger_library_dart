import 'dart:convert';
import 'dart:io';

import 'package:account_ledger_library_dart/account_ledger_verification_result_modal.dart';

import 'account_ledger_gist_model.dart';

Future<String> runAccountLedgerGistOperation() async {
  return (await Process.run(
    r"C:\Programs\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat",
    ["Gist"],
    workingDirectory: r"C:\Programs\Account-Ledger-Cli\bin",
  ))
      .stdout;
}

Future<AccountLedgerGistModal> processAccountLedgerGist() async {
  AccountLedgerGistModal accountLedgerGist = AccountLedgerGistModal.fromJson(
      jsonDecode(await runAccountLedgerGistOperation()));
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

AccountLedgerVerificationResultModal verifyAccountLedgerGist(
    AccountLedgerGistModal accountLedgerGist) {
  AccountLedgerVerificationResultModal accountLedgerVerificationResult =
      AccountLedgerVerificationResultModal(status: true);
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
