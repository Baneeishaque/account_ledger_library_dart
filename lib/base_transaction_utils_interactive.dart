
import 'package:account_ledger_library_dart/date_time_utils.dart';
import 'package:account_ledger_library_dart/input_utils.dart';
import 'package:account_ledger_library_dart/string_utils.dart';
import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import 'input_utils_interactive.dart';
import 'transaction_modal.dart';
import 'transaction_utils_api_interactive.dart';

Tuple2<String, String> insertNextTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 fromAccountId,
  u32 toAccountId,
) {
  insertTransactionWithNewParticulars(
    particulars,
    (newParticulars) {
      particulars = newParticulars;
      insertTransaction(
        TransactionModal(
          userId,
          eventDateTime,
          newParticulars,
          amount,
          fromAccountId,
          toAccountId,
        ),
      );
    },
    () {
      insertTransaction(
        TransactionModal(
          userId,
          eventDateTime,
          particulars,
          amount,
          fromAccountId,
          toAccountId,
        ),
      );
    },
  );

  eventDateTime = normalDateTimeFormat.format(
    normalDateTimeFormat.parse(eventDateTime).add(Duration(minutes: 5)),
  );

  return Tuple2(eventDateTime, particulars);
}

void insertTransaction(
  TransactionModal transaction,
) {
  handleInput(
    displayPrompt: () {
      print("Going to add $transaction, "
          "S to Split Transaction, "
          "Enter to Continue : ");
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'S': () {
        insertSplitTransaction(
            transaction.userId,
            transaction.eventDateTime,
            transaction.particulars,
            transaction.amount,
            transaction.fromAccountId,
            transaction.toAccountId);
      },
      '': () {
        insertTransactionViaApi(transaction);
      },
    },
  );
}

void insertSplitTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 fromAccountId,
  u32 toAccountId,
) {
  u32 noOfSplits =
      inputValidUnsignedPositiveInteger(dataSpecification: "No. of Splits");
  handleInput(
    displayPrompt: () {
      print("Going to add ${TransactionModal(
        userId,
        eventDateTime,
        particulars,
        amount,
        fromAccountId,
        toAccountId,
      )} as $noOfSplits Splits, "
          "E for Equal Splits, "
          "C for Custom Splits : ");
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'E': () {
        double splitAmount = amount / noOfSplits.value;
        for (int i = 1; i <= noOfSplits.value; i++) {
          Tuple2<String, String> insertTransactionResult =
              insertNextTransaction(
            userId,
            eventDateTime,
            particulars,
            splitAmount,
            fromAccountId,
            toAccountId,
          );
          eventDateTime = insertTransactionResult.item1;
          particulars = insertTransactionResult.item2;
        }
      },
      'C': () {
        //TODO : Insert Custom Split Transaction
      },
    },
  );
}

void insertTransactionWithNewParticulars(
  String particulars,
  void Function(String newParticulars) actionsWithNewParticulars,
  void Function() actionsWithOldParticulars,
) {
  String newParticulars = particulars;
  handleInput(
    displayPrompt: () {
      print(
          "Do You Want to Update Current Particulars [$particulars], Y/N(Default) : ");
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'Y': () {
        handleInput(
            displayPrompt: () {
              print("C to Cancel the update of Particulars, "
                  "R to Reverse the Particulars [${reverseText(particulars)}], "
                  "N to enter new Particulars, "
                  "A to append Text to Particulars, "
                  "P to prepend Text to Particulars : ");
            },
            invalidInputActions: printInvalidInputMessage,
            actionsWithKeys: {
              'C': () {
                insertTransactionWithNewParticulars(particulars,
                    actionsWithNewParticulars, actionsWithOldParticulars);
              },
              'R': () {
                newParticulars = reverseText(particulars);
                handleInput(
                  displayPrompt: () {
                    print(
                        "The Modified Particulars : $newParticulars, Is It OK, Y(Default)/N : ");
                  },
                  invalidInputActions: printInvalidInputMessage,
                  actionsWithKeys: {
                    'Y': () {
                      actionsWithNewParticulars(newParticulars);
                    },
                    'N': () {
                      insertTransactionWithNewParticulars(particulars,
                          actionsWithNewParticulars, actionsWithOldParticulars);
                    },
                    '': () {
                      actionsWithNewParticulars(newParticulars);
                    },
                  },
                );
              },
              'N': () {},
              'A': () {
                String dataToAppend = inputValidText(
                    dataSpecification: "Text to Append with Particulars");
                newParticulars = "$particulars$dataToAppend";
                handleInput(
                  displayPrompt: () {
                    print(
                        "The Modified Particulars : $newParticulars, Is It OK, Y(Default)/N : ");
                  },
                  invalidInputActions: printInvalidInputMessage,
                  actionsWithKeys: {
                    'Y': () {
                      actionsWithNewParticulars(newParticulars);
                    },
                    'N': () {
                      insertTransactionWithNewParticulars(particulars,
                          actionsWithNewParticulars, actionsWithOldParticulars);
                    },
                    '': () {
                      actionsWithNewParticulars(newParticulars);
                    },
                  },
                );
              },
              'P': () {},
            });
      },
      'N': () {
        actionsWithOldParticulars.call();
      },
      '': () {
        actionsWithOldParticulars.call();
      },
    },
  );
}
