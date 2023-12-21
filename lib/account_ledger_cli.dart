import 'dart:convert';

import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import 'account_ledger_gist_api.dart';
import 'account_ledger_gist_api_interactive.dart';
import 'advanced_transaction_api_interactive.dart';
import 'common_utils/input_utils.dart';
import 'common_utils/input_utils_interactive.dart';
import 'constants.dart';
import 'models/account_ledger_gist_model_v2.dart';
import 'relations_of_accounts_operations.dart';
import 'transaction_api.dart';
import 'utils/user_input_utils_interactive.dart';

void startAccountLedgerCli() {
  handleInput(
    displayPrompt: () {
      print("Account Ledger CLI"
          "\n-----------------------"
          "\n1 : Verify Gist Account Ledger"
          "\n2 : Add $oneTwoThreeOneText Transaction"
          "\n3 : Add $oneTwoTwoThreeThreeOneText (Cyclic Via.) Transaction"
          "\n4 : Add $oneTwoTwoThreeThreeFourFourOneText Transaction"
          "\n5 : Add $oneTwoTwoThreeThreeFourText Transaction"
          "\n6 : Add $oneTwoTwoThreeText (Via.) Transaction"
          "\n7 : Add $oneTwoTwoThreeThreeTwoTwoFourFourOneText Transaction"
          "\n8 : Add $oneTwoTwoThreeThreeTwoTwoFourFourOneFourTwoText Transaction"
          "\n9 : Get User Account Heads"
          "\n10 : Get Relation of Accounts from file"
          "\n11 : Process Gist (Version 2) Account Ledger (Interactive)"
          "\n12 : Verify Gist (Version 2) Account Ledger"
          "\n13 : Process Gist (Version 2) Account Ledger (Auto)"
          "\n0 : Exit"
          "\n"
          "\nEnter Your Choice : ");
    },
    invalidInputActions: () {
      printInvalidInputMessage();
    },
    actionsWithKeys: {
      "1": () {
        verifyAccountLedgerGistInteractive();
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
            userId: inputValidUnsignedPositiveInteger(
                dataSpecification: "User ID")));
      },
      "10": () {
        print(readRelationsOfAccountsJsonFile());
        print("------------------------------");
        print(readRelationsOfAccountsInNormalForm());
      },
      "11": () {
        processAccountLedgerGistV2InterActive(AccountLedgerGistV2Model.fromJson(
            jsonDecode(runAccountLedgerGistV2Operation(
          actionsBeforeExecution: () {
            print('Running GistV2 Operation');
          },
        ))));
      },
      "12": () {
        verifyAccountLedgerGistInteractive(isVersion2: true);
      },
      "13": () {
        printComingSoonMessage();
      },
      "0": () {},
    },
  );
}
