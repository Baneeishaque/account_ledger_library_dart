A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

## Configuration

### Account Ledger CLI Path

The library requires the Account Ledger CLI executable to be configured. You can specify the path in one of two ways:

1. **Using Environment Variable (Recommended)**:
   - Copy `.env_example` to `.env`
   - Set the `ACCOUNT_LEDGER_CLI_EXECUTABLE` variable to your CLI executable path:
     ```
     ACCOUNT_LEDGER_CLI_EXECUTABLE=/path/to/Account-Ledger-Cli/bin/Account-Ledger-Cli
     ```

2. **Using Default Paths**:
   - If no environment variable is set, the library will use platform-specific defaults:
     - Windows: `C:\Programs\Account-Ledger-Cli\bin\Account-Ledger-Cli.bat`
     - macOS: `/Users/dk/Programs/Account-Ledger-Cli/bin/Account-Ledger-Cli`
     - Linux: `/workspace/Account-Ledger-Cli/bin/Account-Ledger-Cli`
