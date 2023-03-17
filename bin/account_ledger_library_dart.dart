import 'package:account_ledger_library_dart/input_utils_interactive.dart';
import 'package:account_ledger_library_dart/transaction_modal.dart';
import 'package:account_ledger_library_dart/transaction_utils_interactive.dart';
import 'package:integer/integer.dart';

void main(List<String> arguments) {
  // AccountLedgerGistModal accountLedgerGist = processAccountLedgerGist();
  // if (verifyAccountLedgerGist(accountLedgerGist).status) {
  // } else {
  //   print("Gist Account Ledger Verification Failure...");
  // }

  print("Add 3 Party Transaction");

  u32 userId = inputValidUnsignedPositiveInteger(dataSpecification: "User ID");
  String eventDateTime = inputValidText(dataSpecification: "Event Date Time");
  String particulars = inputValidText(dataSpecification: "Particulars");
  double amount = inputValidDouble(dataSpecification: "Amount");
  u32 party1AccountId = inputValidUnsignedPositiveInteger(
      dataSpecification: "Party 1 Account ID");
  u32 party2AccountId = inputValidUnsignedPositiveInteger(
      dataSpecification: "Party 2 Account ID");
  u32 party3AccountId = inputValidUnsignedPositiveInteger(
      dataSpecification: "Party 3 Account ID");

  insertThreePartyTransaction(
    userId,
    eventDateTime,
    particulars,
    amount,
    party1AccountId,
    party2AccountId,
    party3AccountId,
  );

  // print(runAccountLedgerInsertTransactionOperation(
  //   TransactionModal(
  //     u32(25),
  //     "14/03/2023 22:00:00",
  //     "Cash for Transfer",
  //     500,
  //     u32(38),
  //     u32(6),
  //   ),
  // ));
}
