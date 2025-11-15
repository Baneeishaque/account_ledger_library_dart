import 'dart:convert';
import 'dart:io';

import 'package:integer/integer.dart';
import 'package:tuple/tuple.dart';

import 'common_utils/u32_utils.dart';
import 'models/accounts_with_execution_status_model.dart';
import 'models/relation_of_accounts_model.dart';
import 'utils/account_utils.dart';

RelationOfAccountsModel readRelationsOfAccountsJsonFile() {
  return RelationOfAccountsModel.fromJson(
    jsonDecode(File("relationOfAccounts.json").readAsStringSync()),
  );
}

RelationOfAccountsNormalisedModel readRelationsOfAccountsInNormalForm() {
  Map<u32, Map<u32, List<AccountRelationModel>>> usersNormalisedMap = {};

  RelationOfAccountsModel relationOfAccounts =
      readRelationsOfAccountsJsonFile();
  for (UserModel user in relationOfAccounts.users) {
    Map<u32, List<AccountRelationModel>> accountsNormalisedMap = {};

    for (AccountModel account in user.accounts) {
      for (u32 accountId in account.accountIds) {
        if (accountsNormalisedMap.containsKey(accountId)) {
          accountsNormalisedMap[accountId] =
              (accountsNormalisedMap[accountId]!) + account.relations;
        } else {
          accountsNormalisedMap[accountId] = account.relations;
        }
      }

      for (AccountRelationModel accountRelation in account.relations) {
        for (Tuple2<u32, String> associatedAccountId
            in accountRelation.associatedAccountIds) {
          if (accountsNormalisedMap.containsKey(associatedAccountId.item1)) {
            accountsNormalisedMap[associatedAccountId.item1] =
                (accountsNormalisedMap[associatedAccountId.item1]!) +
                    [
                      AccountRelationModel(
                        indicator: accountRelation.indicator,
                        associatedAccountIds:
                            getUnsignedIntegerListWithMetaTextFromUnsignedIntegers(
                          account.accountIds,
                        ),
                      ),
                    ];
          } else {
            accountsNormalisedMap[associatedAccountId.item1] = [
              AccountRelationModel(
                indicator: accountRelation.indicator,
                associatedAccountIds:
                    getUnsignedIntegerListWithMetaTextFromUnsignedIntegers(
                  account.accountIds,
                ),
              ),
            ];
          }
        }
      }
    }

    for (u32 userId in user.userIds) {
      usersNormalisedMap[userId] = accountsNormalisedMap;
    }
  }
  return RelationOfAccountsNormalisedModel(userAccounts: usersNormalisedMap);
}

List<AccountRelationModel>? getAccountRelations(
  u32 userId,
  u32 accountId,
  String transactionParticulars,
) {
  return (readRelationsOfAccountsInNormalForm())
      .userAccounts[userId]?[accountId]
      ?.where(
        (AccountRelationModel relation) =>
            transactionParticulars.toLowerCase().contains(relation.indicator),
      )
      .toList();
}

List<AccountRelationModel>? getDetailedAccountRelations(
  u32 userId,
  u32 accountId,
  String transactionParticulars,
  List<AccountHeadModel> accountHeads,
) {
  return (getDetailedRelationsOfAccounts(
    readRelationsOfAccountsInNormalForm(),
    accountHeads,
  ))
      .userAccounts[userId]?[accountId]
      ?.where(
        (AccountRelationModel relation) =>
            transactionParticulars.toLowerCase().contains(relation.indicator),
      )
      .toList();
}

RelationOfAccountsNormalisedModel getDetailedRelationsOfAccounts(
  RelationOfAccountsNormalisedModel relationOfAccounts,
  List<AccountHeadModel> accountHeads,
) {
  RelationOfAccountsNormalisedModel result = relationOfAccounts;
  relationOfAccounts.userAccounts.forEach((
    u32 userId,
    Map<u32, List<AccountRelationModel>> accounts,
  ) {
    accounts.forEach((
      u32 accountId,
      List<AccountRelationModel> accountRelations,
    ) {
      for (int i = 0; i < accountRelations.length; i++) {
        AccountRelationModel accountRelation = accountRelations[i];

        for (int j = 0; j < accountRelation.associatedAccountIds.length; j++) {
          u32 associatedAccountId =
              accountRelation.associatedAccountIds[j].item1;

          result.userAccounts[userId]![accountId]![i].associatedAccountIds[j] =
              Tuple2(
            associatedAccountId,
            accountHeads
                .firstWhere(
                  (AccountHeadModel accountHead) =>
                      accountHead.id == associatedAccountId,
                  orElse: () => dummyAccountHead,
                )
                .fullName,
          );
        }
      }
    });
  });

  return result;
}
