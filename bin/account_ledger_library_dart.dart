import 'package:account_ledger_library_dart/account_ledger_gist.dart';
import 'package:account_ledger_library_dart/account_ledger_gist_model.dart';
import 'package:account_ledger_library_dart/advanced_transaction_utils_interactive.dart';
import 'package:account_ledger_library_dart/constants.dart';
import 'package:account_ledger_library_dart/input_utils.dart';
import 'package:account_ledger_library_dart/input_utils_interactive.dart';
import 'package:account_ledger_library_dart/user_input_utils_interactive.dart';
import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

void main(List<String> arguments) {
  handleInput(
    displayPrompt: () {
      print("Account Ledger CLI"
          "\n-----------------------"
          "\n1 : Manipulate Gist Account Ledger"
          "\n2 : Add $oneTwoThreeOneText Transaction"
          "\n3 : Add Cyclic Via. Transaction"
          "\n4 : Add $oneTwoTwoThreeThreeFourFourOneText Transaction"
          "\n5 : Add $oneTwoTwoThreeThreeFourText Transaction"
          "\n0 : Exit"
          "\n"
          "\nEnter Your Choice : ");
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
        print("$oneTwoThreeOneText Transaction"
            "\n------------------------");

        Tuple7<u32, String, String, double, u32, u32, u32> userInputs =
            getUserInputUpToThreeParties();

        insertOneTwoThreeOneTransaction(
          userInputs.item1,
          userInputs.item2,
          userInputs.item3,
          userInputs.item4,
          userInputs.item5,
          userInputs.item6,
          userInputs.item7,
        );
      },
      "3": () {
        print("Cyclic Via Transaction"
            "\n----------------------------");

        Tuple7<u32, String, String, double, u32, u32, u32> userInputs =
            getUserInputUpToThreeParties(
          party1AccountIdDataSpecification: "From Account ID",
          party2AccountIdDataSpecification: "Via. Account ID",
          party3AccountIdDataSpecification: "To Account ID",
        );
      },
      "4": () {
        print("$oneTwoTwoThreeThreeFourFourOneText Transaction"
            "\n------------------------");

        Tuple7<u32, String, String, double, u32, u32, u32> userInputs =
            getUserInputUpToThreeParties();

        insertOneTwoTwoThreeThreeFourFourOneTransaction(
          userInputs.item1,
          userInputs.item2,
          userInputs.item3,
          userInputs.item4,
          userInputs.item5,
          userInputs.item6,
          userInputs.item7,
          inputValidUnsignedPositiveInteger(
              dataSpecification: "Party 4 Account ID"),
        );
      },
      "5": () {
        print("$oneTwoTwoThreeThreeFourText Transaction"
            "\n------------------------");

        Tuple7<u32, String, String, double, u32, u32, u32> userInputs =
            getUserInputUpToThreeParties();

        insertOneTwoTwoThreeThreeFourTransaction(
          userInputs.item1,
          userInputs.item2,
          userInputs.item3,
          userInputs.item4,
          userInputs.item5,
          userInputs.item6,
          userInputs.item7,
          inputValidUnsignedPositiveInteger(
              dataSpecification: "Party 4 Account ID"),
        );
      },
      "0": () {}
    },
  );
}
