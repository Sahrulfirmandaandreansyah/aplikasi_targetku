import 'package:drift/drift.dart';
import 'package:drift/web.dart';

// Fungsi ini akan dipanggil jika aplikasi berjalan di Browser
QueryExecutor openConnection() {
  // Menggunakan WebDatabase (disimpan di LocalStorage browser)
  return WebDatabase('targetku_web_db');
}