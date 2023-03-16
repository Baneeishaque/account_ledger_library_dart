import 'package:account_ledger_library_dart/account_ledger_gist_model.dart';
import 'package:account_ledger_library_dart/account_ledger_gist.dart';

void main(List<String> arguments) async {
  AccountLedgerGistModal accountLedgerGist = await processAccountLedgerGist();
  if (verifyAccountLedgerGist(accountLedgerGist).status) {
  } else {
    print("Gist Account Ledger Verification Failure...");
  }
}
