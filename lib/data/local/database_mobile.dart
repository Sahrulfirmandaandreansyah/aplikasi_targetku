import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Fungsi ini akan dipanggil jika aplikasi berjalan di HP
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    // 1. Cari folder penyimpanan aplikasi
    final dbFolder = await getApplicationDocumentsDirectory();
    // 2. Buat file sqlite
    final file = File(p.join(dbFolder.path, 'targetku.sqlite'));
    // 3. Buka koneksi
    return NativeDatabase.createInBackground(file);
  });
}