/// Konstanta API untuk koneksi Flutter → Backend
/// Ganti BASE_URL sesuai environment:
///   - Android Emulator : http://10.0.2.2:3000
///   - HP Fisik (WiFi)  : http://<IP_LOKAL>:3000
///   - Web / Desktop    : http://localhost:3000

class ApiConstants {
  // ── Base URL ─────────────────────────────────────────────────────────────
  // Android emulator menggunakan 10.0.2.2 sebagai alias localhost host machine
  static const String baseUrl = 'http://10.0.2.2:3000';

  // ── Auth Endpoints ────────────────────────────────────────────────────────
  static const String register   = '/api/auth/register';
  static const String login      = '/api/auth/login';
  static const String logout     = '/api/auth/logout';
  static const String refresh    = '/api/auth/refresh';
  static const String googleAuth = '/api/auth/google';

  // ── Google Sign-In ─────────────────────────────────────────────────────────────────
  /// Web Client ID dari Google Cloud Console → APIs & Services → Credentials
  /// → OAuth 2.0 Client IDs → Web client (auto created by Google Service)
  /// Kosong = gunakan accessToken fallback (tetap berfungsi tanpa konfigurasi ini)
  static const String googleWebClientId = '';

  // ── Destination Endpoints ─────────────────────────────────────────────────
  static const String destinations     = '/api/destinations';
  static String destinationById(int id) => '/api/destinations/$id';
  static String destinationBySlug(String slug) => '/api/destinations/slug/$slug';

  // ── Bookmark Endpoints ────────────────────────────────────────────────────
  static const String bookmarks = '/api/bookmarks';
  static String bookmarkById(int id) => '/api/bookmarks/$id';

  // ── Rating Endpoints ──────────────────────────────────────────────────────
  static String ratingsByDestination(int id) => '/api/destinations/$id/ratings';

  // ── User Endpoints ────────────────────────────────────────────────────────
  static const String profile = '/api/users/me';

  // ── Chat Endpoint ─────────────────────────────────────────────────────────
  static const String chat = '/api/chat';
}
