import 'package:integer/integer.dart';

import 'input_utils.dart';

void printInvalidMessage(String dataSpecification) {
  print("Error : Please Enter Valid $dataSpecification...");
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

u32 inputValidUnsignedInteger({required String dataSpecification}) {
  return getValidUnsignedInteger(
    displayPrompt: () {
      print("Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification);
    },
  );
}

u32 inputValidUnsignedPositiveInteger({required String dataSpecification}) {
  return getValidUnsignedPositiveInteger(
    displayPrompt: () {
      print("Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification);
    },
  );
}

String inputValidText({required String dataSpecification}) {
  return getNonEmptyText(
    displayPrompt: () {
      print("Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification);
    },
  );
}

double inputValidDouble({required String dataSpecification}) {
  return getValidUnsignedDouble(
    displayPrompt: () {
      print("Enter $dataSpecification : ");
    },
    invalidDataActions: () {
      printInvalidMessage(dataSpecification);
    },
  );
}
