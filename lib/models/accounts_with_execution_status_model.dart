import 'package:integer/integer.dart';

class AccountsWithExecutionStatusModel {
  late bool isOK;
  List<AccountHeadModel>? data;
  String? error;

  AccountsWithExecutionStatusModel({required this.isOK, this.data, this.error});

  AccountsWithExecutionStatusModel.fromJson(Map<String, dynamic> json) {
    isOK = json['isOK'];
    if (json['data'] != null) {
      data = <AccountHeadModel>[];
      json['data'].forEach((v) {
        data!.add(AccountHeadModel.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isOK'] = isOK;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    return data;
  }

  @override
  String toString() {
    return 'AccountsWithExecutionStatusModal{isOK: $isOK, data: $data, error: $error}';
  }
}

class AccountHeadModel {
  late u32 id;
  late String fullName;
  late String name;
  late u32 parentAccountId;
  late String accountType;
  late String notes;
  late String commodityType;
  late String commodityValue;
  late u32 ownerId;
  late String taxable;
  late String placeHolder;

  AccountHeadModel({
    required this.id,
    required this.fullName,
    required this.name,
    required this.parentAccountId,
    required this.accountType,
    required this.notes,
    required this.commodityType,
    required this.commodityValue,
    required this.ownerId,
    required this.taxable,
    required this.placeHolder,
  });

  AccountHeadModel.fromJson(Map<String, dynamic> json) {
    id = u32(int.parse(json['id'] ?? json['account_id']));
    fullName = json['fullName'] ?? json['full_name'];
    name = json['name'];
    parentAccountId = u32(
      int.parse(json['parentAccountId'] ?? json['parent_account_id']),
    );
    accountType = json['accountType'] ?? json['account_id'];
    notes = json['notes'] ?? "";
    commodityType = json['commodityType'] ?? json['commodity_type'];
    commodityValue = json['commodityValue'] ?? json['commodity_value'];
    ownerId = u32(int.parse(json['ownerId'] ?? json['owner_id']));
    taxable = json['taxable'];
    placeHolder = json['placeHolder'] ?? json['place_holder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['name'] = name;
    data['parentAccountId'] = parentAccountId;
    data['accountType'] = accountType;
    data['notes'] = notes;
    data['commodityType'] = commodityType;
    data['commodityValue'] = commodityValue;
    data['ownerId'] = ownerId;
    data['taxable'] = taxable;
    data['placeHolder'] = placeHolder;
    return data;
  }

  bool isEqual(AccountHeadModel otherAccountHead) {
    return id == otherAccountHead.id;
  }

  @override
  String toString() {
    return 'AccountHead{id: $id, fullName: $fullName, name: $name, parentAccountId: $parentAccountId, accountType: $accountType, notes: $notes, commodityType: $commodityType, commodityValue: $commodityValue, ownerId: $ownerId, taxable: $taxable, placeHolder: $placeHolder}';
  }
}
