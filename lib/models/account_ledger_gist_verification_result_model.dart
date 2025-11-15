import 'package:integer/integer.dart';

class AccountLedgerGistVerificationResultModel {
  bool status;
  AccountLedgerPageModel? failedAccountLedgerPage;

  AccountLedgerGistVerificationResultModel({
    required this.status,
    this.failedAccountLedgerPage,
  });
}

class AccountLedgerGistModel {
  late String userName;
  late List<AccountLedgerPageModel> accountLedgerPages;

  AccountLedgerGistModel({
    required this.userName,
    required this.accountLedgerPages,
  });

  AccountLedgerGistModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    if (json['accountLedgerPages'] != null) {
      accountLedgerPages = <AccountLedgerPageModel>[];
      json['accountLedgerPages'].forEach((v) {
        accountLedgerPages.add(AccountLedgerPageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['accountLedgerPages'] =
        accountLedgerPages.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'AccountLedgerGistModal{userName: $userName, accountLedgerPages: $accountLedgerPages}';
  }
}

class AccountLedgerPageModel {
  late u32 accountId;
  late List<AccountLedgerDatePageModel> accountLedgerDatePages;
  String? remarks;

  AccountLedgerPageModel({
    required this.accountId,
    required this.accountLedgerDatePages,
  });

  AccountLedgerPageModel.withRemarks({
    required this.accountId,
    required this.accountLedgerDatePages,
    required this.remarks,
  });

  AccountLedgerPageModel.fromJson(Map<String, dynamic> json) {
    accountId = u32(json['accountId']);
    if (json['transactionDatePages'] != null) {
      accountLedgerDatePages = <AccountLedgerDatePageModel>[];
      json['transactionDatePages'].forEach((v) {
        accountLedgerDatePages.add(AccountLedgerDatePageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['accountLedgerDatePages'] =
        accountLedgerDatePages.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'AccountLedgerPageModal{accountId: $accountId, accountLedgerDatePages: $accountLedgerDatePages${remarks != null ? 'remarks: $remarks' : ''}';
  }
}

class AccountLedgerDatePageModel {
  late String accountLedgerPageDate;
  double? initialBalanceOnDate;
  late List<TransactionOnDateModel> transactionsOnDate;
  double? finalBalanceOnDate;

  AccountLedgerDatePageModel({
    required this.accountLedgerPageDate,
    this.initialBalanceOnDate,
    required this.transactionsOnDate,
    this.finalBalanceOnDate,
  });

  AccountLedgerDatePageModel.fromJson(Map<String, dynamic> json) {
    accountLedgerPageDate = json['transactionDate'];
    initialBalanceOnDate = json['initialBalance'];
    if (json['transactions'] != null) {
      transactionsOnDate = <TransactionOnDateModel>[];
      json['transactions'].forEach((v) {
        transactionsOnDate.add(TransactionOnDateModel.fromJson(v));
      });
    }
    finalBalanceOnDate = json['finalBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountLedgerPageDate'] = accountLedgerPageDate;
    data['initialBalanceOnDate'] = initialBalanceOnDate;
    data['transactionsOnDate'] =
        transactionsOnDate.map((v) => v.toJson()).toList();
    data['finalBalanceOnDate'] = finalBalanceOnDate;
    return data;
  }

  @override
  String toString() {
    return 'AccountLedgerDatePageModal{accountLedgerPageDate: $accountLedgerPageDate, initialBalanceOnDate: $initialBalanceOnDate, transactionsOnDate: $transactionsOnDate, finalBalanceOnDate: $finalBalanceOnDate}';
  }
}

class TransactionOnDateModel {
  late String transactionParticulars;
  late double transactionAmount;

  TransactionOnDateModel({
    required this.transactionParticulars,
    required this.transactionAmount,
  });

  TransactionOnDateModel.fromJson(Map<String, dynamic> json) {
    transactionParticulars = json['transactionParticulars'];
    transactionAmount = json['transactionAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionParticulars'] = transactionParticulars;
    data['transactionAmount'] = transactionAmount;
    return data;
  }

  @override
  String toString() {
    return 'TransactionOnDateModal{transactionParticulars: $transactionParticulars, transactionAmount: $transactionAmount}';
  }
}
