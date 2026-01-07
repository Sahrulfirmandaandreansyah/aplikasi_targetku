import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aplikasi_targetku/app.dart';
import 'package:aplikasi_targetku/core/services/notification_service.dart';
import 'package:aplikasi_targetku/core/services/user_preference_service.dart';

void main() async {
  // 1. Pastikan Flutter Binding siap
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inisialisasi Service (Tunggu sampai selesai / await)
  await NotificationService().init();
  await UserPreferenceService().init(); // INI PENTING!

  // 3. Jalankan Aplikasi setelah service siap
  runApp(
    const ProviderScope(
      child: TargetKuApp(),
    ),
  );
}