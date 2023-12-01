class RelationOfAccountsModal {
  RelationOfAccountsModal({
    required this.users,
  });

  RelationOfAccountsModal.fromJson(dynamic json) {
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(Users.fromJson(v));
      });
    }
  }

  List<Users>? users;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() {
    return 'RelationOfAccountsModal{users: $users}';
  }
}

/// userId : 25
/// accounts : [{"accountId":[6,11],"relations":[{"indicator":"father","associatedAccountId":[38]},{"indicator":"irshad kuri","associatedAccountId":[5419]},{"indicator":"manuppa","associatedAccountId":[3341]},{"indicator":"farseen uber","associatedAccountId":[8740]},{"indicator":"kerala vision broadband","associatedAccountId":[5609]},{"indicator":"breakfast","associatedAccountId":[5619]},{"indicator":"lunch from mubarak hotel","associatedAccountId":[8859]},{"indicator":"ziyad cse","associatedAccountId":[72]},{"indicator":"lunch","associatedAccountId":[1851]},{"indicator":"for mother","associatedAccountId":[8763]}]},{"accountId":[11],"relations":[{"indicator":"paytm banee","associatedAccountId":[8799]}]},{"accountId":[8799],"relations":[{"indicator":"cashback","associatedAccountId":[8771]}]},{"accountId":[8809],"relations":[{"indicator":"profit","associatedAccountId":[8843]}]}]

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
        accounts?.add(Accounts.fromJson(v));
      });
    }
  }

  int? userId;
  List<Accounts>? accounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    if (accounts != null) {
      map['accounts'] = accounts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() {
    return 'Users{userId: $userId, accounts: $accounts}';
  }
}

/// accountId : [6,11]
/// relations : [{"indicator":"father","associatedAccountId":[38]},{"indicator":"irshad kuri","associatedAccountId":[5419]},{"indicator":"manuppa","associatedAccountId":[3341]},{"indicator":"farseen uber","associatedAccountId":[8740]},{"indicator":"kerala vision broadband","associatedAccountId":[5609]},{"indicator":"breakfast","associatedAccountId":[5619]},{"indicator":"lunch from mubarak hotel","associatedAccountId":[8859]},{"indicator":"ziyad cse","associatedAccountId":[72]},{"indicator":"lunch","associatedAccountId":[1851]},{"indicator":"for mother","associatedAccountId":[8763]}]

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
        relations?.add(Relations.fromJson(v));
      });
    }
  }

  List<int>? accountId;
  List<Relations>? relations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accountId'] = accountId;
    if (relations != null) {
      map['relations'] = relations?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() {
    return 'Accounts{accountId: $accountId, relations: $relations}';
  }
}

/// indicator : "father"
/// associatedAccountId : [38]

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

  String? indicator;
  List<int>? associatedAccountId;

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
