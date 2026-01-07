# Product Requirements Document (PRD): TargetKu
**Versi:** 1.1 (Revisi dengan Fitur Premium)
**Tanggal:** 6 November 2025
**Penulis:** Muhammad Hisyam Maulana, Sahrul Firmanda Andreansyah

---

## 1. Latar Belakang

### 1.1. Visi Produk
Menjadi aplikasi pencatat tabungan yang paling sederhana, ringan, dan memotivasi bagi pengguna di Indonesia untuk mencapai barang impian mereka, dengan opsi premium untuk meningkatkan pengalaman pengguna.

### 1.2. Masalah yang Diselesaikan
Banyak orang, terutama kalangan muda, kesulitan untuk tetap konsisten dan termotivasi saat menabung untuk membeli suatu barang. Mereka sering kehilangan jejak progres, lupa berapa yang sudah terkumpul, dan tidak memiliki gambaran kapan target mereka akan tercapai. Aplikasi keuangan yang ada seringkali terlalu kompleks.

### 1.3. Solusi
**TargetKu** adalah aplikasi *single-purpose* yang berfokus sepenuhnya pada satu hal: membantu pengguna menabung untuk target tertentu. Dengan visualisasi progres yang jelas dan antarmuka yang minimalis, TargetKu menjaga motivasi pengguna tetap tinggi. Aplikasi ini beroperasi dengan model *freemium*, menawarkan fitur inti secara gratis dan fitur tambahan melalui paket premium **TargetKu Plus**.

### 1.4. Target Audiens
*   **Pengguna Inti:** Pelajar, Mahasiswa, dan Pekerja muda (*first-jobber*).
*   **Pengguna Potensial:** Siapa saja yang membutuhkan alat bantu sederhana untuk mencapai tujuan finansial jangka pendek dan menengah.

---

## 2. Fitur & Fungsionalitas

### 2.1. Fitur Inti (Gratis)

Fitur-fitur ini tersedia untuk semua pengguna dan menjadi fondasi dari pengalaman TargetKu.

#### 2.1.1. Manajemen Target Tabungan
*   **User Story:** "Sebagai pengguna, saya ingin dapat membuat satu atau lebih target tabungan untuk barang yang saya inginkan agar saya bisa melacak semuanya di satu tempat."
*   **Kriteria Penerimaan:**
    - [ ] Pengguna dapat membuat target baru.
    - [ ] Form pembuatan target berisi: Nama Target (Wajib), Jumlah Target (Wajib), Gambar (Opsional), Rencana Menabung (Frekuensi & Nominal, Wajib).
    - [ ] Pengguna dapat mengedit dan menghapus target yang sudah ada.
    - [ ] **Pembatasan:** Pengguna gratis hanya dapat memiliki **maksimal 3 target** dengan status "Dalam Proses" secara bersamaan.

#### 2.1.2. Pencatatan Transaksi
*   **User Story:** "Sebagai pengguna, saya ingin mencatat setiap kali saya menabung (atau terpaksa mengambil uang) untuk target saya agar data progres selalu akurat."
*   **Kriteria Penerimaan:**
    - [ ] Pengguna dapat menambahkan transaksi dari halaman detail target.
    - [ ] Jenis transaksi adalah **Pemasukan (Increase)** atau **Pengeluaran (Decrease)**.
    - [ ] Form transaksi berisi: Nominal (Wajib), Deskripsi (Opsional), Tanggal.
    - [ ] Riwayat transaksi ditampilkan di halaman detail target, diurutkan dari yang terbaru.

#### 2.1.3. Visualisasi & Pelacakan Progres
*   **User Story:** "Sebagai pengguna, saya ingin melihat progres tabungan saya secara visual dan mengetahui perkiraan kapan target saya akan tercapai agar saya tetap termotivasi."
*   **Kriteria Penerimaan:**
    - [ ] Halaman utama menampilkan daftar target dalam bentuk kartu (Nama, Gambar, Progress Bar, Persentase).
    - [ ] Terdapat tab untuk memfilter target: "Dalam Proses" dan "Selesai".
    - [ ] Halaman detail menampilkan informasi lengkap (Total Terkumpul, Sisa) dan **Estimasi Pencapaian** berdasarkan rencana menabung.
    - [ ] Estimasi Pencapaian akan dihitung ulang secara dinamis jika ada transaksi 'Pengeluaran' (Decrease), yang akan memperpanjang estimasi waktu.
    - [ ] Status target otomatis berubah menjadi "Selesai" jika progres mencapai 100%.

#### 2.1.4. Pengingat Menabung
*   **User Story:** "Sebagai pengguna, saya ingin mendapatkan notifikasi pengingat agar saya tidak lupa menabung sesuai dengan rencana yang telah saya buat."
*   **Kriteria Penerimaan:**
    - [ ] Pengguna dapat mengaktifkan/menonaktifkan pengingat untuk setiap target.
    - [ ] Aplikasi akan mengirimkan notifikasi lokal sesuai frekuensi yang dipilih (Harian, Mingguan, Bulanan).

