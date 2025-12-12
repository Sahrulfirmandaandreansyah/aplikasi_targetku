import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';

part 'target_list_provider.g.dart';

@riverpod
class TargetList extends _$TargetList {
  @override
  Stream<List<TargetEntity>> build() {
    // 1. Ambil repository dari DI
    final repository = ref.watch(targetRepositoryProvider);
    
    // 2. Listen stream dari repository
    return repository.watchAllTargets().map((either) {
      // 3. Buka bungkusan Either (Right = Data, Left = Error)
      return either.fold(
        (failure) => throw failure.message, // Lempar error agar ditangkap UI AsyncError
        (data) => data, // Kembalikan data list
      );
    });
  }
}
