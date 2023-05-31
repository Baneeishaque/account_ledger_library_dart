class AccountLedgerGistVerificationResultModal {
  bool status;
  List<AccountLedgerPageModal>? failedAccountLedgerPages;

  AccountLedgerGistVerificationResultModal(
      {required this.status, this.failedAccountLedgerPages});
}

class AccountLedgerGistModal {
  String? userName;
  List<AccountLedgerPageModal>? accountLedgerPages;

  AccountLedgerGistModal(
      {required this.userName, required this.accountLedgerPages});

  AccountLedgerGistModal.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    if (json['accountLedgerPages'] != null) {
      accountLedgerPages = <AccountLedgerPageModal>[];
      json['accountLedgerPages'].forEach((v) {
        accountLedgerPages!.add(AccountLedgerPageModal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    if (accountLedgerPages != null) {
      data['accountLedgerPages'] =
          accountLedgerPages!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'AccountLedgerGistModal{userName: $userName, accountLedgerPages: $accountLedgerPages}';
  }
}

class AccountLedgerPageModal {
  int? accountId;
  List<AccountLedgerDatePageModal>? accountLedgerDatePages;

  AccountLedgerPageModal(
      {required this.accountId, required this.accountLedgerDatePages});

  AccountLedgerPageModal.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    if (json['accountLedgerDatePages'] != null) {
      accountLedgerDatePages = <AccountLedgerDatePageModal>[];
      json['accountLedgerDatePages'].forEach((v) {
        accountLedgerDatePages!.add(AccountLedgerDatePageModal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    if (accountLedgerDatePages != null) {
      data['accountLedgerDatePages'] =
          accountLedgerDatePages!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'AccountLedgerPageModal{accountId: $accountId, accountLedgerDatePages: $accountLedgerDatePages}';
  }
}

class AccountLedgerDatePageModal {
  String? accountLedgerPageDate;
  double? initialBalanceOnDate;
  List<TransactionOnDateModal>? transactionsOnDate;
  double? finalBalanceOnDate;

  AccountLedgerDatePageModal(
      {required this.accountLedgerPageDate,
      this.initialBalanceOnDate,
      required this.transactionsOnDate,
      this.finalBalanceOnDate});

  AccountLedgerDatePageModal.fromJson(Map<String, dynamic> json) {
    accountLedgerPageDate = json['accountLedgerPageDate'];
    initialBalanceOnDate = json['initialBalanceOnDate'];
    if (json['transactionsOnDate'] != null) {
      transactionsOnDate = <TransactionOnDateModal>[];
      json['transactionsOnDate'].forEach((v) {
        transactionsOnDate!.add(TransactionOnDateModal.fromJson(v));
      });
    }
    finalBalanceOnDate = json['finalBalanceOnDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountLedgerPageDate'] = accountLedgerPageDate;
    data['initialBalanceOnDate'] = initialBalanceOnDate;
    if (transactionsOnDate != null) {
      data['transactionsOnDate'] =
          transactionsOnDate!.map((v) => v.toJson()).toList();
    }
    data['finalBalanceOnDate'] = finalBalanceOnDate;
    return data;
  }

  @override
  String toString() {
    return 'AccountLedgerDatePageModal{accountLedgerPageDate: $accountLedgerPageDate, initialBalanceOnDate: $initialBalanceOnDate, transactionsOnDate: $transactionsOnDate, finalBalanceOnDate: $finalBalanceOnDate}';
  }
}

class TransactionOnDateModal {
  String? transactionParticulars;
  double? transactionAmount;

  TransactionOnDateModal(
      {required this.transactionParticulars, required this.transactionAmount});

  TransactionOnDateModal.fromJson(Map<String, dynamic> json) {
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
