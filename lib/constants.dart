import "dart:io";

import "package:os_detect/os_detect.dart" as platform;

/// Path to the Account Ledger CLI executable.
///
/// Can be customized using the ACCOUNT_LEDGER_CLI_EXECUTABLE environment variable.
/// If not set, uses platform-specific defaults:
/// - Windows: C:\Programs\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat
/// - macOS: ${HOME}/Programs/Account-Ledger-Cli/bin/Account-Ledger-Cli
/// - Linux: /workspace/Account-Ledger-Cli/bin/Account-Ledger-Cli
String accountLedgerCliExecutable = Platform
        .environment['ACCOUNT_LEDGER_CLI_EXECUTABLE'] ??
    (platform.isWindows
        ? r"C:\Programs\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat"
        : (platform.isMacOS
            ? "${Platform.environment['HOME']}/Programs/Account-Ledger-Cli/bin/Account-Ledger-Cli"
            : '/workspace/Account-Ledger-Cli/bin/Account-Ledger-Cli'));

String oneTwoThreeOneText = "1 -> 2, 3 -> 1";
String oneTwoTwoThreeThreeFourFourOneText = "1 -> 2, 2 -> 3, 3 -> 4, 4 -> 1";
String oneTwoTwoThreeThreeFourText = "1 -> 2, 2 -> 3, 3 -> 4";
String oneTwoTwoThreeText = "1 -> 2, 2 -> 3";
String oneTwoTwoThreeThreeOneText = "1 -> 2, 2 -> 3, 3 -> 1";
String oneTwoTwoThreeThreeTwoTwoFourFourOneText =
    "1 -> 2, 2 -> 3, 3 -> 2, 2 -> 4, 4 -> 1";
String oneTwoTwoThreeThreeTwoTwoFourFourOneFourTwoText =
    "1 -> 2, 2 -> 3, 3 -> 2, 2 -> 4, 4 -> 1, 4 -> 2";
