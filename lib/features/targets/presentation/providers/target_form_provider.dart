import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:aplikasi_targetku/core/services/notification_service.dart';

part 'target_form_provider.g.dart';

@riverpod
class TargetFormNotifier extends _$TargetFormNotifier {
  @override
  FutureOr<void> build() {
    // State awal idle
  }

  // --- LOGIC MEMBUAT TARGET BARU (CREATE) ---
  Future<bool> createTarget({
    required String name,
    required String amountStr,
    required String plannedAmountStr,
    required PlanFrequency frequency,
    String? imagePath,
  }) async {
    state = const AsyncLoading();

    // 1. Validasi
    final double? amount = double.tryParse(amountStr.replaceAll(RegExp(r'[^0-9]'), ''));
    final double? planned = double.tryParse(plannedAmountStr.replaceAll(RegExp(r'[^0-9]'), ''));

    if (amount == null || planned == null) {
      state = const AsyncError("Nominal tidak valid", StackTrace.empty);
      return false;
    }

    // 2. Buat Entity
    final newTarget = TargetEntity(
      id: 0,
      name: name,
      targetAmount: amount,
      plannedAmount: planned,
      planFrequency: frequency,
      imageUrl: imagePath,
      status: TargetStatus.inProgress,
      createdAt: DateTime.now(),
    );

    // 3. Panggil Repository
    final repository = ref.read(targetRepositoryProvider);
    final result = await repository.addTarget(newTarget);

    // 4. Handle Hasil
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (successId) {
        // --- JADWALKAN NOTIFIKASI ---
        final now = DateTime.now();
        // Jadwalkan besok jam 09:00
        final scheduledDate = DateTime(now.year, now.month, now.day + 1, 9, 0); 
        
        NotificationService().scheduleNotification(
          id: successId,
          title: "Yuk Nabung buat $name!",
          body: "Ingat tujuanmu, sedikit demi sedikit lama-lama menjadi bukit ⛰️",
          scheduledTime: scheduledDate,
        );
        // ----------------------------

        state = const AsyncData(null); 
        return true;
      },
    );
  }

  // --- LOGIC MENGEDIT TARGET (EDIT) ---
  Future<bool> editTarget({
    required TargetEntity originalTarget,
    required String name,
    required String amountStr,
    required String plannedAmountStr,
    required PlanFrequency frequency,
    String? imagePath,
  }) async {
    state = const AsyncLoading();

    final double? amount = double.tryParse(amountStr.replaceAll(RegExp(r'[^0-9]'), ''));
    final double? planned = double.tryParse(plannedAmountStr.replaceAll(RegExp(r'[^0-9]'), ''));

    if (amount == null || planned == null) {
      state = const AsyncError("Nominal tidak valid", StackTrace.empty);
      return false;
    }

    // Update object
    final updatedTarget = originalTarget.copyWith(
      name: name,
      targetAmount: amount,
      plannedAmount: planned,
      planFrequency: frequency,
      imageUrl: imagePath ?? originalTarget.imageUrl,
    );

    final repository = ref.read(targetRepositoryProvider);
    final result = await repository.updateTarget(updatedTarget);

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