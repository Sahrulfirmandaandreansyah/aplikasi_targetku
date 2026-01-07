import 'dart:async'; // <--- INI YANG KURANG TADI
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
  // Controller untuk menggabungkan data dan mengirim ke UI
  final controller = StreamController<TargetDetailState>();

  final targetRepo = ref.watch(targetRepositoryProvider);
  final txRepo = ref.watch(transactionRepositoryProvider);

  // Variabel lokal untuk menyimpan state terakhir
  TargetEntity? latestTarget;
  List<TransactionEntity>? latestTransactions;

  // Fungsi helper untuk menghitung dan emit data
  void emitData() {
    if (latestTarget == null || latestTransactions == null) return;

    double balance = 0;
    for (var tx in latestTransactions!) {
      if (tx.type == TransactionType.increase) {
        balance += tx.amount;
      } else {
        balance -= tx.amount;
      }
    }

    // Kalkulasi Progress (0.0 - 1.0)
    final progress = (latestTarget!.targetAmount > 0)
        ? (balance / latestTarget!.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    controller.add(TargetDetailState(
      target: latestTarget!,
      transactions: latestTransactions!,
      currentBalance: balance,
      progress: progress,
    ));
  }

  // 1. Listen Target Stream
  final subTarget = targetRepo.watchTargetById(targetId).listen((event) {
    event.fold(
      (failure) => controller.addError(failure.message),
      (data) {
        if (data == null) {
          controller.addError("Target tidak ditemukan");
        } else {
          latestTarget = data;
          emitData();
        }
      },
    );
  });

  // 2. Listen Transaction Stream
  final subTx = txRepo.watchTransactions(targetId).listen((event) {
    event.fold(
      (failure) => controller.addError(failure.message),
      (data) {
        latestTransactions = data;
        emitData();
      },
    );
  });

  // Bersihkan listener saat provider dibuang (dispose)
  ref.onDispose(() {
    subTarget.cancel();
    subTx.cancel();
    controller.close();
  });

  return controller.stream;
}