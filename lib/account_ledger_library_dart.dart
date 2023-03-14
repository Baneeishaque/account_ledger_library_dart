import 'dart:io';

Future<String> runAccountLedgerGistOperation() async {
  return (await Process.run(
    r"C:\Programs\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat",
    ["Gist"],
    workingDirectory: r"C:\Programs\Account-Ledger-Cli\bin",
  ))
      .stdout;
}
