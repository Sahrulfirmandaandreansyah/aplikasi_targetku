# Checklist Timeline Sprint MVP: TargetKu
**Durasi Sprint:** 2 Minggu (10 Hari Kerja)
**Tujuan Sprint:** Menghasilkan versi aplikasi yang fungsional (MVP) sesuai dengan SRS v1.0, siap untuk pengujian internal atau *alpha release*.

---

### Sprint 0 / Persiapan (Sebelum Sprint Dimulai)
Tujuan: Memastikan fondasi proyek sudah siap sehingga sprint bisa langsung fokus pada pengembangan fitur.

- [x] **P-1:** Inisialisasi proyek Flutter baru.
- [ ] **P-2:** Setup Git repository (lokal dan remote).
- [x] **P-3:** Tambahkan semua dependensi utama ke `pubspec.yaml` (riverpod_generator, freezed, go_router, drift, fpdart, logger, dll.).
- [x] **P-4:** Buat struktur direktori dasar sesuai arsitektur Clean (`lib/app`, `lib/core`, `lib/data`, `lib/domain`, `lib/features`).
- [x] **P-5:** Konfigurasi dasar `main.dart` dan `MaterialApp`.

---

## Minggu 1: Fondasi Data & Fungsionalitas Inti

**Fokus Minggu 1:** Membangun *backbone* aplikasi, mulai dari data model hingga bisa menampilkan dan menyimpan data target.

#### Hari 1: Desain Model & Database
- [x] **W1-D1-T1:** Definisikan *entities* `Target` dan `Transaction` menggunakan **Freezed**.
- [x] **W1-D1-T2:** Definisikan tabel database (`targets`, `transactions`) dan koneksi database menggunakan **Drift**.
- [x] **W1-D1-T3:** Jalankan `build_runner` untuk pertama kali dan pastikan semua file berhasil di-generate (`.freezed.dart`, `.g.dart`).
- [x] **W1-D1-T4:** Verifikasi Build aplikasi (`flutter build apk --debug`).

#### Hari 2: Lapisan Data (Repository & Data Source)
- [x] **W1-D2-T1:** Buat *repository interfaces* (kontrak) di dalam **Domain Layer**.
- [x] **W1-D2-T2:** Implementasikan *repository classes* di dalam **Data Layer**.
- [x] **W1-D2-T3:** Hubungkan implementasi repository ke **Drift DAOs** yang telah di-generate.
- [x] **W1-D2-T4:** Terapkan `fpdart` (`Either`) sebagai return type untuk semua metode repository.

#### Hari 3: State Management & Tampilan Daftar Target
- [x] **W1-D3-T1:** Buat **Riverpod Providers** untuk `Repository`.
- [x] **W1-D3-T2:** Buat `AsyncNotifierProvider` untuk mengambil dan me-*watch* daftar target (`targetsProvider`).
- [x] **W1-D3-T3:** Buat UI *skeleton* untuk halaman utama (`TargetListPage`) yang me-*listen* provider dan menampilkan data dummy atau data dari database.
- [x] **W1-D3-T4:** Implementasikan tampilan tab "In Progress" dan "Selesai".

#### Hari 4: Membuat & Menyimpan Target Baru
- [x] **W1-D4-T1:** Konfigurasi **Go_Router** untuk navigasi dasar (`/` dan `/create-target`).
- [x] **W1-D4-T2:** Buat UI untuk halaman "Buat Target Baru" (`AddEditTargetPage`) beserta form inputnya.
- [x] **W1-D4-T3:** Buat `Notifier` Riverpod untuk mengelola state form dan logika penyimpanan.
- [x] **W1-D4-T4:** Implementasikan alur lengkap: isi form -> tekan simpan -> panggil notifier -> panggil repository -> data tersimpan -> UI halaman utama otomatis refresh.

