import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aplikasi_targetku/core/routing/app_router.dart';

class TargetKuApp extends StatelessWidget {
  const TargetKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil fungsi pembuat router di sini
    final router = createAppRouter();

    return MaterialApp.router(
      title: 'TargetKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          secondary: const Color(0xFFFF8A80),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // Gunakan router config
      routerConfig: router,
    );
  }
}