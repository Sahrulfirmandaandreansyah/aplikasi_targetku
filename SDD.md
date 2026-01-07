# Software Design Document (SDD): TargetKu
**Versi:** 1.0
**Tanggal:** 17 September 2025
**Status:** Draf

---

## 1. Pendahuluan

### 1.1. Tujuan
Dokumen ini merinci desain arsitektur dan teknis tingkat tinggi untuk aplikasi mobile **TargetKu**. Tujuannya adalah untuk memberikan panduan yang jelas bagi tim pengembang dalam mengimplementasikan fungsionalitas yang telah dijabarkan dalam **Software Requirements Specification (SRS) v1.0**.

### 1.2. Ruang Lingkup
Desain ini mencakup arsitektur aplikasi, struktur data, desain komponen utama, strategi navigasi, penanganan error, dan logging untuk versi MVP dari aplikasi TargetKu. Desain ini secara spesifik akan menguraikan penggunaan Flutter, Riverpod, Drift, Go_Router, Freezed, fpdart, dan Logger.

---

## 2. Desain Arsitektur

### 2.1. Pola Arsitektur: Clean Architecture
Aplikasi akan dibangun mengikuti prinsip-prinsip **Clean Architecture**. Tujuannya adalah untuk memisahkan logika bisnis dari detail implementasi (UI, database, dll.), sehingga aplikasi menjadi lebih mudah diuji, dipelihara, dan dikembangkan.

Arsitektur akan dibagi menjadi tiga lapisan utama:

```plaintext
+-----------------------------------------------------------------+
|                         Presentation Layer                      |
| (Flutter Widgets, Riverpod Notifiers, Go_Router)                |
+-----------------------------------------------------------------+
       |
       v (Dependencies flow inwards)
+-----------------------------------------------------------------+
|                           Domain Layer                          |
| (Entities/Models [Freezed], Repository Interfaces, Use Cases)   |
+-----------------------------------------------------------------+
       ^
       | (Contracts are defined here)
+-----------------------------------------------------------------+
|                             Data Layer                          |
| (Repository Implementations, Data Sources [Drift DAOs])         |
+-----------------------------------------------------------------+
```


### 2.1.1. Presentation Layer
**Tanggung Jawab:**  
- Menampilkan UI kepada pengguna dan menangani input dari pengguna.  

**Teknologi:**  
- **UI Framework:** Flutter (Material Design 3).  
- **State Management:** Riverpod (dengan Riverpod Generator `@riverpod`).  
  - `AsyncNotifierProvider`: untuk state dari operasi asinkron (database).  
  - `NotifierProvider`: untuk state UI lokal (misalnya, form).  
- **Navigasi:** Go_Router untuk routing deklaratif.  
- **Struktur:**  
  - Fitur diorganisir dalam folder terpisah (misalnya, `features/targets`, `features/transactions`).  
  - Tiap folder fitur memiliki sub-folder: `presentation` (screens, widgets, providers), `domain`, dan `data`.  

---

### 2.1.2. Domain Layer
**Tanggung Jawab:**  
- Berisi logika bisnis inti dan aturan aplikasi.  
- Tidak bergantung pada lapisan lain.  

**Teknologi:**  
- **Entities/Models:** menggunakan Freezed (immutability & mengurangi boilerplate).  
- **Repository Interfaces (Contracts):** mendefinisikan kontrak yang diimplementasikan Data Layer.  
  - Contoh:  
    ```dart
    abstract class TargetRepository {
      ...
    }
    ```
- **Use Cases (Opsional):**  
  - Untuk aplikasi sederhana → logika bisnis langsung di dalam Riverpod Notifiers.  
  - Jika kompleksitas meningkat → gunakan kelas Use Case terpisah.  

---

### 2.1.3. Data Layer
**Tanggung Jawab:**  
- Mengimplementasikan kontrak dari Domain Layer.  
- Menangani semua operasi data (CRUD).  

**Teknologi:**  
- **Repository Implementations:** jembatan antara Domain Layer ↔ Data Sources.  
- **Data Sources:** kelas yang berinteraksi dengan sumber data.  
  - **Local Data Source:** menggunakan **Drift** untuk database SQLite lokal. Drift akan men-generate **Data Access Objects (DAOs)**.  
- **Error Handling:** menggunakan `fpdart` (Either type) → hasil sukses atau gagal (Failure).  

---

## 3. Desain Data

### 3.1. Skema Database
Mengikuti **Skema Database v1.0**, dengan dua tabel utama:  
- **targets**  
- **transactions**  

### 3.2. Data Access Objects (DAOs)
**TargetsDao**:  
- `watchAllTargets(TargetStatus status)`: Stream<List<Target>> berdasarkan status.  
- `insertTarget(TargetCompanion target)`: simpan target baru.  
- `updateTarget(TargetCompanion target)`: update target.  
- `deleteTarget(int id)`: hapus target.  

