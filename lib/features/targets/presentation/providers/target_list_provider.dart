import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aplikasi_targetku/core/di/dependency_injection.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';

part 'target_list_provider.g.dart';

@riverpod
class TargetList extends _$TargetList {
  @override
  Stream<List<TargetEntity>> build() {
    final repository = ref.watch(targetRepositoryProvider);
    
    // Gunakan watchAllTargets (STREAM)
    return repository.watchAllTargets().map((either) {
      return either.fold(
        (failure) => [],
        (data) => data,
      );
    });
  }
}