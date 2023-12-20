import 'dart:convert';
import 'dart:io';

import 'models/relation_of_accounts_model.dart';

RelationOfAccountsModel readRelationsOfAccounts() {
  return RelationOfAccountsModel.fromJson(
      jsonDecode(File("relationOfAccounts.json").readAsStringSync()));
}

RelationOfAccountsNormalisedModel readRelationsOfAccountsInNormalForm() {
  Map<int, Map<int, List<RelationModel>>> usersNormalisedMap = {};

  RelationOfAccountsModel relationOfAccounts = readRelationsOfAccounts();
  for (UserModel user in relationOfAccounts.users) {
    Map<int, List<RelationModel>> accountsNormalisedMap = {};

    for (AccountModel account in user.accounts) {
      for (int accountId in account.accountId) {
        if (accountsNormalisedMap.containsKey(accountId)) {
          accountsNormalisedMap[accountId] =
              (accountsNormalisedMap[accountId]!) + account.relations;
        } else {
          accountsNormalisedMap[accountId] = account.relations;
        }
      }
    }

    usersNormalisedMap[user.userId] = accountsNormalisedMap;
  }
  return RelationOfAccountsNormalisedModel(userAccounts: usersNormalisedMap);
}

List<RelationModel>? getAccountRelationList(
    int userId, int accountId, String transactionParticulars) {
  RelationOfAccountsNormalisedModel relationOfAccountsNormalised =
      readRelationsOfAccountsInNormalForm();
  return relationOfAccountsNormalised.userAccounts[userId]?[accountId]
      ?.where((RelationModel relation) =>
          transactionParticulars.toLowerCase().contains(relation.indicator))
      .toList();
}