---

### 2.2. Fitur Premium (TargetKu Plus)

Fitur-fitur ini tersedia setelah pengguna melakukan pembelian dalam aplikasi (*In-App Purchase*).

#### 2.2.1. Target Tidak Terbatas (Unlimited Targets)
*   **User Story:** "Sebagai pengguna aktif dengan banyak keinginan, saya ingin membuat lebih dari 3 target tabungan secara bersamaan agar saya bisa merencanakan semua tujuan saya di satu tempat."
*   **Detail Fitur:**
    - [ ] Menghilangkan batasan 3 target "Dalam Proses". Pengguna premium dapat membuat target **tanpa batas**.
    - [ ] Jika pengguna gratis mencoba membuat target ke-4, aplikasi akan menampilkan halaman penawaran untuk upgrade ke premium.

#### 2.2.2. Kustomisasi Lanjutan & Ikon Eksklusif
*   **User Story:** "Sebagai pengguna yang suka personalisasi, saya ingin mengubah tampilan aplikasi dan ikon target saya agar lebih personal dan sesuai dengan selera saya."
*   **Detail Fitur:**
    - [ ] Membuka **Mode Gelap (Dark Mode)**.
    - [ ] Membuka beberapa pilihan **tema warna** aplikasi (misal: Biru, Ungu, Oranye).
    - [ ] Memberikan akses ke **perpustakaan ikon eksklusif** yang bisa dipilih sebagai gambar target.

#### 2.2.3. Laporan & Analitik Sederhana
*   **User Story:** "Sebagai pengguna yang ingin tahu kebiasaan menabung saya, saya ingin melihat laporan sederhana tentang seberapa cepat saya mencapai target dan berapa rata-rata saya menabung setiap bulan."
*   **Detail Fitur:**
    - [ ] Membuka halaman "Insight" atau "Laporan" baru.
    - [ ] Halaman ini menampilkan:
        - Grafik pertumbuhan total tabungan dari waktu ke waktu.
        - Rata-rata waktu untuk menyelesaikan sebuah target.
        - Total uang yang berhasil ditabung selama sebulan/setahun.

#### 2.2.4. Pemulihan Pembelian (Purchase Restoration)
*   **User Story:** "Sebagai pengguna yang telah membeli versi premium, saya ingin dapat memulihkan status premium saya jika saya menginstal ulang aplikasi atau berganti perangkat, tanpa harus membayar lagi."
*   **Detail Fitur:**
    - [ ] Aplikasi harus menyediakan tombol/opsi "Pulihkan Pembelian".
    - [ ] Tombol ini akan berkomunikasi dengan API store (Google Play/App Store) untuk memeriksa pembelian sebelumnya dan mengaktifkan kembali fitur premium.

---

## 3. Alur Pengguna (User Flow)

1.  **Pengguna Baru:** Buka Aplikasi -> Onboarding -> Halaman Utama (kosong) -> Klik "Buat Target" -> Isi Form -> Simpan -> Kembali ke Halaman Utama.
2.  **Alur Upgrade:** Pengguna Gratis mencoba membuat target ke-4 -> Muncul halaman penawaran Premium -> Pengguna melakukan pembelian -> Batasan terbuka.
3.  **Alur Pengguna Premium:** Pengguna membuka Pengaturan -> Mengaktifkan Dark Mode atau mengubah tema warna.
4.  **Alur Pemulihan Pembelian:** Pengguna menginstal ulang aplikasi -> Melihat halaman penawaran premium -> Klik "Pulihkan Pembelian" -> Aplikasi memverifikasi pembelian lampau -> Fitur premium aktif kembali.

---

## 4. Persyaratan Non-Fungsional

- **Performa:** Aplikasi harus ringan, cepat dibuka (< 2 detik), dan responsif.
- **UI/UX:** Desain bersih, modern, dan intuitif.
- **Persistensi Data:** Semua data disimpan secara lokal di perangkat. Data tidak boleh hilang jika aplikasi ditutup.
- **Monetisasi:** Aplikasi harus terintegrasi dengan API In-App Purchase dari Google Play Store dan Apple App Store.
- **Platform:** Android dan iOS menggunakan Flutter.
- **Arsitektur:** Mengimplementasikan prinsip Clean Architecture.

---

## 5. Teknologi yang Digunakan

- **Framework:** Flutter
- **State Management:** Riverpod
- **Model:** Freezed
- **Navigasi:** Go_Router
- **Database Lokal:** Drift
- **Pembelian Dalam Aplikasi:** `in_app_purchase` (paket Flutter).
- **Penyimpanan Lokal Sederhana:** `shared_preferences` (untuk menyimpan status premium).

---

## 6. Di Luar Cakupan (Out of Scope for MVP)

Fitur-fitur berikut tidak akan dimasukkan dalam rilis pertama (baik gratis maupun premium):

-   Sinkronisasi & Backup data ke Cloud.
-   Kustomisasi Mata Uang & Bahasa.
-   Widget di Homescreen.
-   Fitur sosial atau berbagi progres.