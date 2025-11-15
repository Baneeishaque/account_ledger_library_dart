class AccountLedgerApiResultMessageModel {
  String newDateTime;
  AccountLedgerApiResultStatusModel accountLedgerApiResultStatus;

  AccountLedgerApiResultMessageModel(
    this.newDateTime,
    this.accountLedgerApiResultStatus,
  );

  @override
  String toString() {
    return 'AccountLedgerApiResultMessage{newDateTime: $newDateTime, accountLedgerApiResultStatus: $accountLedgerApiResultStatus}';
  }
}

class AccountLedgerApiResultStatusModel {
  late int status;
  String? error;

  AccountLedgerApiResultStatusModel({required this.status, this.error});

  AccountLedgerApiResultStatusModel.fromJson(Map<String, dynamic> json) {
    status = (json['status'] is String
        ? int.parse(json['status'])
        : json['status']);
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    return data;
  }

  @override
  String toString() {
    return 'AccountLedgerApiResultStatus{status: $status, error: $error}';
  }
}
