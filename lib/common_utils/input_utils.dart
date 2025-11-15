import 'dart:io';

import 'package:integer/integer.dart';

import 'common_utils.dart';
import 'date_time_utils.dart';

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
  u32? convertedData = u32.tryParse(
    getValidUnsignedNumberAsText(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    ),
  );
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
  bool isZeroUsedAsBack = false,
}) {
  u32 data = getValidUnsignedInteger(
    displayPrompt: displayPrompt,
    invalidDataActions: invalidDataActions,
  );
  if (data.value > 0) {
    return data;
  } else {
    if (isZeroUsedAsBack && (data.value == 0)) {
      return u32(0);
    }
    invalidDataActions.call();
    return getValidUnsignedPositiveInteger(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
      isZeroUsedAsBack: isZeroUsedAsBack,
    );
  }
}

double getValidUnsignedDouble({
  required void Function() displayPrompt,
  void Function() invalidDataActions = dummyFunction,
}) {
  double? convertedData = double.tryParse(
    getValidUnsignedNumberAsText(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    ),
  );
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
  DateTime? convertedTime = normalTimeFormat.tryParse(
    getNonEmptyText(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    ),
  );
  if (convertedTime == null) {
    invalidDataActions.call();
    return getValidTimeInNormalTimeFormat(
      displayPrompt: displayPrompt,
      invalidDataActions: invalidDataActions,
    );
  }
  return convertedTime;
}

Future<void> handleInput({
  required void Function() displayPrompt,
  required void Function() invalidInputActions,
  required Map<String, Future<void> Function()> actionsWithKeys,
}) async {
  displayPrompt.call();
  String? input = stdin.readLineSync();
  if (input == null) {
    invalidInputActions.call();
    await handleInput(
      displayPrompt: displayPrompt,
      invalidInputActions: invalidInputActions,
      actionsWithKeys: actionsWithKeys,
    );
  } else {
    if (actionsWithKeys.containsKey(input.toLowerCase())) {
      await actionsWithKeys[input.toLowerCase()]!.call();
    } else if (actionsWithKeys.containsKey(input.toUpperCase())) {
      await actionsWithKeys[input.toUpperCase()]!.call();
    } else {
      invalidInputActions.call();
      await handleInput(
        displayPrompt: displayPrompt,
        invalidInputActions: invalidInputActions,
        actionsWithKeys: actionsWithKeys,
      );
    }
  }
}
