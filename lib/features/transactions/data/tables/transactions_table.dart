import 'package:drift/drift.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';

@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get targetId => integer()();
  RealColumn get amount => real()();
  IntColumn get type => intEnum<TransactionType>()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
}
