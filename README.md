# Account Ledger Library Dart

[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/github/license/Baneeishaque/account_ledger_library_dart)](LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/Baneeishaque/account_ledger_library_dart)](https://github.com/Baneeishaque/account_ledger_library_dart/issues)

A Dart library for account ledger management with CLI functionality. This library provides comprehensive transaction handling, GitHub Gist API integration, and cross-platform support.

## Features

- **Account Ledger Management**: Manage financial accounts and ledgers
- **Transaction Processing**: Handle single, two-way, and multi-party transactions
- **GitHub Gist Integration**: Store and retrieve ledger data via GitHub Gist API
- **HTTP API Client**: RESTful API integration for remote operations
- **CLI Interface**: Command-line interface for interactive operations
- **Cross-Platform**: Supports Windows, macOS, and Linux
- **MySQL Utilities**: Database utilities for MySQL integration
- **JSON Data Models**: Structured data handling with JSON serialization

## Project Structure

```
├── bin/                    # CLI entry point
├── lib/                    # Library source code
│   ├── common_utils/       # Common utility functions
│   ├── models/             # Data models
│   └── utils/              # Additional utilities
├── api/                    # API related files
└── test/                   # Unit tests
```

## Getting Started

### Prerequisites

- Dart SDK >= 3.3.0

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  account_ledger_library:
    git:
      url: https://github.com/Baneeishaque/account_ledger_library_dart.git
```

### Usage

```dart
import 'package:account_ledger_library/account_ledger_cli.dart';

void main() async {
  await startAccountLedgerCli();
}
```

## Configuration

See [CONFIGURATION.md](CONFIGURATION.md) for detailed configuration instructions, including how to set up the Account Ledger CLI executable path.

## GitHub Topics

For information about GitHub topics and tags for this repository, including various methods to add them, see [GITHUB_TOPICS.md](GITHUB_TOPICS.md).

## Dependencies

- [integer](https://pub.dev/packages/integer) - Integer handling
- [intl](https://pub.dev/packages/intl) - Internationalization support
- [tuple](https://pub.dev/packages/tuple) - Tuple data structures
- [os_detect](https://pub.dev/packages/os_detect) - Platform detection
- [http](https://pub.dev/packages/http) - HTTP client
- [dotenv](https://pub.dev/packages/dotenv) - Environment variable handling

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source. See the repository for license details.
