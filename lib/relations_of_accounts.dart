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
  relationOfAccounts.users?.forEach((user) {
    Map<int, List<Relations>> accountsNormalisedMap = {};

    user.accounts?.forEach((account) {
      account.accountId?.forEach((accountId) {
        if (accountsNormalisedMap.containsKey(accountId)) {
          accountsNormalisedMap[accountId] =
              (accountsNormalisedMap[accountId]!) + account.relations!;
        } else {
          accountsNormalisedMap[accountId] = account.relations!;
        }
      });
    });

    usersNormalisedMap[user.userId!] = accountsNormalisedMap;
  });
  return RelationOfAccountsNormalisedModal(userAccounts: usersNormalisedMap);
}
