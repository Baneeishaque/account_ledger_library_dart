import 'package:integer/integer.dart';

import 'common_utils.dart';
import 'date_time_utils.dart';
import 'input_utils.dart';

void printInvalidMessage({
  String? inputPromptPrefix,
  required String dataSpecification,
}) {
  print(
      "${inputPromptPrefix ?? ''}Error : Please Enter Valid $dataSpecification...");
}

// dynamic getDataFromTerminal<T>({required String dataSpecification}) {
//   void displayPrompt() {
//     print("Enter $dataSpecification : ");
//   }
//
//   void invalidDataActions() {
//     printInvalidErrorMessage(dataSpecification);
//   }
//
//   if (T is String) {
//     return getNonEmptyText(
//       displayPrompt: displayPrompt,
//       invalidDataActions: invalidDataActions,
//     );
//   }
//
//   if (T is u8) {
//     return getValidUnsignedInteger(
//       displayPrompt: displayPrompt,
//       invalidDataActions: invalidDataActions,
//     );
//   }
// }

u32 inputValidUnsignedInteger({
  String? inputPromptPrefix,
  required String dataSpecification,
}) {
  return getValidUnsignedInteger(
    displayPrompt: () {
      print("${inputPromptPrefix ?? ''}Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification: dataSpecification);
    },
  );
}

u32 inputValidUnsignedPositiveInteger({
  String? inputPromptPrefix,
  required String dataSpecification,
}) {
  return getValidUnsignedPositiveInteger(
    displayPrompt: () {
      print("${inputPromptPrefix ?? ''}Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification: dataSpecification);
    },
  );
}

String inputValidText({
  String? inputPromptPrefix,
  required String dataSpecification,
}) {
  return getNonEmptyText(
    displayPrompt: () {
      print("${inputPromptPrefix ?? ''}Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification: dataSpecification);
    },
  );
}

double inputValidDouble({
  String? inputPromptPrefix,
  required String dataSpecification,
}) {
  return getValidUnsignedDouble(
    displayPrompt: () {
      print("${inputPromptPrefix ?? ''}Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification: dataSpecification);
    },
  );
}

DateTime inputValidTimeInNormalTimeFormat({
  String? inputPromptPrefix,
  required String dataSpecification,
}) {
  return getValidTimeInNormalTimeFormat(
    displayPrompt: () {
      print("${inputPromptPrefix ?? ''}Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification: dataSpecification);
    },
  );
}

String inputValidTimeInNormalTimeFormatAsText({
  String? inputPromptPrefix,
  required String dataSpecification,
}) {
  return normalTimeFormat.format(inputValidTimeInNormalTimeFormat(
    inputPromptPrefix: inputPromptPrefix,
    dataSpecification: dataSpecification,
  ));
}

void printInvalidInputMessage() {
  printInvalidMessage(dataSpecification: "Input Data");
}

void printComingSoonMessage() {
  print("Coming Soon...");
}

void printErrorMessage(String message) {
  print('Error : $message');
}

void printExitMessage(
    {void Function() actionsBeforeExecution = dummyFunction,
    void Function() actionsAfterExecution = dummyFunction}) {
  actionsBeforeExecution();
  print('Good Bye...');
  actionsAfterExecution();
}
