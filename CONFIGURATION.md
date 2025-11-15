# Configuration

## Account Ledger CLI Executable Path

The library uses an environment variable to locate the Account Ledger CLI executable, making it flexible for different installation locations across various systems.

### Environment Variable

Set the `ACCOUNT_LEDGER_CLI_EXECUTABLE` environment variable to specify the path to your Account Ledger CLI installation.

#### Linux/macOS

```bash
export ACCOUNT_LEDGER_CLI_EXECUTABLE="/path/to/Account-Ledger-Cli/bin/Account-Ledger-Cli"
```

To make it permanent, add the above line to your `~/.bashrc`, `~/.zshrc`, or equivalent shell configuration file.

#### Windows

```cmd
set ACCOUNT_LEDGER_CLI_EXECUTABLE=C:\Path\To\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat
```

Or for PowerShell:

```powershell
$env:ACCOUNT_LEDGER_CLI_EXECUTABLE="C:\Path\To\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat"
```

To make it permanent on Windows, set it as a system environment variable through System Properties > Advanced > Environment Variables.

### Default Paths

If the environment variable is not set, the library uses the following default paths:

- **Windows**: `C:\Programs\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat`
- **macOS**: `/Users/dk/Programs/Account-Ledger-Cli/bin/Account-Ledger-Cli`
- **Linux**: `/workspace/Account-Ledger-Cli/bin/Account-Ledger-Cli`

### Example

```dart
// The library will automatically use the environment variable if set
// or fall back to the platform-specific default

import 'package:account_ledger_library/constants.dart';

void main() {
  print('CLI executable path: $accountLedgerCliExecutable');
}
```
