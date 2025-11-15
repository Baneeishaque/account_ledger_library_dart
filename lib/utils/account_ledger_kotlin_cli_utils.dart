import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:os_detect/os_detect.dart' as platform;
import 'package:tuple/tuple.dart';

import '../common_utils/common_utils.dart';
import '../constants.dart';

Tuple2<bool, String> runAccountLedgerKotlinCliOperation(
  List<String> accountLedgerKotlinCliArguments, {
  void Function() actionsBeforeExecution = dummyFunction,
  void Function(String)? actionsAfterExecution,
}) {
  // print(accountLedgerKotlinCliArguments);
  var env = DotEnv(includePlatformEnvironment: true)..load();
  actionsBeforeExecution();
  ProcessResult processResult = Process.runSync(
    accountLedgerCliExecutable,
    accountLedgerKotlinCliArguments,
    environment: (platform.isWindows && env.isDefined('JAVA_HOME_WINDOWS'))
        ? {"JAVA_HOME": env['JAVA_HOME_WINDOWS']!}
        : ((platform.isMacOS && env.isDefined('JAVA_HOME_MAC'))
              ? {"JAVA_HOME": env['JAVA_HOME_MAC']!}
              : ((platform.isLinux && env.isDefined('JAVA_HOME_LINUX'))
                    ? {"JAVA_HOME": env['JAVA_HOME_LINUX']!}
                    : {})),
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
