import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import 'common_utils/date_time_utils.dart';
import 'common_utils/input_utils.dart';
import 'common_utils/input_utils_interactive.dart';
import 'common_utils/string_utils.dart';
import 'models/transaction_model.dart';
import 'transaction_api_interactive.dart';

Tuple3<String, String, double> insertNextTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 fromAccountId,
  u32 toAccountId,
) {
  insertTransactionWithAlteredInputs(
    particulars,
    amount,
    (newParticulars, newAmount) {
      particulars = newParticulars;
      amount = newAmount;
      insertTransaction(
        TransactionModel(
          userId,
          eventDateTime,
          newParticulars,
          newAmount,
          fromAccountId,
          toAccountId,
        ),
      );
    },
  );

  eventDateTime = normalDateTimeFormat.format(
    normalDateTimeFormat.parse(eventDateTime).add(Duration(minutes: 5)),
  );

  return Tuple3(eventDateTime, particulars, amount);
}

void insertTransaction(
  TransactionModel transaction,
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
      print("Going to add ${TransactionModel(
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
          Tuple3<String, String, double> insertTransactionResult =
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
          amount = insertTransactionResult.item3;
        }
      },
      'C': () {
        //TODO : Insert Custom Split Transaction
      },
    },
  );
}

void insertTransactionWithAlteredInputs(
  String particulars,
  double amount,
  void Function(String newParticulars, double newAmount) insertFunction,
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
                insertTransactionWithAlteredInputs(
                  particulars,
                  amount,
                  insertFunction,
                );
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
                      getAlteredAmount(
                        amount,
                        insertFunction,
                        newParticulars,
                      );
                    },
                    'N': () {
                      insertTransactionWithAlteredInputs(
                        particulars,
                        amount,
                        insertFunction,
                      );
                    },
                    '': () {
                      getAlteredAmount(
                        amount,
                        insertFunction,
                        newParticulars,
                      );
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
                      getAlteredAmount(
                        amount,
                        insertFunction,
                        newParticulars,
                      );
                    },
                    'N': () {
                      insertTransactionWithAlteredInputs(
                        particulars,
                        amount,
                        insertFunction,
                      );
                    },
                    '': () {
                      getAlteredAmount(
                        amount,
                        insertFunction,
                        newParticulars,
                      );
                    },
                  },
                );
              },
              'P': () {},
            });
      },
      'N': () {
        getAlteredAmount(
          amount,
          insertFunction,
          particulars,
        );
      },
      '': () {
        getAlteredAmount(
          amount,
          insertFunction,
          particulars,
        );
      },
    },
  );
}

void getAlteredAmount(
  double amount,
  void Function(String newParticulars, double newAmount) insertFunction,
  String particulars,
) {
  handleInput(
    displayPrompt: () {
      print("Do You Want to Update Current Amount [$amount], Y/N(Default) : ");
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'Y': () {
        double newAmount =
            inputValidDouble(dataSpecification: "New Amount of Transaction");
        handleInput(
          displayPrompt: () {
            print(
                "The Modified Amount : $newAmount, Is It OK, Y(Default)/N : ");
          },
          invalidInputActions: printInvalidInputMessage,
          actionsWithKeys: {
            'Y': () {
              insertFunction(particulars, newAmount);
            },
            'N': () {
              getAlteredAmount(
                amount,
                insertFunction,
                particulars,
              );
            },
            '': () {
              insertFunction(particulars, newAmount);
            },
          },
        );
      },
      'N': () {
        insertFunction(particulars, amount);
      },
      '': () {
        insertFunction(particulars, amount);
      },
    },
  );
}
