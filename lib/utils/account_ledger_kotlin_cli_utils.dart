import 'dart:io';

import '../common_utils/common_utils.dart';
import '../constants.dart';

String runAccountLedgerKotlinCliOperation(
    List<String> accountLedgerKotlinCliArguments,
    {void Function() actionsBeforeExecution = dummyFunction,
    void Function() actionsAfterExecution = dummyFunction}) {
  actionsBeforeExecution();
  String result = (Process.runSync(
    accountLedgerCliExecutable,
    accountLedgerKotlinCliArguments,
    environment: {
      "JAVA_HOME": r"C:\Users\dk\.jabba\jdk\openjdk@20.0.1",
    },
    workingDirectory: File(accountLedgerCliExecutable).parent.path,
  )).stdout;
  actionsAfterExecution();
  return result;
}
