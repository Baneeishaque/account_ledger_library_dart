class RelationOfAccountsModal {
  RelationOfAccountsModal({
    required this.users,
  });

  RelationOfAccountsModal.fromJson(dynamic json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users.add(Users.fromJson(v));
      });
    }
  }

  late List<Users> users;

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

class Users {
  Users({
    required this.userId,
    required this.accounts,
  });

  Users.fromJson(dynamic json) {
    userId = json['userId'];
    if (json['accounts'] != null) {
      accounts = [];
      json['accounts'].forEach((v) {
        accounts.add(Accounts.fromJson(v));
      });
    }
  }

  late int userId;
  late List<Accounts> accounts;

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

class Accounts {
  Accounts({
    required this.accountId,
    required this.relations,
  });

  Accounts.fromJson(dynamic json) {
    accountId = json['accountId'] != null ? json['accountId'].cast<int>() : [];
    if (json['relations'] != null) {
      relations = [];
      json['relations'].forEach((v) {
        relations.add(Relations.fromJson(v));
      });
    }
  }

  late List<int> accountId;
  late List<Relations> relations;

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

class Relations {
  Relations({
    required this.indicator,
    required this.associatedAccountId,
  });

  Relations.fromJson(dynamic json) {
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

class RelationOfAccountsNormalisedModal {
  Map<int, Map<int, List<Relations>>> userAccounts;

  RelationOfAccountsNormalisedModal({
    required this.userAccounts,
  });

  @override
  String toString() {
    return 'RelationOfAccountsNormalisedModal{users: $userAccounts}';
  }
}
