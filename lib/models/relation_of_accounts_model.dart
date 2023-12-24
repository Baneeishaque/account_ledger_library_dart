import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import '../common_utils/u32_utils.dart';

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
  late List<u32> userIds;
  late List<AccountModel> accounts;

  UserModel({
    required this.userIds,
    required this.accounts,
  });

  UserModel.fromJson(dynamic json) {
    userIds = json['userIds'] != null
        ? getUnsignedIntegerList(json['userIds'].cast<int>())
        : [];
    if (json['accounts'] != null) {
      accounts = [];
      json['accounts'].forEach((v) {
        accounts.add(AccountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userIds;
    map['accounts'] = accounts.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  String toString() {
    return 'Users{userId: $userIds, accounts: $accounts}';
  }
}

class AccountModel {
  late List<u32> accountIds;
  late List<AccountRelationModel> relations;

  AccountModel({
    required this.accountIds,
    required this.relations,
  });

  AccountModel.fromJson(dynamic json) {
    accountIds = json['accountIds'] != null
        ? getUnsignedIntegerList(json['accountIds'].cast<int>())
        : [];
    if (json['relations'] != null) {
      relations = [];
      json['relations'].forEach((v) {
        relations.add(AccountRelationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accountId'] = accountIds;
    map['relations'] = relations.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  String toString() {
    return 'Accounts{accountId: $accountIds, relations: $relations}';
  }
}

class AccountRelationModel {
  late String indicator;
  late List<Tuple2<u32, String>> associatedAccountIds;

  AccountRelationModel({
    required this.indicator,
    required this.associatedAccountIds,
  });

  AccountRelationModel.fromJson(dynamic json) {
    indicator = json['indicator'];
    associatedAccountIds = json['associatedAccountId'] != null
        ? getUnsignedIntegerListWithMetaTextFromIntegers(
            json['associatedAccountId'].cast<int>())
        : [];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['indicator'] = indicator;
    map['associatedAccountId'] = associatedAccountIds;
    return map;
  }

  @override
  String toString() {
    return 'Relations{indicator: $indicator, associatedAccountId: $associatedAccountIds}';
  }
}

class RelationOfAccountsNormalisedModel {
  Map<u32, Map<u32, List<AccountRelationModel>>> userAccounts;

  RelationOfAccountsNormalisedModel({
    required this.userAccounts,
  });

  @override
  String toString() {
    return 'RelationOfAccountsNormalisedModal{userAccounts: $userAccounts}';
  }
}
