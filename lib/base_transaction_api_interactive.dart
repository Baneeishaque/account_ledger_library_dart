import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import 'common_utils/date_time_utils.dart';
import 'common_utils/input_utils.dart';
import 'common_utils/input_utils_interactive.dart';
import 'common_utils/string_utils.dart';
import 'models/transaction_model.dart';
import 'transaction_api.dart';

Future<Tuple3<String, String, double>> insertNextTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 fromAccountId,
  u32 toAccountId,
) async {
  await insertTransactionWithAlteredInputs(particulars, amount, (
    newParticulars,
    newAmount,
  ) async {
    particulars = newParticulars;
    amount = newAmount;
    await insertTransaction(
      TransactionModel(
        userId,
        eventDateTime,
        newParticulars,
        newAmount,
        fromAccountId,
        toAccountId,
      ),
    );
  });

  eventDateTime = normalDateTimeFormat.format(
    normalDateTimeFormat.parse(eventDateTime).add(Duration(minutes: 5)),
  );

  return Tuple3(eventDateTime, particulars, amount);
}

Future<void> insertTransaction(TransactionModel transaction) async {
  await handleInput(
    displayPrompt: () {
      print(
        "Going to add $transaction, "
        "S to Split Transaction, "
        "Enter to Continue : ",
      );
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'S': () async {
        await insertSplitTransaction(
          transaction.userId,
          transaction.eventDateTime,
          transaction.particulars,
          transaction.amount,
          transaction.fromAccountId,
          transaction.toAccountId,
        );
      },
      '': () async {
        print(await runAccountLedgerInsertTransactionOperation(transaction));
      },
    },
  );
}

Future<void> insertSplitTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 fromAccountId,
  u32 toAccountId,
) async {
  u32 noOfSplits = inputValidUnsignedPositiveInteger(
    dataSpecification: "No. of Splits",
  );
  await handleInput(
    displayPrompt: () {
      print(
        "Going to add ${TransactionModel(userId, eventDateTime, particulars, amount, fromAccountId, toAccountId)} as $noOfSplits Splits, "
        "E for Equal Splits, "
        "C for Custom Splits : ",
      );
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'E': () async {
        double splitAmount = amount / noOfSplits.value;
        for (int i = 1; i <= noOfSplits.value; i++) {
          Tuple3<String, String, double> insertTransactionResult =
              await insertNextTransaction(
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
      'C': () async {
        //TODO : Insert Custom Split Transaction
      },
    },
  );
}

Future<void> insertTransactionWithAlteredInputs(
  String particulars,
  double amount,
  Future<void> Function(String newParticulars, double newAmount) insertFunction,
) async {
  String newParticulars = particulars;
  await handleInput(
    displayPrompt: () {
      print(
        "Do You Want to Update Current Particulars [$particulars], Y/N(Default) : ",
      );
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'Y': () async {
        await handleInput(
          displayPrompt: () {
            print(
              "C to Cancel the update of Particulars, "
              "R to Reverse the Particulars [${reverseText(particulars)}], "
              "N to enter new Particulars, "
              "A to append Text to Particulars, "
              "P to prepend Text to Particulars : ",
            );
          },
          invalidInputActions: printInvalidInputMessage,
          actionsWithKeys: {
            'C': () async {
              await insertTransactionWithAlteredInputs(
                particulars,
                amount,
                insertFunction,
              );
            },
            'R': () async {
              newParticulars = reverseText(particulars);
              await handleInput(
                displayPrompt: () {
                  print(
                    "The Modified Particulars : $newParticulars, Is It OK, Y(Default)/N : ",
                  );
                },
                invalidInputActions: printInvalidInputMessage,
                actionsWithKeys: {
                  'Y': () async {
                    await getAlteredAmount(
                      amount,
                      insertFunction,
                      newParticulars,
                    );
                  },
                  'N': () async {
                    await insertTransactionWithAlteredInputs(
                      particulars,
                      amount,
                      insertFunction,
                    );
                  },
                  '': () async {
                    await getAlteredAmount(
                      amount,
                      insertFunction,
                      newParticulars,
                    );
                  },
                },
              );
            },
            'N': () async {},
            'A': () async {
              String dataToAppend = inputValidText(
                dataSpecification: "Text to Append with Particulars",
              );
              newParticulars = "$particulars$dataToAppend";
              await handleInput(
                displayPrompt: () {
                  print(
                    "The Modified Particulars : $newParticulars, Is It OK, Y(Default)/N : ",
                  );
                },
                invalidInputActions: printInvalidInputMessage,
                actionsWithKeys: {
                  'Y': () async {
                    await getAlteredAmount(
                      amount,
                      insertFunction,
                      newParticulars,
                    );
                  },
                  'N': () async {
                    await insertTransactionWithAlteredInputs(
                      particulars,
                      amount,
                      insertFunction,
                    );
                  },
                  '': () async {
                    await getAlteredAmount(
                      amount,
                      insertFunction,
                      newParticulars,
                    );
                  },
                },
              );
            },
            'P': () async {},
          },
        );
      },
      'N': () async {
        await getAlteredAmount(amount, insertFunction, particulars);
      },
      '': () async {
        await getAlteredAmount(amount, insertFunction, particulars);
      },
    },
  );
}

Future<void> getAlteredAmount(
  double amount,
  Future<void> Function(String newParticulars, double newAmount) insertFunction,
  String particulars,
) async {
  await handleInput(
    displayPrompt: () {
      print("Do You Want to Update Current Amount [$amount], Y/N(Default) : ");
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'Y': () async {
        double newAmount = inputValidDouble(
          dataSpecification: "New Amount of Transaction",
        );
        await handleInput(
          displayPrompt: () {
            print(
              "The Modified Amount : $newAmount, Is It OK, Y(Default)/N : ",
            );
          },
          invalidInputActions: printInvalidInputMessage,
          actionsWithKeys: {
            'Y': () async {
              await insertFunction(particulars, newAmount);
            },
            'N': () async {
              await getAlteredAmount(amount, insertFunction, particulars);
            },
            '': () async {
              await insertFunction(particulars, newAmount);
            },
          },
        );
      },
      'N': () async {
        await insertFunction(particulars, amount);
      },
      '': () async {
        await insertFunction(particulars, amount);
      },
    },
  );
}
