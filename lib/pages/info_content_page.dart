import 'package:flutter/material.dart';

class InfoContentPage extends StatelessWidget {
  final String title;
  final String content;

  const InfoContentPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A9BD7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}

class InfoContentData {
  static const String tentang = '''
Tanjung Pinang Guide adalah aplikasi pintar berbasis AI yang siap menjadi teman perjalanan Anda selama menjelajahi keindahan Kota Tanjung Pinang.

Dibuat dengan dedikasi untuk memperkenalkan pariwisata Kepulauan Riau, aplikasi ini menyajikan rekomendasi destinasi, panduan kuliner, hingga fitur penyusunan Itinerary otomatis menggunakan teknologi kecerdasan buatan.

Versi: 1.0.0
© 2026 Tim Pengembang
''';

  static const String privasi = '''
Kebijakan Privasi

1. Pengumpulan Data
Kami mengumpulkan informasi nama, email, dan preferensi wisata Anda saat mendaftar untuk memberikan rekomendasi yang dipersonalisasi.

2. Penggunaan Data
Data Anda digunakan secara eksklusif untuk menyusun Itinerary AI dan memberikan notifikasi destinasi terbaru. Kami tidak menjual data pengguna kepada pihak ketiga.

3. Keamanan
Semua data dienkripsi dengan standar keamanan modern. Anda dapat meminta penghapusan akun kapan saja dengan menghubungi dukungan pelanggan kami.
''';

  static const String bantuan = '''
Bantuan & FAQ

Q: Bagaimana cara kerja AI Itinerary?
A: Anda hanya perlu memasukkan jumlah hari, anggaran, dan minat. AI kami akan memproses dan memilihkan rute optimal beserta estimasi biayanya.

Q: Apakah saya bisa mengubah profil saya?
A: Tentu. Masuk ke menu Profil lalu pilih Edit Profil. Perubahan akan segera diaplikasikan pada pengalaman Anda.

Q: Aplikasi ini error/crash, apa yang harus saya lakukan?
A: Pastikan Anda terkoneksi ke internet. Jika masalah berlanjut, hubungi kami di support@tanjungpinangguide.com.
''';

  static const String bahasa = '''
Pengaturan Bahasa

Saat ini Tanjung Pinang Guide hanya mendukung Bahasa Indonesia. 

Dukungan untuk Bahasa Inggris (English) dan Bahasa Melayu sedang dalam tahap pengembangan dan akan dirilis pada pembaruan berikutnya!
''';
}
