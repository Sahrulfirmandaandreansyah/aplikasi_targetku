import 'package:drift/drift.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';

@DataClassName('Target')
class Targets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get targetAmount => real()();
  TextColumn get imageUrl => text().nullable()();
  RealColumn get plannedAmount => real()();
  IntColumn get planFrequency => intEnum<PlanFrequency>()();
  IntColumn get status => intEnum<TargetStatus>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
