import 'models/transaction_model.dart';
import 'transaction_api.dart';

void insertTransactionViaApi(TransactionModel transaction) {
  // print(transaction.toString());
  print(runAccountLedgerInsertTransactionOperation(transaction));
}
