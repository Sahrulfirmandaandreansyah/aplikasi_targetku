import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_targetku/core/utils/platform_file_utils.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';

class TargetCompletedPage extends StatelessWidget {
  final TargetEntity target;

  const TargetCompletedPage({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Logic Gambar Aman
    ImageProvider? imageProvider;
    if (target.imageUrl != null && target.imageUrl!.isNotEmpty) {
      if (fileExistsSync(target.imageUrl)) {
        if (kIsWeb) {
          imageProvider = NetworkImage(target.imageUrl!);
        } else {
          imageProvider = FileImage(File(target.imageUrl!));
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Piala / Bintang
                const Icon(Icons.emoji_events_rounded, size: 100, color: Colors.amber),
                const SizedBox(height: 24),
                
                const Text(
                  "SELAMAT! 🎉",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Target Impianmu Tercapai",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40),

                // Kartu Target
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      if (imageProvider != null)
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      Text(
                        target.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormatter.format(target.targetAmount),
                        style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Tombol Kembali
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Kembali ke Home (Tab Selesai akan otomatis aktif jika logic benar)
                      context.go('/'); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Kembali ke Beranda", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}