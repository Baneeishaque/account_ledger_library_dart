import 'package:account_ledger_library/models/accounts_with_execution_status_model.dart';

class GetAccountsFromServerResponseModel {
  late int status;
  List<AccountHeadModel>? accounts;

  GetAccountsFromServerResponseModel({
    required this.status,
    required this.accounts,
  });

  GetAccountsFromServerResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['accounts'] != null) {
      accounts = <AccountHeadModel>[];
      json['accounts'].forEach((v) {
        accounts!.add(AccountHeadModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (accounts != null) {
      data['accounts'] = accounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
