import 'dart:io';

import 'package:account_ledger_library_dart/date_time_utils.dart';
import 'package:account_ledger_library_dart/input_utils.dart';
import 'package:account_ledger_library_dart/string_utils.dart';
import 'package:integer/integer.dart';

import 'constants.dart';
import 'input_utils_interactive.dart';
import 'transaction_modal.dart';

void insertThreePartyTransaction(
  u32 userId,
  String eventDateTime,
  String particulars,
  double amount,
  u32 party1accountId,
  u32 party2accountId,
  u32 party3accountId,
) {
  insertTransaction(
    TransactionModal(
      userId,
      eventDateTime,
      particulars,
      amount,
      party1accountId,
      party2accountId,
    ),
  );
  insertSecondTransaction(
    userId,
    normalDateTimeFormat.format(
      normalDateTimeFormat.parse(eventDateTime).add(Duration(minutes: 5)),
    ),
    particulars,
    amount,
    party3accountId,
    party1accountId,
  );
}

void insertSecondTransaction(
    u32 userId,
    String eventDateTime,
    String particulars,
    double amount,
    u32 party3accountId,
    u32 party1accountId) {
  insertTransactionWithNewParticulars(
    particulars,
    (newParticulars) {
      insertTransaction(
        TransactionModal(
          userId,
          eventDateTime,
          newParticulars,
          amount,
          party3accountId,
          party1accountId,
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
          party3accountId,
          party1accountId,
        ),
      );
    },
  );
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
        insertSplitTransaction(transaction);
      },
      '': () {
        insertTransactionViaApi(transaction);
      },
    },
  );
}

void insertTransactionViaApi(TransactionModal transaction){
  print(transaction.toString());
  print(runAccountLedgerInsertTransactionOperation(transaction));
}

String runAccountLedgerInsertTransactionOperation(
    TransactionModal transaction) {
  return (Process.runSync(
    accountLedgerCliExecutable,
    [
      "InsertTransaction",
      transaction.userId.toString(),
      transaction.eventDateTime,
      transaction.particulars,
      transaction.amount.toString(),
      transaction.fromAccountId.toString(),
      transaction.toAccountId.toString()
    ],
  ))
      .stdout;
}

void insertSplitTransaction(
  TransactionModal transaction,
) {
  u32 noOfSplits =
      inputValidUnsignedPositiveInteger(dataSpecification: "No. of Splits");
  handleInput(
    displayPrompt: () {
      print("Going to add $transaction as $noOfSplits Splits, "
          "E for Equal Splits, "
          "C for Custom Splits : ");
    },
    invalidInputActions: printInvalidInputMessage,
    actionsWithKeys: {
      'E': () {
        double splitAmount = transaction.amount / noOfSplits.value;
        String newParticulars = transaction.particulars;
        String newEventDateTime = transaction.eventDateTime;
        for (int i = 1; i <= noOfSplits.value; i++) {
          newParticulars = insertSplitTransactionWithNewParticulars(
            TransactionModal(
                transaction.userId,
                newEventDateTime,
                newParticulars,
                transaction.amount,
                transaction.fromAccountId,
                transaction.toAccountId),
            splitAmount,
          );
          newEventDateTime = normalDateTimeFormat.format(
            normalDateTimeFormat
                .parse(newEventDateTime)
                .add(Duration(minutes: 5)),
          );
        }
      },
      'C': () {
        //TODO : Insert Custom Split Transaction
      },
    },
  );
}

String insertSplitTransactionWithNewParticulars(
    TransactionModal transaction, double splitAmount) {
  String localNewParticulars = transaction.particulars;
  insertTransactionWithNewParticulars(
    transaction.particulars,
    (newParticulars) {
      localNewParticulars = newParticulars;
      insertTransactionViaApi(
        TransactionModal(
          transaction.userId,
          transaction.eventDateTime,
          newParticulars,
          splitAmount,
          transaction.fromAccountId,
          transaction.toAccountId,
        ),
      );
    },
    () {
      insertTransactionViaApi(
        TransactionModal(
          transaction.userId,
          transaction.eventDateTime,
          transaction.particulars,
          splitAmount,
          transaction.fromAccountId,
          transaction.toAccountId,
        ),
      );
    },
  );
  return localNewParticulars;
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
