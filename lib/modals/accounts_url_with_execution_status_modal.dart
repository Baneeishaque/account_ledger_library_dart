class AccountsUrlWithExecutionStatusModal {
  late int status;
  String? textData;
  String? error;

  AccountsUrlWithExecutionStatusModal({
    required this.status,
    this.textData,
    this.error,
  });

  AccountsUrlWithExecutionStatusModal.fromJson(dynamic json) {
    status = json['status'];
    textData = json['textData'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['textData'] = textData;
    map['error'] = error;
    return map;
  }
}
