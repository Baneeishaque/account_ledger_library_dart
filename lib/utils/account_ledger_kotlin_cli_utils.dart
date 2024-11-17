import 'dart:io';

import 'package:os_detect/os_detect.dart' as platform;
import 'package:tuple/tuple.dart';

import '../common_utils/common_utils.dart';
import '../constants.dart';

Tuple2<bool, String> runAccountLedgerKotlinCliOperation(
    List<String> accountLedgerKotlinCliArguments,
    {void Function() actionsBeforeExecution = dummyFunction,
    void Function(String)? actionsAfterExecution}) {
  // print(accountLedgerKotlinCliArguments);
  actionsBeforeExecution();
  ProcessResult processResult = Process.runSync(
    accountLedgerCliExecutable,
    accountLedgerKotlinCliArguments,
    environment: platform.isWindows
        ? {
            "JAVA_HOME": r"C:\Users\dk\scoop\apps\jabba\current\jdk\oracle@22.0.1",
          }
        : {},
    workingDirectory: File(accountLedgerCliExecutable).parent.path,
  );
  if (processResult.exitCode == 0) {
    if (actionsAfterExecution != null) {
      actionsAfterExecution(processResult.stdout);
    }
    return Tuple2(true, processResult.stdout);
  } else {
    return Tuple2(false, processResult.stderr);
  }
}
