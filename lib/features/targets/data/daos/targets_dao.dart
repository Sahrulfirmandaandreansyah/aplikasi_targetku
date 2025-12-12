import 'package:drift/drift.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/data/local/database.dart';
import 'package:aplikasi_targetku/features/targets/data/tables/targets_table.dart';

part 'targets_dao.g.dart';

@DriftAccessor(tables: [Targets])
class TargetsDao extends DatabaseAccessor<AppDatabase> with _$TargetsDaoMixin {
  TargetsDao(super.db);

  // Ambil semua target
  Stream<List<Target>> watchAllTargets() {
    return (select(targets)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch();
  }
  
  // PERBAIKAN DI SINI: Gunakan .equalsValue(status) karena kolom ini adalah Enum
  Stream<List<Target>> watchTargetsByStatus(TargetStatus status) {
    return (select(targets)..where((t) => t.status.equalsValue(status))).watch();
  }

  // Ambil single target
  Future<Target?> getTargetById(int id) {
    return (select(targets)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
  
  Stream<Target?> watchTargetById(int id) {
    return (select(targets)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  // Insert
  Future<int> insertTarget(TargetsCompanion target) {
    return into(targets).insert(target);
  }

  // Update
  Future<bool> updateTarget(TargetsCompanion target) {
    return update(targets).replace(target);
  }

  // Delete
  Future<int> deleteTarget(int id) {
    return (delete(targets)..where((t) => t.id.equals(id))).go();
  }
}
