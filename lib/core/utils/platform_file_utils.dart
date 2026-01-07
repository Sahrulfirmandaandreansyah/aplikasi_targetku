import 'dart:io' as io; // Import dart:io dengan nama alias 'io'
import 'package:flutter/foundation.dart'; // Untuk kIsWeb

bool fileExistsSync(String? path) {
  if (path == null || path.isEmpty) {
    return false;
  }

  // Jika sedang berjalan di WEB (Edge/Chrome)
  if (kIsWeb) {
    // Di Web kita tidak bisa cek file system pengguna demi keamanan.
    // Jadi jika path tidak kosong (dari image picker), kita anggap valid.
    return true; 
  } 
  
  // Jika sedang berjalan di MOBILE (Android/iOS) atau Desktop
  else {
    return io.File(path).existsSync();
  }
}