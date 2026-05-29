import 'package:integer/integer.dart';

/// Reusable account-validation guards intended to be invoked by every
/// Dart consumer (Flutter desktop, Flutter mobile) BEFORE issuing an
/// account INSERT or UPDATE request, so the request fails fast at the
/// client boundary instead of round-tripping through the network and DB.
///
/// These guards are the app-layer half of defense-in-depth against
/// rules that the SQL foreign key alone cannot express. The DB-side
/// half lives in the trg_accounts_no_self_parent_ins / _upd triggers
/// on the accounts table (installed per the
/// mariadb-check-autoincrement-trigger-fallback skill — CHECK was not
/// viable because MariaDB error 1901 forbids referencing
/// AUTO_INCREMENT primary keys from CHECK constraints). Both halves
/// MUST be present: the trigger catches direct-DB and buggy-client
/// writes; the app guard fails fast so the HTTP+DB round-trip is
/// avoided on misuse.

/// Returns true when [parentAccountId] is a valid parent reference
/// for an account whose primary key is [accountId]. A null parent is
/// always valid (root account). A non-null parent equal to the
/// account's own id is INVALID — that would create a self-referential
/// row rejected by the DB triggers with SQLSTATE 45000.
bool isValidParentAccountId({
  required u32 accountId,
  u32? parentAccountId,
}) =>
    parentAccountId == null || parentAccountId.value != accountId.value;

/// Throws [ArgumentError] with a descriptive message when the parent
/// reference is invalid; returns normally on success. Use when the
/// caller wants the failure to propagate as an exception rather than
/// a boolean.
void requireValidParentAccountId({
  required u32 accountId,
  u32? parentAccountId,
}) {
  if (!isValidParentAccountId(
    accountId: accountId,
    parentAccountId: parentAccountId,
  )) {
    throw ArgumentError(
      'parent_account_id (${parentAccountId?.value}) must not equal '
      'account_id (${accountId.value}) (self-reference forbidden)',
    );
  }
}
