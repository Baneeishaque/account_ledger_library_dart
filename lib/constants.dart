import "package:dotenv/dotenv.dart";
import "package:os_detect/os_detect.dart" as platform;

String get accountLedgerCliExecutable {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  // Try to get from environment variable first
  if (env.isDefined('ACCOUNT_LEDGER_CLI_EXECUTABLE')) {
    return env['ACCOUNT_LEDGER_CLI_EXECUTABLE']!;
  }

  // Fallback to platform-specific defaults
  return platform.isWindows
      ? r"C:\Programs\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat"
      : (platform.isMacOS
          ? "/Users/dk/Programs/Account-Ledger-Cli/bin/Account-Ledger-Cli"
          : '/workspace/Account-Ledger-Cli/bin/Account-Ledger-Cli');
}

String oneTwoThreeOneText = "1 -> 2, 3 -> 1";
String oneTwoTwoThreeThreeFourFourOneText = "1 -> 2, 2 -> 3, 3 -> 4, 4 -> 1";
String oneTwoTwoThreeThreeFourText = "1 -> 2, 2 -> 3, 3 -> 4";
String oneTwoTwoThreeText = "1 -> 2, 2 -> 3";
String oneTwoTwoThreeThreeOneText = "1 -> 2, 2 -> 3, 3 -> 1";
String oneTwoTwoThreeThreeTwoTwoFourFourOneText =
    "1 -> 2, 2 -> 3, 3 -> 2, 2 -> 4, 4 -> 1";
String oneTwoTwoThreeThreeTwoTwoFourFourOneFourTwoText =
    "1 -> 2, 2 -> 3, 3 -> 2, 2 -> 4, 4 -> 1, 4 -> 2";
