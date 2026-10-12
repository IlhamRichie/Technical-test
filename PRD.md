# 📄 Product Requirement Document (PRD)
**Proyek:** Juber Technical Test - SSO Auth & CRUD App  
**Kandidat:** M. Ilham Rigan Agachi (@maachigan)  
**Tanggal Dokumen:** Oktober 2026  
**Status:** 🟢 Ready for Development & Presentation  

---

## 1. Ringkasan Eksekutif (Executive Summary)
Pengembangan aplikasi mobile/web yang difokuskan pada keamanan akses dan manajemen data. Aplikasi ini dirancang untuk mendemonstrasikan integrasi autentikasi pihak ketiga (Google SSO), manajemen sesi yang aman, desain UI/UX yang responsif, validasi data secara mock maupun real-time, serta interaksi API menggunakan spesifikasi OpenAPI untuk operasi CRUD. Kualitas perangkat lunak dijamin melalui implementasi test case (Unit & Widget Test) langsung di dalam source code.

---

## 2. Objektif Produk
- **Keamanan & Aksesibilitas:** Memberikan kemudahan login via Google Sign-In dan mengamankan sesi pengguna menggunakan Secure Storage.
- **Integritas Data:** Memastikan tidak ada data invalid yang terkirim ke server melalui penerapan Mock Validation pada form.
- **Fungsionalitas Optimal:** Mengintegrasikan endpoint API (OpenAPI) untuk fungsi Create, Read, Update, dan Delete (CRUD) dengan penanganan state yang mulus (loading, error, empty state).
- **Software Quality Assurance:** Membuktikan stabilitas aplikasi dan logika bisnis melalui penulisan test case di dalam kode.

---

## 3. Ruang Lingkup Fitur (Functional Requirements)

### Epic 1: Authentication & Session Management
- **Fitur 1.1 - Google SSO (Single Sign-On):** Pengguna dapat masuk menggunakan kredensial Google mereka tanpa harus membuat akun manual.
- **Fitur 1.2 - Secure Session Persistence:** Token auth dari SSO atau API disimpan secara lokal dengan enkripsi (menggunakan Keystore/Keychain). Aplikasi otomatis melewati layar login jika token masih valid (Auto-Login).
- **Fitur 1.3 - Logout:** Menghapus seluruh data sesi dari Secure Storage secara permanen dan memulangkan pengguna ke halaman Login.

### Epic 2: UI/UX & Mock Validation
- **Fitur 2.1 - Form Validation:** Pengecekan real-time di sisi klien (sebelum hit API) untuk format email, batas minimal karakter password, dan form kosong.
- **Fitur 2.2 - Mock API Error Handling:** Simulasi respon error dari server (misal: timeout atau validasi server) dengan menampilkan Snackbar/Toast yang informatif kepada pengguna.
- **Fitur 2.3 - Intuitive UI:** Transisi antar layar yang mulus, indikator loading saat memproses data, dan desain responsif.

### Epic 3: Data Management (CRUD API Integration)
- **Fitur 3.1 - Read (List View):** Mengambil data dari OpenAPI dan menampilkannya dalam format list/grid. Mendukung Pull-to-Refresh.
- **Fitur 3.2 - Create (Add Form):** Form untuk menambah entri data baru yang langsung memperbarui List View setelah sukses.
- **Fitur 3.3 - Update (Edit Form):** Mengubah detail entri data yang sudah ada.
- **Fitur 3.4 - Delete:** Menghapus data dengan memunculkan Dialog Konfirmasi untuk mencegah penghapusan tidak sengaja.

---

## 4. Kebutuhan Teknis (Non-Functional Requirements)
- **Tech Stack:** Flutter / Dart
- **State Management & Routing:** GetX (get_cli structure)
- **API Specification:** Berbasis OpenAPI / Swagger
- **Architecture:** Clean Architecture / MVVM untuk memisahkan UI, Business Logic, dan Data Layer
- **Security:** Kredensial tidak boleh ditulis langsung (hardcoded) di dalam kode (menggunakan file `.env`)

---

## 5. Strategi Pengujian (Testing Requirements)
Test case disertakan langsung di dalam struktur folder kode (`/test`):

### Unit Testing
1. Menguji fungsi Form Validation (`validateEmail`, `validatePassword`, `validateRequired`, `validateNumber`).
2. Menguji Data Model parsing (JSON ke Object dan Object ke JSON).
3. Menguji Repository / API Service menggunakan Mocking (`mocktail`) tanpa memanggil API sungguhan.

### Widget / UI Testing
1. Memastikan elemen UI utama (Login Button, TextFormField, List Item) render dengan benar.
2. Mensimulasikan klik tombol pada form kosong untuk memicu kemunculan pesan validasi error.
3. Mensimulasikan klik tombol aksi konfirmasi dialog.

---

## 6. Kriteria Penerimaan (Acceptance Criteria)
- [x] Terdapat opsi Sign-In with Google di layar utama.
- [x] Form input tidak dapat di-submit jika kosong atau format salah.
- [x] Token login berhasil tersimpan terenkripsi.
- [x] Pengguna bisa melihat, menambah, mengubah, dan menghapus data (CRUD) yang terhubung dengan API.
- [x] Terdapat struktur error handling UI jika API gagal diakses.
- [x] Test suite (skrip testing) dapat dijalankan melalui CLI (`flutter test`) dan seluruh tes berstatus PASS.
- [x] Repositori GitHub dilengkapi dengan Readme teknis untuk instalasi dan dokumentasi.
