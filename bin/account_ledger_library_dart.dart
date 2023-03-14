import 'dart:convert';

import 'package:account_ledger_library_dart/account_ledger_gist_model.dart';
import 'package:account_ledger_library_dart/account_ledger_library_dart.dart';

void main(List<String> arguments) async {
  String processOutput = await runAccountLedgerGistOperation();
  AccountLedgerGistModal accountLedgerGist =
      AccountLedgerGistModal.fromJson(jsonDecode(processOutput));
  print(accountLedgerGist.toString());
}
