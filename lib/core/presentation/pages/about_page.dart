import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Aplikasi TargetKu"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat datang di Aplikasi TargetKu!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              "Aplikasi ini dirancang untuk membantu Anda mengelola dan mencapai target keuangan atau tujuan lainnya dengan lebih mudah dan terstruktur.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              "Fitur Utama:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildFeatureItem(context, "Buat Target Baru", "Tentukan nama target, jumlah yang ingin dicapai, dan frekuensi menabung (harian, mingguan, bulanan)."),
            _buildFeatureItem(context, "Catat Transaksi", "Tambahkan atau tarik dana dari target Anda dengan mudah. Setiap transaksi akan tercatat secara otomatis."),
            _buildFeatureItem(context, "Pantau Progress", "Lihat visualisasi kemajuan target Anda secara real-time."),
            _buildFeatureItem(context, "Notifikasi Pengingat", "Dapatkan pengingat untuk menabung secara berkala agar Anda tetap termotivasi."),
            _buildFeatureItem(context, "Edit & Hapus Target", "Kelola target Anda sesuai kebutuhan, baik itu mengubah detail atau menghapus target yang sudah tidak relevan."),
            const SizedBox(height: 24),
            Text(
              "Panduan Penggunaan:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildGuideItem(context, "1. Membuat Target:", "Klik tombol '+' di pojok kanan bawah halaman utama. Isi detail target Anda dan simpan."),
            _buildGuideItem(context, "2. Mencatat Transaksi:", "Pilih target yang ingin Anda catat transaksinya. Gunakan tombol 'Nabung' atau 'Tarik' dan masukkan nominal serta catatan (opsional)."),
            _buildGuideItem(context, "3. Melihat Detail Target:", "Ketuk kartu target di halaman utama untuk melihat rincian progres, riwayat transaksi, dan opsi edit/hapus."),
            const SizedBox(height: 24),
            Text(
              "Terima kasih telah menggunakan Aplikasi TargetKu. Semoga impian Anda segera tercapai!",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(
              "Versi Aplikasi: 1.0.0",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(BuildContext context, String step, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}