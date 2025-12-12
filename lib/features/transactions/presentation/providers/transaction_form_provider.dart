import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/transactions/domain/entities/transaction_entity.dart';

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

    final double? amount = double.tryParse(amountStr.replaceAll(RegExp(r'[^0-9]'), ''));
    if (amount == null || amount <= 0) {
      state = AsyncError("Nominal tidak valid", StackTrace.current);
      return false;
    }

    final txRepo = ref.read(transactionRepositoryProvider);

    final newTx = TransactionEntity(
      id: 0,
      targetId: targetId,
      amount: amount,
      type: type,
      description: description,
      date: DateTime.now(),
    );

    final result = await txRepo.addTransaction(newTx);

    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (success) {
        state = const AsyncData(null);
        return true;
      },
    );
  }
}