**TransactionsDao**:  
- `watchTransactionsForTarget(int targetId)`: Stream<List<Transaction>> berdasarkan target.  
- `insertTransaction(TransactionCompanion transaction)`: simpan transaksi baru.  

### 3.3. Kalkulasi Data Turunan (Derived Data)
Untuk memastikan integritas dan akurasi data, beberapa data yang ditampilkan kepada pengguna tidak akan disimpan sebagai kolom terpisah di database, melainkan akan dihitung secara *real-time* (data turunan).

- **Total Terkumpul (Current Progress):** Nilai ini tidak akan disimpan di tabel `targets`. Sebaliknya, nilai ini akan selalu dikalkulasi dengan menjumlahkan (`SUM`) semua nominal dari tabel `transactions` yang memiliki `target_id` yang sama.
- **Alasan Desain:** Pendekatan ini dipilih untuk:
    1.  **Menjamin Integritas Data:** Menghilangkan risiko data `total_terkumpul` menjadi tidak sinkron dengan riwayat transaksi yang sebenarnya.
    2.  **Menyederhanakan Logika:** Logika penyimpanan menjadi lebih sederhana karena hanya perlu menulis ke tabel `transactions` tanpa harus meng-update tabel `targets` secara bersamaan.
- **Implementasi:** Lapisan Presentasi (melalui Riverpod Notifier) akan bertanggung jawab untuk mengambil stream transaksi dan melakukan kalkulasi ini sebelum menampilkannya di UI. Hal ini sangat cocok dengan pola reaktif yang digunakan.

---

## 4. Desain Komponen Rinci (Contoh: Manajemen Target)

### 4.1. UI Components (Widgets)
- **TargetListPage (Screen):**  
  Halaman utama berisi **TabBar** ("In Progress", "Selesai") dan **TabBarView** dengan `ListView` → menampilkan `TargetCardWidget`.  

- **TargetDetailPage (Screen):**  
  Detail target → progress bar besar, ringkasan finansial, daftar transaksi.  

- **AddEditTargetPage (Screen):**  
  Form untuk membuat atau mengedit target.  

- **TargetCardWidget (Widget):**  
  Widget reusable untuk ringkasan target di `TargetListPage`.  

---

### 4.2. State Management (Riverpod Providers)
- **targetRepositoryProvider (@riverpod):** provider yang meng-instantiate `TargetRepositoryImpl`.  
- **targetsProvider(TargetStatus status) (@riverpod):** `AsyncNotifierProvider.family` → memanggil `targetRepository.watchAllTargets(status)`.  
- **targetDetailProvider(int targetId) (@riverpod):** provider gabungan data `TargetsDao` + `TransactionsDao` → menghasilkan detail target lengkap.  

---

### 4.3. Data Flow (Contoh: Menambah Target Baru)
1. Pengguna membuka **AddEditTargetPage** dan mengisi form.  
2. Pengguna menekan tombol **"Simpan"**.  
3. Widget memanggil metode pada **Notifier**.  
4. Notifier memvalidasi input → buat objek `Target` → panggil `addTarget` pada `TargetRepository`.  
5. `TargetRepositoryImpl` memanggil `insertTarget` di `TargetsDao`.  
6. `TargetsDao` mengeksekusi **INSERT** ke SQLite.  
7. `targetsProvider` memancarkan data baru via Stream.  
8. **TargetListPage** rebuild otomatis dengan target baru.  

---

## 5. Desain Navigasi (Go_Router)

**Konfigurasi routing:** dikelola di `app_router.dart`.  

**Rute yang didefinisikan:**  
- `/` → **TargetListPage**  
- `/target/:id` → **TargetDetailPage**  
- `/create-target` → **AddEditTargetPage (create)**  
- `/edit-target/:id` → **AddEditTargetPage (edit)**  

**Contoh Navigasi:**  
- `context.go('/target/1')`  
- `context.push('/create-target')`  

---

## 6. Strategi Penanganan Error

**Sumber Error:**  
- Kegagalan operasi database (misalnya, I/O error).  

**Pola:**  
- Metode di **Data Layer** tidak melempar Exception.  
- Return: `Future<Either<Failure, SuccessType>>`.  

**Failure:**  
- Sealed class → representasi error (misalnya, `DatabaseFailure`).  

**SuccessType:**  
- Tipe data hasil sukses (`void`, `List<Target>`, dll).  

**Di Presentation Layer:**  
- `AsyncNotifier` menangani Either type.  
- Jika `Left(Failure)` → ubah state jadi `AsyncError`.  
- UI menggunakan `.when()` untuk menampilkan loading/data/error.  
- Error ditampilkan via **SnackBar** atau widget error.  

---

## 7. Strategi Logging

**Library:** paket `logger`.  

**Inisialisasi:**  
- Global `Logger` di `main.dart`.  

**Level Penggunaan:**  
- `logger.d()` → debug (state management, variabel penting).  
- `logger.i()` → info (aksi pengguna penting, contoh: "Target 'iPhone' created").  
- `logger.e()` → error (exception atau Failure).  
