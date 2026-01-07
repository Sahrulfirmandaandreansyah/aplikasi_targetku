import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
// IMPORT PROVIDER TARGET LIST & DETAIL UNTUK DI-REFRESH
import 'package:aplikasi_targetku/features/targets/presentation/providers/target_list_provider.dart';
import 'package:aplikasi_targetku/features/targets/presentation/providers/target_detail_provider.dart';

part 'transaction_form_provider.g.dart';

@riverpod
class TransactionFormNotifier extends _$TransactionFormNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> addTransaction({
    required int targetId,
    required String amountStr,
    required TransactionType type,
    String? description,
  }) async {
    state = const AsyncLoading();

    // 1. Validasi Input
    final double? amount = double.tryParse(amountStr.replaceAll(RegExp(r'[^0-9]'), ''));
    if (amount == null || amount <= 0) {
      state = const AsyncError("Nominal tidak valid", StackTrace.empty);
      return false;
    }

    final newTx = TransactionEntity(
      id: 0,
      targetId: targetId,
      amount: amount,
      type: type,
      description: description,
      date: DateTime.now(),
    );

    final txRepo = ref.read(transactionRepositoryProvider);
    
    // 2. SIMPAN TRANSAKSI
    final result = await txRepo.addTransaction(newTx);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (success) {
        // SUKSES SIMPAN
        state = const AsyncData(null);
        
        // 3. FORCE REFRESH UI (SOLUSI MASALAH ANDA)
        // Menyuruh Provider Halaman Detail & List untuk ambil data ulang SEKARANG
        ref.invalidate(targetDetailProvider(targetId)); 
        ref.invalidate(targetListProvider); 

        // 4. Update Status Target (Completed) di background
        _checkAndCompleteTarget(targetId);
        
        return true;
      },
    );
  }

  Future<void> _checkAndCompleteTarget(int targetId) async {
    try {
      // Tunggu sebentar biar DB stabil
      await Future.delayed(const Duration(milliseconds: 200));

      final targetRepo = ref.read(targetRepositoryProvider);
      final txRepo = ref.read(transactionRepositoryProvider);

      final targetResult = await targetRepo.watchTargetById(targetId).first;
      final txResult = await txRepo.watchTransactions(targetId).first;

      final TargetEntity? target = targetResult.fold((l) => null, (r) => r);
      final List<TransactionEntity> transactions = txResult.fold((l) => [], (r) => r);

      if (target != null) {
        double balance = 0;
        for (var t in transactions) {
          if (t.type == TransactionType.increase) {
            balance += t.amount;
          } else {
            balance -= t.amount;
          }
        }

        bool statusChanged = false;

        // LOGIKA PINDAH STATUS
        if (balance >= target.targetAmount && target.status == TargetStatus.inProgress) {
          final completedTarget = target.copyWith(
            status: TargetStatus.completed,
            completedAt: DateTime.now(),
          );
          await targetRepo.updateTarget(completedTarget);
          statusChanged = true;
        } 
        else if (balance < target.targetAmount && target.status == TargetStatus.completed) {
          final activeTarget = target.copyWith(
            status: TargetStatus.inProgress,
            completedAt: null,
          );
          await targetRepo.updateTarget(activeTarget);
          statusChanged = true;
        }

        // Jika status berubah, refresh List Provider lagi agar kartu pindah tab
        if (statusChanged) {
          ref.invalidate(targetListProvider);
        }
      }
    } catch (e) {
      print("Error background update: $e");
    }
  }
}