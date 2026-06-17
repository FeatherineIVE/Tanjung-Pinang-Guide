import 'package:flutter/material.dart';

/// Model destinasi sesuai response backend.
/// Backend mengembalikan field berbahasa Inggris:
/// name, category, location, description, image, ratingAverage, reviewCount, ticketPrice, dst.
class DestinationModel {
  final int id;
  final String nama;        // backend: name
  final String slug;
  final String kategori;    // backend: category
  final String? deskripsi;  // backend: description
  final String? lokasi;     // backend: location
  final String? jamBuka;    // backend: openingHours
  final String? hargaTiket; // backend: ticketPrice (num → formatted)
  final String? gambar;     // backend: image / mainImage
  final String? mapsUrl;    // backend: mapsUrl / mapsLink
  final double rataRating;  // backend: ratingAverage
  final int jumlahUlasan;   // backend: reviewCount
  final int jumlahKunjungan; // backend: visitCount
  final List<String> gallery; // backend: galleryImages
  final String? travelTips;
  final String? transportRecommendation;
  final num estimatedCostMin;
  final num estimatedCostMax;
  final String? recommendedDuration;

  const DestinationModel({
    required this.id,
    required this.nama,
    required this.slug,
    required this.kategori,
    this.deskripsi,
    this.lokasi,
    this.jamBuka,
    this.hargaTiket,
    this.gambar,
    this.mapsUrl,
    this.rataRating = 0.0,
    this.jumlahUlasan = 0,
    this.jumlahKunjungan = 0,
    this.gallery = const [],
    this.travelTips,
    this.transportRecommendation,
    this.estimatedCostMin = 0,
    this.estimatedCostMax = 0,
    this.recommendedDuration,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    // Backend uses English field names
    final ticketPrice = json['ticketPrice'] ?? json['ticket_price'];
    final String hargaTiket = (ticketPrice != null && ticketPrice != 0)
        ? 'Rp ${ticketPrice.toString()}'
        : 'Gratis';

    final List<String> galleryImages = [];
    final rawGallery = json['galleryImages'] ?? json['gallery'];
    if (rawGallery is List) {
      for (final item in rawGallery) {
        if (item is String && item.isNotEmpty) galleryImages.add(item);
      }
    }

    return DestinationModel(
      id:       json['id'] as int,
      nama:     json['name']     as String? ?? json['nama']     as String? ?? '',
      slug:     json['slug']     as String? ?? '',
      kategori: json['category'] as String? ?? json['kategori'] as String? ?? '',
      deskripsi: json['description'] as String? ?? json['deskripsi'] as String?,
      lokasi:    json['location']    as String? ?? json['lokasi']    as String?,
      jamBuka:   json['openingHours'] as String?
              ?? json['opening_hours'] as String?
              ?? json['jamBuka'] as String?,
      hargaTiket: hargaTiket,
      gambar:  json['image']    as String?
            ?? json['mainImage'] as String?
            ?? json['gambar']   as String?,
      mapsUrl: json['mapsUrl']  as String?
            ?? json['mapsLink'] as String?
            ?? json['maps_url'] as String?,
      rataRating: double.tryParse(json['ratingAverage']?.toString() ?? '') 
               ?? double.tryParse(json['rata_rating']?.toString() ?? '') 
               ?? 0.0,
      jumlahUlasan:    int.tryParse(json['reviewCount']?.toString() ?? '')
                    ?? int.tryParse(json['jumlah_ulasan']?.toString() ?? '')
                    ?? 0,
      jumlahKunjungan: int.tryParse(json['visitCount']?.toString() ?? '')
                    ?? int.tryParse(json['visit_count']?.toString() ?? '')
                    ?? 0,
      gallery: galleryImages,
      travelTips:              json['travelTips']              as String?,
      transportRecommendation: json['transportRecommendation'] as String?,
      estimatedCostMin: num.tryParse(json['estimatedCostMin']?.toString() ?? '') ?? 0,
      estimatedCostMax: num.tryParse(json['estimatedCostMax']?.toString() ?? '') ?? 0,
      recommendedDuration: json['recommendedDuration'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':            id,
    'name':          nama,
    'slug':          slug,
    'category':      kategori,
    'description':   deskripsi,
    'location':      lokasi,
    'openingHours':  jamBuka,
    'image':         gambar,
    'mapsUrl':       mapsUrl,
    'ratingAverage': rataRating,
    'reviewCount':   jumlahUlasan,
    'visitCount':    jumlahKunjungan,
  };

  // ── Warna berdasarkan kategori ──────────────────────────────────────────────
  Color get categoryColor {
    final k = kategori.toLowerCase();
    if (k.contains('pantai') || k.contains('beach'))    return const Color(0xFF1A9BD7);
    if (k.contains('sejarah') || k.contains('histor'))  return const Color(0xFFEF5350);
    if (k.contains('alam') || k.contains('nature'))     return const Color(0xFF66BB6A);
    if (k.contains('kuliner') || k.contains('food'))    return const Color(0xFFFF7043);
    return const Color(0xFF90A4AE);
  }

  String get ratingFormatted => rataRating.toStringAsFixed(1);

  /// Path gambar: gunakan URL backend jika ada, fallback ke asset lokal
  String get displayImagePath {
    if (gambar != null && gambar!.isNotEmpty && (gambar!.startsWith('http') || gambar!.startsWith('data:image'))) {
      return gambar!;
    }
    final k = kategori.toLowerCase();
    if (k.contains('pantai'))  return 'assets/images/onboarding1.jpg';
    if (k.contains('sejarah')) return 'assets/images/onboarding3.jpg';
    if (k.contains('alam'))    return 'assets/images/onboarding2.jpg';
    if (k.contains('kuliner')) return 'assets/images/onboarding3.jpg';
    return 'assets/images/onboarding1.jpg';
  }

  // Getter backward compatibility
  String? get imagePath => gambar;
  String? get tentang   => deskripsi;
  String? get alamat    => lokasi;
  // Backend tidak mengembalikan koordinat lat/lng
  double? get mapsLat   => null;
  double? get mapsLng   => null;
}
