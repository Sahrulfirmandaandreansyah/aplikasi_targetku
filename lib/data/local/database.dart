import 'package:aplikasi_targetku/data/local/database_mobile.dart' if (dart.library.html) 'package:aplikasi_targetku/data/local/database_web.dart';
import 'package:drift/drift.dart';

import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/targets/data/tables/targets_table.dart';
import 'package:aplikasi_targetku/features/transactions/data/tables/transactions_table.dart';
import 'package:aplikasi_targetku/features/targets/data/daos/targets_dao.dart';
import 'package:aplikasi_targetku/features/transactions/data/daos/transactions_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Targets, Transactions],
  daos: [TargetsDao, TransactionsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

AppDatabase getAppDatabase() => AppDatabase(openConnection());