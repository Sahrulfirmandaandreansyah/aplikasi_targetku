import 'package:fpdart/fpdart.dart';
import 'package:aplikasi_targetku/core/errors/failures.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';

abstract class TargetRepository {
  // Mengambil semua target (Stream agar realtime)
  Stream<Either<Failure, List<TargetEntity>>> watchAllTargets();
  
  // Mengambil detail 1 target
  Stream<Either<Failure, TargetEntity?>> watchTargetById(int id);
  
  // Menambah target baru (Return ID yang baru dibuat)
  Future<Either<Failure, int>> addTarget(TargetEntity target);
  
  // Update target
  Future<Either<Failure, bool>> updateTarget(TargetEntity target);
  
  // Hapus target
  Future<Either<Failure, int>> deleteTarget(int id);
}
