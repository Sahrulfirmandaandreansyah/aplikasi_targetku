import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';

part 'target_actions_provider.g.dart';

@riverpod
class TargetActionsNotifier extends _$TargetActionsNotifier {
  @override
  FutureOr<void> build() {
    // State awal idle
  }

  Future<bool> deleteTarget(int id) async {
    state = const AsyncLoading();
    final repo = ref.read(targetRepositoryProvider);
    final result = await repo.deleteTarget(id);

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