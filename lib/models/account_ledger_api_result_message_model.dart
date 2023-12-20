class AccountLedgerApiResultMessageModel {
  String newDateTime;
  AccountLedgerApiResultStatusModel accountLedgerApiResultStatus;

  AccountLedgerApiResultMessageModel(
      this.newDateTime, this.accountLedgerApiResultStatus);
}

class AccountLedgerApiResultStatusModel {
  late int status;
  String? error;

  AccountLedgerApiResultStatusModel({required this.status, this.error});

  AccountLedgerApiResultStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    return data;
  }
}
