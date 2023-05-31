import 'package:account_ledger_library/account_ledger_gist.dart';
import 'package:account_ledger_library/constants.dart';
import 'package:account_ledger_library/modals/account_ledger_gist_verification_result_modal.dart';
import 'package:account_ledger_library/advanced_transaction_api_interactive.dart';
import 'package:account_ledger_library/common_utils/input_utils.dart';
import 'package:account_ledger_library/common_utils/input_utils_interactive.dart';
import 'package:account_ledger_library/transaction_api.dart';
import 'package:account_ledger_library/utils/user_input_utils_interactive.dart';
import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

void main(List<String> arguments) {
  handleInput(
    displayPrompt: () {
      print("Account Ledger CLI"
          "\n-----------------------"
          "\n1 : Manipulate Gist Account Ledger"
          "\n2 : Add $oneTwoThreeOneText Transaction"
          "\n3 : Add $oneTwoTwoThreeThreeOneText (Cyclic Via.) Transaction"
          "\n4 : Add $oneTwoTwoThreeThreeFourFourOneText Transaction"
          "\n5 : Add $oneTwoTwoThreeThreeFourText Transaction"
          "\n6 : Add $oneTwoTwoThreeText (Via.) Transaction"
          "\n7 : Add $oneTwoTwoThreeThreeTwoTwoFourFourOneText Transaction"
          "\n8 : Add $oneTwoTwoThreeThreeTwoTwoFourFourOneFourTwoText Transaction"
          "\n9 : Get User Account Heads"
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
        print("$oneTwoTwoThreeThreeOneText (Cyclic Via.) Transaction"
            "\n----------------------------");

        Tuple7<u32, String, String, double, u32, u32, u32> userInputs =
            getUserInputUpToThreeParties(
          party1AccountIdDataSpecification: "From Account ID",
          party2AccountIdDataSpecification: "Via. Account ID",
          party3AccountIdDataSpecification: "To Account ID",
        );

        insertOneTwoTwoThreeThreeOneTransaction(
          userInputs.item1,
          userInputs.item2,
          userInputs.item3,
          userInputs.item4,
          userInputs.item5,
          userInputs.item6,
          userInputs.item7,
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
      "6": () {
        print("$oneTwoTwoThreeText (Via.) Transaction"
            "\n------------------------");

        Tuple7<u32, String, String, double, u32, u32, u32> userInputs =
            getUserInputUpToThreeParties();

        insertOneTwoTwoThreeTransaction(
          userInputs.item1,
          userInputs.item2,
          userInputs.item3,
          userInputs.item4,
          userInputs.item5,
          userInputs.item6,
          userInputs.item7,
        );
      },
      "7": () {
        print("$oneTwoTwoThreeThreeTwoTwoFourFourOneText Transaction"
            "\n------------------------");

        Tuple7<u32, String, String, double, u32, u32, u32> userInputs =
            getUserInputUpToThreeParties();

        insertOneTwoTwoThreeThreeTwoTwoFourFourOneTransaction(
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
      "8": () {
        print("$oneTwoTwoThreeThreeTwoTwoFourFourOneFourTwoText Transaction"
            "\n------------------------");

        Tuple7<u32, String, String, double, u32, u32, u32> userInputs =
            getUserInputUpToThreeParties();

        insertOneTwoTwoThreeThreeTwoTwoFourFourOneFourTwoTransaction(
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
      "9": () {
        print(runAccountLedgerGetAccountsOperation(
            inputValidUnsignedPositiveInteger(dataSpecification: "User ID")));
      },
      "0": () {},
    },
  );
}
