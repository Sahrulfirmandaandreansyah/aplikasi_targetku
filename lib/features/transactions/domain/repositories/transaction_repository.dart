import 'package:fpdart/fpdart.dart';
import 'package:aplikasi_targetku/core/errors/failures.dart';
import 'package:aplikasi_targetku/features/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  // Ambil transaksi berdasarkan Target ID
  Stream<Either<Failure, List<TransactionEntity>>> watchTransactions(int targetId);
  
  // Tambah Transaksi
  Future<Either<Failure, int>> addTransaction(TransactionEntity transaction);
  
  // Hapus Transaksi
  Future<Either<Failure, int>> deleteTransaction(int id);
}
