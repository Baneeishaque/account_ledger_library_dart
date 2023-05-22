class AccountLedgerApiResultStatusModal {
  int? status;

  AccountLedgerApiResultStatusModal({this.status});

  AccountLedgerApiResultStatusModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}
