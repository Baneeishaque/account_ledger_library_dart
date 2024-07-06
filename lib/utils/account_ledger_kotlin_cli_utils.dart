import 'dart:io';

import 'package:os_detect/os_detect.dart' as platform;

import '../common_utils/common_utils.dart';
import '../constants.dart';

String runAccountLedgerKotlinCliOperation(
    List<String> accountLedgerKotlinCliArguments,
    {void Function() actionsBeforeExecution = dummyFunction,
    void Function(String)? actionsAfterExecution}) {
  // print(accountLedgerKotlinCliArguments);
  actionsBeforeExecution();
  String result = (Process.runSync(
    accountLedgerCliExecutable,
    accountLedgerKotlinCliArguments,
    environment: platform.isWindows
        ? {
            "JAVA_HOME": r"C:\Users\dk\scoop\apps\jabba\current\jdk\oracle@22.0.1",
          }
        : {},
    workingDirectory: File(accountLedgerCliExecutable).parent.path,
  )).stdout;
  if (actionsAfterExecution != null) {
    actionsAfterExecution(result);
  }
  return result;
}
