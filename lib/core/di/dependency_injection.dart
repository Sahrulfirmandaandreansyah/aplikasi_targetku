import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aplikasi_targetku/data/local/database.dart';

// Import DAOs & Repositories
import 'package:aplikasi_targetku/features/targets/data/daos/targets_dao.dart';
import 'package:aplikasi_targetku/features/targets/data/repositories/target_repository_impl.dart';
import 'package:aplikasi_targetku/features/targets/domain/repositories/target_repository.dart';
import 'package:aplikasi_targetku/features/transactions/data/daos/transactions_dao.dart';
import 'package:aplikasi_targetku/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:aplikasi_targetku/features/transactions/domain/repositories/transaction_repository.dart';

// 1. Provider Database (PERBAIKAN DI SINI)
final databaseProvider = Provider<AppDatabase>((ref) {
  // Langsung panggil class-nya, tidak perlu getAppDatabase()
  return AppDatabase(); 
});

// 2. Provider DAOs
final targetsDaoProvider = Provider<TargetsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TargetsDao(db);
});

final transactionsDaoProvider = Provider<TransactionsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TransactionsDao(db);
});

// 3. Provider Repositories
final targetRepositoryProvider = Provider<TargetRepository>((ref) {
  final dao = ref.watch(targetsDaoProvider);
  return TargetRepositoryImpl(dao);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dao = ref.watch(transactionsDaoProvider);
  return TransactionRepositoryImpl(dao);
});