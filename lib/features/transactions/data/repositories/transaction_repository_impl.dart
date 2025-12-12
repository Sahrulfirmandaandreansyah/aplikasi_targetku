import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:aplikasi_targetku/core/errors/failures.dart';
import 'package:aplikasi_targetku/data/local/database.dart';
import 'package:aplikasi_targetku/features/transactions/data/daos/transactions_dao.dart';
import 'package:aplikasi_targetku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:aplikasi_targetku/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsDao _dao;

  TransactionRepositoryImpl(this._dao);

  @override
  Stream<Either<Failure, List<TransactionEntity>>> watchTransactions(int targetId) {
    return _dao.watchTransactionsByTargetId(targetId).map((list) {
      try {
        final entities = list.map((t) => TransactionEntity(
          id: t.id,
          targetId: t.targetId,
          amount: t.amount,
          type: t.type,
          description: t.description,
          date: t.date,
        )).toList();
        // Tipe Eksplisit
        return Right<Failure, List<TransactionEntity>>(entities);
      } catch (e) {
        return Left<Failure, List<TransactionEntity>>(DatabaseFailure("Gagal parsing: $e"));
      }
    }).handleError((e) { 
        // GUNAKAN handleError, BUKAN catchError
        return Left<Failure, List<TransactionEntity>>(DatabaseFailure(e.toString()));
    });
  }

  @override
  Future<Either<Failure, int>> addTransaction(TransactionEntity transaction) async {
    try {
      final companion = TransactionsCompanion(
        targetId: Value(transaction.targetId),
        amount: Value(transaction.amount),
        type: Value(transaction.type),
        description: Value(transaction.description),
        date: Value(transaction.date),
      );
      final id = await _dao.insertTransaction(companion);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteTransaction(int id) async {
    try {
      final result = await _dao.deleteTransaction(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
