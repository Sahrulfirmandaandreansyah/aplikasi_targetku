import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:aplikasi_targetku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';

part 'target_detail_provider.g.dart';

class TargetDetailState {
  final TargetEntity target;
  final List<TransactionEntity> transactions;
  final double currentBalance;
  final double progress;

  TargetDetailState({
    required this.target,
    required this.transactions,
    required this.currentBalance,
    required this.progress,
  });
}

@riverpod
Stream<TargetDetailState> targetDetail(TargetDetailRef ref, int targetId) {
  // 1. Buat Controller untuk mengatur aliran data
  final controller = StreamController<TargetDetailState>();

  final targetRepo = ref.watch(targetRepositoryProvider);
  final txRepo = ref.watch(transactionRepositoryProvider);

  // Variabel untuk menyimpan data terakhir
  TargetEntity? latestTarget;
  List<TransactionEntity>? latestTransactions;

  // Fungsi: Gabungkan data & kirim ke UI
  void emitData() {
    if (latestTarget == null || latestTransactions == null) return;

    // Hitung Saldo
    double balance = 0;
    for (var tx in latestTransactions!) {
      if (tx.type == TransactionType.increase) {
        balance += tx.amount;
      } else {
        balance -= tx.amount;
      }
    }

    // Hitung Progress
    final progress = (latestTarget!.targetAmount > 0) 
        ? (balance / latestTarget!.targetAmount).clamp(0.0, 1.0) 
        : 0.0;

    // Kirim State Baru
    controller.add(TargetDetailState(
      target: latestTarget!,
      transactions: latestTransactions!,
      currentBalance: balance,
      progress: progress,
    ));
  }

  // 2. Listen Perubahan TARGET
  final subTarget = targetRepo.watchTargetById(targetId).listen((event) {
    event.fold(
      (failure) => controller.addError(failure.message),
      (data) {
        if (data == null) {
          controller.addError("Target tidak ditemukan");
        } else {
          latestTarget = data;
          emitData(); // Update UI
        }
      },
    );
  });

  // 3. Listen Perubahan TRANSAKSI
  final subTx = txRepo.watchTransactions(targetId).listen((event) {
    event.fold(
      (failure) => controller.addError(failure.message),
      (data) {
        latestTransactions = data;
        emitData(); // Update UI
      },
    );
  });

  // Bersihkan memori saat tidak dipakai
  ref.onDispose(() {
    subTarget.cancel();
    subTx.cancel();
    controller.close();
  });

  return controller.stream;
}