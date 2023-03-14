import 'account_ledger_gist_model.dart';

class AccountLedgerVerificationResultModal {
  bool status;
  List<AccountLedgerPageModal>? failedAccountLedgerPages;

  AccountLedgerVerificationResultModal(
      {required this.status, this.failedAccountLedgerPages});
}
