import 'account_ledger_gist_model.dart';

class AccountLedgerGistVerificationResultModal {
  bool status;
  List<AccountLedgerPageModal>? failedAccountLedgerPages;

  AccountLedgerGistVerificationResultModal(
      {required this.status, this.failedAccountLedgerPages});
}
