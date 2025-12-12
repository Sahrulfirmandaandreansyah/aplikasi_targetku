import 'package:drift/drift.dart';
import 'package:aplikasi_targetku/core/constants/enums.dart';
import 'package:aplikasi_targetku/features/targets/data/tables/targets_table.dart';

class Transactions extends Table {
  // Primary Key
  IntColumn get id => integer().autoIncrement()();

  // Foreign Key ke Targets
  // onDelete: KeyAction.cascade artinya jika Target dihapus, Transaksi ini juga hilang
  IntColumn get targetId => integer().references(Targets, #id, onDelete: KeyAction.cascade)();

  // Jumlah Uang (Selalu positif)
  RealColumn get amount => real()();

  // Tipe: Pemasukan / Pengeluaran
  TextColumn get type => textEnum<TransactionType>()();

  // Deskripsi opsional
  TextColumn get description => text().nullable()();

  // Tanggal Transaksi
  DateTimeColumn get date => dateTime()();
}
