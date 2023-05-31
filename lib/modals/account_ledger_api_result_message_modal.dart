class AccountLedgerApiResultMessageModal {
  String? newDateTime;
  AccountLedgerApiResultStatusModal? accountLedgerApiResultStatus;

  AccountLedgerApiResultMessageModal(
      this.newDateTime, this.accountLedgerApiResultStatus);
}

class AccountLedgerApiResultStatusModal {
  int? status;
  String? error;

  AccountLedgerApiResultStatusModal({this.status, this.error});

  AccountLedgerApiResultStatusModal.fromJson(Map<String, dynamic> json) {
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
