import 'package:account_ledger_library_dart/account_ledger_gist.dart';
import 'package:account_ledger_library_dart/account_ledger_gist_model.dart';
import 'package:account_ledger_library_dart/input_utils.dart';
import 'package:account_ledger_library_dart/input_utils_interactive.dart';
import 'package:account_ledger_library_dart/transaction_utils_interactive.dart';
import 'package:integer/integer.dart';

void main(List<String> arguments) {
  handleInput(
    displayPrompt: () {
      print("Account Ledger CLI"
          "\n-----------------------"
          "\n1 : Manipulate Gist Account Ledger"
          "\n2 : Add 3 Party Transaction"
          "\n3 : Add Cyclic Via. Transaction"
          "\n0 : Exit");
    },
    invalidInputActions: () {
      printInvalidInputMessage();
    },
    actionsWithKeys: {
      "1": () {
        AccountLedgerGistModal accountLedgerGist = processAccountLedgerGist();
        if (verifyAccountLedgerGist(accountLedgerGist).status) {
        } else {
          print("Gist Account Ledger Verification Failure...");
        }
      },
      "2": () {
        print("3 Party Transaction"
            "\n------------------------");

        u32 userId =
            inputValidUnsignedPositiveInteger(dataSpecification: "User ID");
        String eventDateTime =
            inputValidText(dataSpecification: "Event Date Time");
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
      },
      "3": () {
        print("Cyclic Via Transaction"
            "\n----------------------------");

        u32 userId =
            inputValidUnsignedPositiveInteger(dataSpecification: "User ID");
        String eventDateTime =
            inputValidText(dataSpecification: "Event Date Time");
        String particulars = inputValidText(dataSpecification: "Particulars");
        double amount = inputValidDouble(dataSpecification: "Amount");
        u32 fromAccountId = inputValidUnsignedPositiveInteger(
            dataSpecification: "From Account ID");
        u32 viaAccountId = inputValidUnsignedPositiveInteger(
            dataSpecification: "Via Account ID");
        u32 toAccountId = inputValidUnsignedPositiveInteger(
            dataSpecification: "To Account ID");
      },
      "0": () {}
    },
  );
}
