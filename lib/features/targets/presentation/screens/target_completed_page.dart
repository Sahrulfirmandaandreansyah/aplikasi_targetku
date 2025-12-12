import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_targetku/features/targets/domain/entities/target_entity.dart';

class TargetCompletedPage extends StatelessWidget {
  final TargetEntity target;

  const TargetCompletedPage({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Target Tercapai! 🎉"),
        automaticallyImplyLeading: false, // Sembunyikan tombol back
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "SELAMAT!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Kamu telah berhasil mencapai target:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 24),
              Text(
                target.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Senilai ${currencyFormatter.format(target.targetAmount)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 24),
              if (target.completedAt != null)
                Text(
                  "Tercapai pada: ${dateFormatter.format(target.completedAt!)}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman utama (root)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Kembali ke Halaman Utama"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
