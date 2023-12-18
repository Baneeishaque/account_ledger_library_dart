import 'dart:convert';
import 'dart:io';

import 'package:account_ledger_library/modals/relation_of_accounts_modal.dart';

RelationOfAccountsModal readRelationsOfAccounts() {
  return RelationOfAccountsModal.fromJson(
      jsonDecode(File("relationOfAccounts.json").readAsStringSync()));
}

RelationOfAccountsNormalisedModal readRelationsOfAccountsInNormalForm() {
  Map<int, Map<int, List<Relations>>> usersNormalisedMap = {};

  RelationOfAccountsModal relationOfAccounts = readRelationsOfAccounts();
  for (Users user in relationOfAccounts.users) {
    Map<int, List<Relations>> accountsNormalisedMap = {};

    for (Accounts account in user.accounts) {
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
  return RelationOfAccountsNormalisedModal(userAccounts: usersNormalisedMap);
}
