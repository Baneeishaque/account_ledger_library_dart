import 'dart:io';

import 'package:account_ledger_library/common_utils/date_time_utils.dart';
import 'package:integer/integer.dart';

import 'common_utils.dart';
import 'input_utils_interactive.dart';

String getNonEmptyText({
  required void Function() displayPrompt,
  void Function() invalidDataActions = dummyFunction,
}) {
  displayPrompt.call();
  String? data = stdin.readLineSync();
  if (data == null && data!.isEmpty) {
    invalidDataActions.call();
    return getNonEmptyText(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    );
  }
  return data;
}

String getValidUnsignedNumberAsText({
  required void Function() displayPrompt,
  void Function() invalidDataActions = dummyFunction,
}) {
  String data = getNonEmptyText(
    displayPrompt: displayPrompt,
    invalidDataActions: invalidDataActions,
  );
  if (data.contains('-')) {
    invalidDataActions.call();
    return getValidUnsignedNumberAsText(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    );
  }
  num? convertedData = num.tryParse(data);
  if (convertedData == null) {
    invalidDataActions.call();
    return getValidUnsignedNumberAsText(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    );
  }
  return data;
}

u32 getValidUnsignedInteger({
  required void Function() displayPrompt,
  void Function() invalidDataActions = dummyFunction,
}) {
  u32? convertedData = u32.tryParse(getValidUnsignedNumberAsText(
    displayPrompt: displayPrompt,
    invalidDataActions: invalidDataActions,
  ));
  if (convertedData == null) {
    invalidDataActions.call();
    return getValidUnsignedInteger(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    );
  }
  return convertedData;
}

u32 getValidUnsignedPositiveInteger({
  required void Function() displayPrompt,
  void Function() invalidDataActions = dummyFunction,
}) {
  u32 data = getValidUnsignedInteger(
    displayPrompt: displayPrompt,
    invalidDataActions: invalidDataActions,
  );
  if (data.value > 0) {
    return data;
  } else {
    invalidDataActions.call();
    return getValidUnsignedPositiveInteger(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    );
  }
}

double getValidUnsignedDouble({
  required void Function() displayPrompt,
  void Function() invalidDataActions = dummyFunction,
}) {
  double? convertedData = double.tryParse(getValidUnsignedNumberAsText(
    displayPrompt: displayPrompt,
    invalidDataActions: invalidDataActions,
  ));
  if (convertedData == null) {
    invalidDataActions.call();
    return getValidUnsignedDouble(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    );
  }
  return convertedData;
}

DateTime getValidTimeInNormalTimeFormat({
  required void Function() displayPrompt,
  void Function() invalidDataActions = dummyFunction,
}) {
  DateTime? convertedTime = normalTimeFormat.tryParse(getNonEmptyText(
    displayPrompt: displayPrompt,
    invalidDataActions: invalidDataActions,
  ));
  if (convertedTime == null) {
    invalidDataActions.call();
    return getValidTimeInNormalTimeFormat(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    );
  }
  return convertedTime;
}

void handleInput(
    {required void Function() displayPrompt,
    required void Function() invalidInputActions,
    required Map<String, void Function()> actionsWithKeys}) {
  displayPrompt.call();
  String? input = stdin.readLineSync();
  if (input == null) {
    invalidInputActions.call();
    handleInput(
        displayPrompt: displayPrompt,
        invalidInputActions: invalidInputActions,
        actionsWithKeys: actionsWithKeys);
  } else {
    if (actionsWithKeys.containsKey(input.toLowerCase())) {
      actionsWithKeys[input]!.call();
    } else if (actionsWithKeys.containsKey(input.toUpperCase())) {
      actionsWithKeys[input]!.call();
    } else {
      invalidInputActions.call();
      handleInput(
          displayPrompt: displayPrompt,
          invalidInputActions: invalidInputActions,
          actionsWithKeys: actionsWithKeys);
    }
  }
}

void printInvalidInputMessage() {
  printInvalidMessage("Input Data");
}

void printComingSoonMessage() {
  print("Coming Soon...");
}
