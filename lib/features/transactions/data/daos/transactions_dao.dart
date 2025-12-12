import 'package:drift/drift.dart';
import 'package:aplikasi_targetku/data/local/database.dart';
import 'package:aplikasi_targetku/features/transactions/data/tables/transactions_table.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase> with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  // Method ini WAJIB ada agar Repository bisa memanggilnya
  Stream<List<Transaction>> watchTransactionsByTargetId(int targetId) {
    return (select(transactions)
          ..where((t) => t.targetId.equals(targetId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }
  
  // Method ini juga WAJIB ada
  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }
  
  // Method ini juga WAJIB ada
  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<double?> getTotalIncrease(int targetId) {
    return Future.value(0.0); // Placeholder MVP
  }
}
