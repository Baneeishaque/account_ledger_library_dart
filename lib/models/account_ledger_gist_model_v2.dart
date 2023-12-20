import 'package:integer/integer.dart';

import 'account_ledger_gist_verification_result_model.dart';

class AccountLedgerGistV2Model extends AccountLedgerGistModel {
  late u32 userId;

  AccountLedgerGistV2Model({
    required super.userName,
    required this.userId,
    required super.accountLedgerPages,
  });

  AccountLedgerGistV2Model.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    userName = json['userName'];
    userId = u32(json['userId']);
    if (json['accountLedgerPages'] != null) {
      accountLedgerPages = <AccountLedgerPageModel>[];
      json['accountLedgerPages'].forEach((v) {
        accountLedgerPages.add(AccountLedgerPageModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['userId'] = userId;
    data['accountLedgerPages'] =
        accountLedgerPages.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'AccountLedgerGistModal{userName: $userName, userId: $userId, accountLedgerPages: $accountLedgerPages}';
  }
}
