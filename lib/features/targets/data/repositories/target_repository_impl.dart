import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:aplikasi_targetku/core/errors/failures.dart';
import 'package:aplikasi_targetku/data/local/database.dart';
import 'package:aplikasi_targetku/features/targets/data/daos/targets_dao.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';
import 'package:aplikasi_targetku/features/targets/domain/repositories/target_repository.dart';

class TargetRepositoryImpl implements TargetRepository {
  final TargetsDao _targetsDao;

  TargetRepositoryImpl(this._targetsDao);

  @override
  Stream<Either<Failure, List<TargetEntity>>> watchAllTargets() {
    return _targetsDao.watchAllTargets().map((targetList) {
      try {
        final entities = targetList.map((t) => TargetEntity(
          id: t.id,
          name: t.name,
          targetAmount: t.targetAmount,
          imageUrl: t.imageUrl,
          plannedAmount: t.plannedAmount,
          planFrequency: t.planFrequency,
          status: t.status,
          createdAt: t.createdAt,
          completedAt: t.completedAt,
        )).toList();
        
        // TIPE EKSPLISIT: Right<Failure, List<TargetEntity>>
        return Right<Failure, List<TargetEntity>>(entities);
      } catch (e) {
        return Left<Failure, List<TargetEntity>>(DatabaseFailure("Gagal parsing: $e"));
      }
    }).handleError((error) {
      // TIPE EKSPLISIT: Left<Failure, List<TargetEntity>>
      return Left<Failure, List<TargetEntity>>(DatabaseFailure(error.toString()));
    });
  }

  @override
  Future<Either<Failure, int>> addTarget(TargetEntity target) async {
    try {
      final companion = TargetsCompanion(
        name: Value(target.name),
        targetAmount: Value(target.targetAmount),
        imageUrl: Value(target.imageUrl),
        plannedAmount: Value(target.plannedAmount),
        planFrequency: Value(target.planFrequency),
        status: Value(target.status),
        createdAt: Value(target.createdAt),
      );
      
      final id = await _targetsDao.insertTarget(companion);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteTarget(int id) async {
    try {
      final result = await _targetsDao.deleteTarget(id);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTarget(TargetEntity target) async {
    try {
      final companion = TargetsCompanion(
        id: Value(target.id),
        name: Value(target.name),
        targetAmount: Value(target.targetAmount),
        imageUrl: Value(target.imageUrl),
        plannedAmount: Value(target.plannedAmount),
        planFrequency: Value(target.planFrequency),
        status: Value(target.status),
        completedAt: Value(target.completedAt),
      );

      final result = await _targetsDao.updateTarget(companion);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, TargetEntity?>> watchTargetById(int id) {
    return _targetsDao.watchTargetById(id).map((t) {
      if (t == null) {
         return const Right<Failure, TargetEntity?>(null);
      }
      
      final entity = TargetEntity(
        id: t.id,
        name: t.name,
        targetAmount: t.targetAmount,
        imageUrl: t.imageUrl,
        plannedAmount: t.plannedAmount,
        planFrequency: t.planFrequency,
        status: t.status,
        createdAt: t.createdAt,
        completedAt: t.completedAt,
      );
      // TIPE EKSPLISIT
      return Right<Failure, TargetEntity?>(entity);
    }).handleError((error) {
      // TIPE EKSPLISIT
      return Left<Failure, TargetEntity?>(DatabaseFailure(error.toString()));
    });
  }
}