class AccountsWithExecutionStatus {
  bool? isOK;
  List<Data>? data;
  String? error;

  AccountsWithExecutionStatus({this.isOK, this.data, this.error});

  AccountsWithExecutionStatus.fromJson(Map<String, dynamic> json) {
    isOK = json['isOK'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
}

class Data {
  int? id;
  String? fullName;
  String? name;
  int? parentAccountId;
  String? accountType;
  String? notes;
  String? commodityType;
  String? commodityValue;
  int? ownerId;
  String? taxable;
  String? placeHolder;

  Data(
      {this.id,
      this.fullName,
      this.name,
      this.parentAccountId,
      this.accountType,
      this.notes,
      this.commodityType,
      this.commodityValue,
      this.ownerId,
      this.taxable,
      this.placeHolder});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    name = json['name'];
    parentAccountId = json['parentAccountId'];
    accountType = json['accountType'];
    notes = json['notes'];
    commodityType = json['commodityType'];
    commodityValue = json['commodityValue'];
    ownerId = json['ownerId'];
    taxable = json['taxable'];
    placeHolder = json['placeHolder'];
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
}
