import 'dart:io';

import '../constants.dart';

String runAccountLedgerKotlinCliOperation(
    List<String> accountLedgerKotlinCliArguments) {
  return (Process.runSync(
    accountLedgerCliExecutable,
    accountLedgerKotlinCliArguments,
    environment: {
      "JAVA_HOME": r"C:\Users\dk\.jabba\jdk\openjdk@20.0.1",
    },
    workingDirectory: File(accountLedgerCliExecutable).parent.path,
  )).stdout;
}
