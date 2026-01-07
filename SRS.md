# Rencana Rilis Bertahap: TargetKu
**Durasi Total:** 5 Sprint (10 Minggu)
**Tujuan Akhir:** Merilis aplikasi TargetKu yang fungsional penuh, baik versi gratis maupun premium, sesuai dengan PRD v1.1.

---

## Tahap 1: MVP Inti (Fungsionalitas Gratis)
**Fokus:** Membangun dan merilis versi gratis yang solid dan disukai pengguna. Ini adalah fondasi dari segalanya.

### Sprint 1: Fondasi Data & Fungsionalitas Inti (2 Minggu)

**Fokus Sprint:** Membangun *backbone* aplikasi, mulai dari data model hingga bisa menampilkan, membuat, dan menyimpan data target.

*   **Minggu 1: Desain Model & Manajemen Target**
    *   [ ] **W1-D1:** Definisikan *entities* & *enums* (`Target`, `Transaction`) menggunakan **Freezed**.
    *   [ ] **W1-D2:** Definisikan tabel database & *type converters* menggunakan **Drift**. Jalankan `build_runner`.
    *   [ ] **W1-D3:** Buat *Repository Interfaces* (Domain Layer) dan *Implementations* (Data Layer) untuk `Target`.
    *   [ ] **W1-D4:** Buat Riverpod Providers untuk `Repository` dan `DAO`.
    *   [ ] **W1-D5:** Buat UI untuk halaman utama (`TargetListPage`) yang menampilkan daftar target dari database.

*   **Minggu 2: Fungsionalitas & Navigasi**
    *   [ ] **W2-D1:** Konfigurasi **Go_Router** untuk navigasi dasar (`/`, `/create-target`).
    *   [ ] **W2-D2:** Buat UI dan Notifier untuk halaman "Buat/Edit Target". Implementasikan logika menyimpan/mengedit.
    *   [ ] **W2-D3:** Buat UI untuk halaman detail target (`TargetDetailPage`) dan navigasi dari daftar ke detail.
    *   [ ] **W2-D4:** Implementasikan logika "Hapus Target".
    *   [ ] **W2-D5:** Review Sprint & Persiapan Sprint 2.

### Sprint 2: Penyelesaian Fitur Inti & Poles (2 Minggu)

**Fokus Sprint:** Menambahkan fungsionalitas transaksi, logika bisnis, dan memoles UI versi gratis.

*   **Minggu 3: Transaksi & Logika Bisnis**
    *   [ ] **W3-D1:** Implementasikan `TransactionRepository` (Domain & Data Layer).
    *   [ ] **W3-D2:** Desain dan buat UI untuk dialog/modal "Tambah Transaksi".
    *   [ ] **W3-D3:** Implementasikan logika untuk menyimpan transaksi (Increase & Decrease).
    *   [ ] **W3-D4:** Tampilkan riwayat transaksi di `TargetDetailPage`.
    *   [ ] **W3-D5:** Implementasikan semua logika kalkulasi (Total Terkumpul, Persentase, Sisa, Estimasi).

*   **Minggu 4: Fitur Tambahan & Pengujian**
    *   [ ] **W4-D1:** Implementasikan logika perubahan status target menjadi "Selesai" secara otomatis.
    *   [ ] **W4-D2:** Integrasikan *local notifications* untuk fitur pengingat menabung.
    *   [ ] **W4-D3:** Tangani *empty states* dan penanganan error dasar di UI (SnackBar).
    *   [ ] **W4-D4:** Lakukan pengujian manual menyeluruh (QA) untuk semua fitur gratis.
    *   [ ] **W4-D5:** **Sprint Review/Demo.** Versi gratis siap untuk rilis internal.

---

## Tahap 2: Implementasi Fitur Premium
**Fokus:** Membangun infrastruktur monetisasi dan menambahkan fitur-fitur berbayar di atas fondasi gratis yang sudah solid.

### Sprint 3: Fondasi Premium & Pembelian (2 Minggu)

**Fokus Sprint:** Mengintegrasikan sistem pembelian dan manajemen status premium.

*   [ ] Buat `UserPreferenceRepository` menggunakan **SharedPreferences** untuk menyimpan status `isPremium`.
*   [ ] Integrasikan paket `in_app_purchase` ke dalam proyek.
*   [ ] Buat `PurchaseRepository` yang menangani logika pengambilan produk dan memulai pembelian.
*   [ ] Desain dan buat UI untuk halaman penawaran "Upgrade ke Premium".
*   [ ] Implementasikan logika *feature gating*: jika pengguna gratis mencoba membuat target ke-4, arahkan ke halaman penawaran.
*   [ ] Buat provider Riverpod `isPremiumProvider` yang bisa diakses di seluruh aplikasi.
*   [ ] Implementasikan logika untuk memperbarui status `isPremium` setelah pembelian berhasil.

### Sprint 4: Fitur Premium (Target Tak Terbatas & Kustomisasi) (2 Minggu)

**Fokus Sprint:** Merilis fitur premium pertama yang paling menarik bagi pengguna.

*   [ ] Hapus batasan 3 target di level UI jika `isPremiumProvider` mengembalikan `true`.
*   [ ] Buat halaman "Pengaturan" yang hanya bisa diakses oleh pengguna premium.
*   [ ] Implementasikan fungsionalitas **Mode Gelap (Dark Mode)** yang bisa diaktifkan dari halaman Pengaturan.
*   [ ] Implementasikan beberapa **pilihan tema warna** aplikasi.
*   [ ] (Opsional) Desain dan sediakan **perpustakaan ikon eksklusif** untuk dipilih sebagai gambar target.

### Sprint 5: Fitur Premium (Laporan & Analitik) (2 Minggu)

**Fokus Sprint:** Melengkapi paket premium dengan fitur berbasis data.

*   [ ] Buat folder fitur baru: `features/analytics`.
*   [ ] Buat `AnalyticsRepository` yang membaca dan mengolah data dari `Target` dan `Transaction` yang sudah ada.
*   [ ] Desain dan buat UI untuk halaman "Laporan/Insight".
*   [ ] Implementasikan **grafik sederhana** untuk menampilkan pertumbuhan total tabungan.
*   [ ] Implementasikan logika untuk menghitung dan menampilkan statistik (misal: rata-rata waktu penyelesaian target).
*   [ ] Lakukan pengujian akhir untuk semua fitur premium dan persiapkan aplikasi untuk rilis publik.