#### Hari 5: Detail Target & Review Mingguan
- [ ] **W1-D5-T1:** Buat UI *skeleton* untuk halaman detail target (`TargetDetailPage`).
- [ ] **W1-D5-T2:** Implementasikan navigasi dari daftar target ke halaman detail dengan Go_Router (menggunakan parameter ID).
- [ ] **W1-D5-T3:** Buat provider untuk mengambil data satu target spesifik (`targetDetailProvider`).
- [ ] **W1-D5-T4:** Review progres minggu pertama & rencanakan penyesuaian untuk minggu kedua.

---

## Minggu 2: Penyelesaian Fitur, Poles, dan Pengujian

**Fokus Minggu 2:** Menambahkan fungsionalitas transaksi, logika bisnis, memoles UI, dan memastikan aplikasi stabil.

#### Hari 6: Fungsionalitas Transaksi
- [ ] **W2-D6-T1:** Desain dan buat UI untuk dialog/modal "Tambah Transaksi".
- [ ] **W2-D6-T2:** Implementasikan logika untuk menyimpan transaksi (Increase & Decrease) melalui provider dan repository.
- [ ] **W2-D6-T3:** Buat provider untuk mengambil riwayat transaksi sebuah target.
- [ ] **W2-D6-T4:** Tampilkan daftar riwayat transaksi di `TargetDetailPage`.

#### Hari 7: Logika Bisnis & Visualisasi
- [ ] **W2-D7-T1:** Implementasikan logika kalkulasi di dalam provider/notifier:
    - [ ] Hitung total terkumpul.
    - [ ] Hitung persentase progres.
    - [ ] Hitung sisa target.
    - [ ] Hitung estimasi waktu pencapaian.
- [ ] **W2-D7-T2:** Implementasikan komponen UI visual: `ProgressBar`, format mata uang, dll.
- [ ] **W2-D7-T3:** Pastikan semua data di `TargetListPage` dan `TargetDetailPage` sudah ter-update secara reaktif.

#### Hari 8: Fitur Tambahan & Penanganan Kasus
- [ ] **W2-D8-T1:** Implementasikan fungsionalitas "Edit Target" dan "Hapus Target".
- [ ] **W2-D8-T2:** Implementasikan logika perubahan status target menjadi "Selesai" secara otomatis.
- [ ] **W2-D8-T3:** Tangani *empty states* (tampilan saat daftar target kosong atau riwayat transaksi kosong).
- [ ] **W2-D8-T4:** Implementasikan penanganan error dasar di UI (misalnya, menampilkan `SnackBar` jika gagal menyimpan data).

#### Hari 9: Notifikasi & Pengujian Internal
- [ ] **W2-D9-T1:** Integrasikan *local notifications* untuk fitur pengingat menabung.
- [ ] **W2-D9-T2:** Lakukan pengujian manual menyeluruh (QA):
    - [ ] Alur membuat, mengedit, menghapus target.
    - [ ] Alur menambah transaksi (increase & decrease).
    - [ ] Cek kalkulasi dan estimasi.
    - [ ] Cek notifikasi.
    - [ ] Tes di berbagai ukuran layar (emulator).
- [ ] **W2-D9-T3:** Catat dan mulai perbaiki bug yang ditemukan.

#### Hari 10: Finalisasi & Persiapan Rilis
- [ ] **W2-D10-T1:** Lakukan *code cleanup*, refactoring, dan tambahkan komentar jika perlu.
- [ ] **W2-D10-T2:** Siapkan aset aplikasi final: App Icon & Splash Screen.
- [ ] **W2-D10-T3:** Buat *build* rilis (`.apk` untuk Android / `.ipa` untuk iOS).
- [ ] **W2-D10-T4:** Lakukan **Sprint Review/Demo** untuk menunjukkan fungsionalitas MVP yang telah selesai.

---

### Post-Sprint
- [ ] Alokasikan waktu untuk perbaikan bug yang ditemukan saat demo atau pengujian awal.
- [ ] Rencanakan Sprint berikutnya untuk fitur di luar cakupan MVP (misal: Dark Mode, Backup Data).