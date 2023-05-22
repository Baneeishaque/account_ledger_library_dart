import 'transaction_modal.dart';
import 'transaction_utils_api.dart';

void insertTransactionViaApi(TransactionModal transaction) {
  // print(transaction.toString());
  print(runAccountLedgerInsertTransactionOperation(transaction));
}
