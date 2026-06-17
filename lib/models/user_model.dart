/// Model user sesuai response backend:
/// SELECT id, nama, email, telepon, bio, created_at FROM users
class UserModel {
  final int id;
  final String nama;
  final String email;
  final String? telepon;
  final String? bio;
  final String? role;
  final String? status;
  final String? avatarUrl;
  final String? createdAt;
  /// True jika user login via Google (tidak punya password lokal)
  final bool isGoogleUser;

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    this.telepon,
    this.bio,
    this.role,
    this.status,
    this.avatarUrl,
    this.createdAt,
    this.isGoogleUser = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:        json['id'] as int,
      nama:      json['nama'] as String,
      email:     json['email'] as String,
      telepon:   json['telepon'] as String?,
      bio:       json['bio'] as String?,
      role:      json['role'] as String?,
      status:    json['status'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id':         id,
        'nama':       nama,
        'email':      email,
        'telepon':    telepon,
        'bio':        bio,
        'role':       role,
        'status':     status,
        'avatar_url': avatarUrl,
        'created_at': createdAt,
      };

  /// Untuk update profile, hanya kirim field yang bisa diubah
  Map<String, dynamic> toUpdateJson() => {
        'nama':    nama,
        'bio':     bio,
        'telepon': telepon,
      };

  UserModel copyWith({
    int? id,
    String? nama,
    String? email,
    String? telepon,
    String? bio,
    String? createdAt,
    bool? isGoogleUser,
  }) {
    return UserModel(
      id:           id ?? this.id,
      nama:         nama ?? this.nama,
      email:        email ?? this.email,
      telepon:      telepon ?? this.telepon,
      bio:          bio ?? this.bio,
      createdAt:    createdAt ?? this.createdAt,
      isGoogleUser: isGoogleUser ?? this.isGoogleUser,
    );
  }
}

/// Model untuk data login response
class AuthTokens {
  final String token;
  final String tokenType;
  final int expiresIn;
  final String refreshToken;
  final UserModel user;

  const AuthTokens({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
    required this.user,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      token:        json['token'] as String,
      tokenType:    json['token_type'] as String? ?? 'Bearer',
      expiresIn:    json['expires_in'] as int? ?? 900,
      refreshToken: json['refreshToken'] as String,
      user:         UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
