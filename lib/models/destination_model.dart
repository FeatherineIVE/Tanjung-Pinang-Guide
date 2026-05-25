import 'package:flutter/material.dart';

/// Model destinasi sesuai response backend (destination.model.js).
/// Backend SELECT: d.*, AVG(r.rating) AS rata_rating, COUNT(r.id) AS jumlah_ulasan
class DestinationModel {
  final int id;
  final String nama;
  final String slug;
  final String kategori;
  final String? deskripsi;
  final String? tentang;
  final String? lokasi;
  final String? alamat;
  final String? jamBuka;
  final String? hargaTiket;
  final String? gambar;      // field dari backend: "gambar"
  final double? mapsLat;
  final double? mapsLng;
  final double rataRating;
  final int jumlahUlasan;

  const DestinationModel({
    required this.id,
    required this.nama,
    required this.slug,
    required this.kategori,
    this.deskripsi,
    this.tentang,
    this.lokasi,
    this.alamat,
    this.jamBuka,
    this.hargaTiket,
    this.gambar,
    this.mapsLat,
    this.mapsLng,
    this.rataRating = 0.0,
    this.jumlahUlasan = 0,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id:           json['id'] as int,
      nama:         json['nama'] as String,
      slug:         json['slug'] as String,
      kategori:     json['kategori'] as String,
      deskripsi:    json['deskripsi'] as String?,
      tentang:      json['tentang'] as String?,
      lokasi:       json['lokasi'] as String?,
      alamat:       json['alamat'] as String?,
      jamBuka:      json['jam_buka'] as String?,
      hargaTiket:   json['harga_tiket'] as String?,
      // Backend menggunakan field "gambar", bukan "image_path"
      gambar:       json['gambar'] as String?,
      mapsLat:      (json['maps_lat'] as num?)?.toDouble(),
      mapsLng:      (json['maps_lng'] as num?)?.toDouble(),
      rataRating:   double.tryParse(json['rata_rating']?.toString() ?? '0') ?? 0.0,
      jumlahUlasan: (json['jumlah_ulasan'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id':           id,
        'nama':         nama,
        'slug':         slug,
        'kategori':     kategori,
        'deskripsi':    deskripsi,
        'tentang':      tentang,
        'lokasi':       lokasi,
        'alamat':       alamat,
        'jam_buka':     jamBuka,
        'harga_tiket':  hargaTiket,
        'gambar':       gambar,
        'maps_lat':     mapsLat,
        'maps_lng':     mapsLng,
        'rata_rating':  rataRating,
        'jumlah_ulasan': jumlahUlasan,
      };

  // ── Warna berdasarkan kategori backend (Wisata Pantai, Wisata Sejarah, dll) ──
  Color get categoryColor {
    final k = kategori.toLowerCase();
    if (k.contains('pantai'))  return const Color(0xFF1A9BD7);
    if (k.contains('sejarah')) return const Color(0xFFEF5350);
    if (k.contains('alam'))    return const Color(0xFF66BB6A);
    if (k.contains('kuliner')) return const Color(0xFFFF7043);
    return const Color(0xFF90A4AE);
  }

  /// Rating diformat 1 desimal
  String get ratingFormatted => rataRating.toStringAsFixed(1);

  /// Path gambar: field "gambar" dari backend, fallback ke asset lokal
  String get displayImagePath {
    if (gambar != null && gambar!.isNotEmpty) {
      // Jika gambar dari backend adalah path relatif seperti "/pantai-trikora.jpg"
      // dan bukan URL lengkap, fallback ke asset
      if (gambar!.startsWith('http')) return gambar!;
    }
    // Fallback berdasarkan kategori
    final k = kategori.toLowerCase();
    if (k.contains('pantai'))  return 'assets/images/onboarding1.jpg';
    if (k.contains('sejarah')) return 'assets/images/onboarding3.jpg';
    if (k.contains('alam'))    return 'assets/images/onboarding2.jpg';
    if (k.contains('kuliner')) return 'assets/images/onboarding3.jpg';
    return 'assets/images/onboarding1.jpg';
  }

  // Getter backward compatibility
  String? get imagePath => gambar;
}
