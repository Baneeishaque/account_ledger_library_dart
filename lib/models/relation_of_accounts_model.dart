class RelationOfAccountsModel {
  RelationOfAccountsModel({
    required this.users,
  });

  RelationOfAccountsModel.fromJson(dynamic json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users.add(UserModel.fromJson(v));
      });
    }
  }

  late List<UserModel> users;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['users'] = users.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  String toString() {
    return 'RelationOfAccountsModal{users: $users}';
  }
}

class UserModel {
  UserModel({
    required this.userId,
    required this.accounts,
  });

  UserModel.fromJson(dynamic json) {
    userId = json['userId'];
    if (json['accounts'] != null) {
      accounts = [];
      json['accounts'].forEach((v) {
        accounts.add(AccountModel.fromJson(v));
      });
    }
  }

  late int userId;
  late List<AccountModel> accounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['accounts'] = accounts.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  String toString() {
    return 'Users{userId: $userId, accounts: $accounts}';
  }
}

class AccountModel {
  AccountModel({
    required this.accountId,
    required this.relations,
  });

  AccountModel.fromJson(dynamic json) {
    accountId = json['accountId'] != null ? json['accountId'].cast<int>() : [];
    if (json['relations'] != null) {
      relations = [];
      json['relations'].forEach((v) {
        relations.add(RelationModel.fromJson(v));
      });
    }
  }

  late List<int> accountId;
  late List<RelationModel> relations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accountId'] = accountId;
    map['relations'] = relations.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  String toString() {
    return 'Accounts{accountId: $accountId, relations: $relations}';
  }
}

class RelationModel {
  RelationModel({
    required this.indicator,
    required this.associatedAccountId,
  });

  RelationModel.fromJson(dynamic json) {
    indicator = json['indicator'];
    associatedAccountId = json['associatedAccountId'] != null
        ? json['associatedAccountId'].cast<int>()
        : [];
  }

  late String indicator;
  late List<int> associatedAccountId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['indicator'] = indicator;
    map['associatedAccountId'] = associatedAccountId;
    return map;
  }

  @override
  String toString() {
    return 'Relations{indicator: $indicator, associatedAccountId: $associatedAccountId}';
  }
}

class RelationOfAccountsNormalisedModel {
  Map<int, Map<int, List<RelationModel>>> userAccounts;

  RelationOfAccountsNormalisedModel({
    required this.userAccounts,
  });

  @override
  String toString() {
    return 'RelationOfAccountsNormalisedModal{userAccounts: $userAccounts}';
  }
}
