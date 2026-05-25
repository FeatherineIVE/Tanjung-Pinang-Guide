import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan dan membaca token JWT dari SharedPreferences.
class TokenStorage {
  static const _keyAccessToken    = 'access_token';
  static const _keyRefreshToken   = 'refresh_token';
  static const _keyUserId         = 'user_id';
  static const _keyUserName       = 'user_name';
  static const _keyUserEmail      = 'user_email';
  static const _keyUserPhone      = 'user_phone';
  static const _keyIsGoogleUser   = 'is_google_user';
  /// Flag permanen: true jika user pernah login setidaknya satu kali.
  /// TIDAK dihapus saat logout — hanya untuk kontrol onboarding.
  static const _keyHasEverLoggedIn = 'has_ever_logged_in';

  // ── Access Token ─────────────────────────────────────────────────────────
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // ── Refresh Token ─────────────────────────────────────────────────────────
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRefreshToken, token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  // ── User Info ─────────────────────────────────────────────────────────────
  static Future<void> saveUserInfo({
    required int id,
    required String nama,
    required String email,
    String? telepon,
    bool isGoogleUser = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, id);
    await prefs.setString(_keyUserName, nama);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setBool(_keyIsGoogleUser, isGoogleUser);
    // Tandai bahwa user sudah pernah login (permanen, tidak dihapus saat logout)
    await prefs.setBool(_keyHasEverLoggedIn, true);
    if (telepon != null) {
      await prefs.setString(_keyUserPhone, telepon);
    } else {
      await prefs.remove(_keyUserPhone);
    }
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_keyUserId);
    if (id == null) return null;
    return {
      'id':           id,
      'nama':         prefs.getString(_keyUserName) ?? '',
      'email':        prefs.getString(_keyUserEmail) ?? '',
      'telepon':      prefs.getString(_keyUserPhone),
      'isGoogleUser': prefs.getBool(_keyIsGoogleUser) ?? false,
    };
  }

  // ── Clear All ─────────────────────────────────────────────────────────────
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPhone);
    await prefs.remove(_keyIsGoogleUser);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken  = prefs.getString(_keyAccessToken);
    final refreshToken = prefs.getString(_keyRefreshToken);
    // Dianggap login jika ada salah satu token (access atau refresh)
    return (accessToken != null && accessToken.isNotEmpty) ||
           (refreshToken != null && refreshToken.isNotEmpty);
  }

  /// Apakah user sudah pernah login sebelumnya di device ini?
  /// Flag ini permanen — tidak dihapus saat logout.
  static Future<bool> hasEverLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasEverLoggedIn) ?? false;
  }
}
