import 'dart:convert';
import 'dart:io';

import 'package:account_ledger_library/modals/relation_of_accounts_modal.dart';

RelationOfAccountsModal readRelationsOfAccounts() {
  return RelationOfAccountsModal.fromJson(
      jsonDecode(File("relationOfAccounts.json").readAsStringSync()));
}

RelationOfAccountsNormalisedModal readRelationsOfAccountsInNormalForm() {
  List<UsersNormalisedModal> usersNormalisedList = List.empty(growable: true);

  RelationOfAccountsModal relationOfAccounts = readRelationsOfAccounts();
  relationOfAccounts.users?.forEach((user) {
    List<AccountsNormalisedModal> accountsNormalisedList =
        List.empty(growable: true);

    user.accounts?.forEach((account) {
      account.accountId?.forEach((accountId) {
        accountsNormalisedList.add(AccountsNormalisedModal(
            accountId: accountId, relations: account.relations!));
      });
    });

    usersNormalisedList.add(UsersNormalisedModal(
        userId: user.userId!, accounts: accountsNormalisedList));
  });
  return RelationOfAccountsNormalisedModal(users: usersNormalisedList);
}
