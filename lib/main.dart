import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aplikasi_targetku/app.dart';
import 'package:aplikasi_targetku/core/services/notification_service.dart'; // Import service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Init Notifikasi
  await NotificationService().init();

  runApp(
    const ProviderScope(
      child: TargetKuApp(),
    ),
  );
}