/// Model rating sesuai response backend (rating.model.js).
/// Query: SELECT r.id, r.rating, r.komentar, r.created_at, u.nama AS nama_user
class RatingModel {
  final int id;
  final double rating;
  final String komentar;
  final String createdAt;
  final String namaUser;

  const RatingModel({
    required this.id,
    required this.rating,
    required this.komentar,
    required this.createdAt,
    required this.namaUser,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id:        json['id'] as int,
      rating:    (json['rating'] as num).toDouble(),
      komentar:  json['komentar'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      namaUser:  json['nama_user'] as String? ?? 'Pengguna',
    );
  }
}
