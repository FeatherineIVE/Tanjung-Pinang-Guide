/// Konstanta API untuk koneksi Flutter → Backend
/// Ganti BASE_URL sesuai environment:
///   - Android Emulator : http://10.0.2.2:3000
///   - HP Fisik (WiFi)  : http://<IP_LOKAL>:3000
///   - Web / Desktop    : http://localhost:3000
library;

class ApiConstants {
  // ── Base URL ─────────────────────────────────────────────────────────────
  // URL Backend Hosting dari VPS Teman Anda
  static const String baseUrl = 'https://svarna.infinitelearningstudent.id';

  // ── Auth Endpoints ────────────────────────────────────────────────────────
  static const String register       = '/api/auth/register';
  static const String login          = '/api/auth/login';
  static const String googleLogin    = '/api/auth/google';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String logout         = '/api/auth/logout'; // Keep if frontend uses local logout or we might not need it for JWT
  static const String refresh        = '/api/auth/refresh';

  // ── Destination Endpoints ─────────────────────────────────────────────────
  static const String destinations = '/api/destinations';
  static String destinationById(int id) => '/api/destinations/$id';
  static String destinationBySlug(String slug) => '/api/destinations/$slug'; // Note: Backend router says router.get("/:slug", getDestinationBySlug)
  static String destinationVisit(int id) => '/api/destinations/$id/visit';

  // ── Favorite Endpoints ────────────────────────────────────────────────────
  static const String favorites = '/api/favorites';
  static String checkFavorite(int destinationId) => '/api/favorites/check/$destinationId';
  static String removeFavorite(int destinationId) => '/api/favorites/$destinationId';

  // ── Review Endpoints ──────────────────────────────────────────────────────
  static const String reviews = '/api/reviews';
  static String reviewsByDestination(int id) => '/api/reviews/destination/$id';
  static String reviewById(int id) => '/api/reviews/$id';

  // ── User / Profile Endpoints ──────────────────────────────────────────────
  static String profileStats(int userId) => '/api/profile/$userId/stats';
  static String updateProfile(int userId) => '/api/profile/$userId';
  
  // ── Itinerary Endpoints ───────────────────────────────────────────────────
  static const String generateItinerary = '/api/itineraries/generate';
  static String userItineraries(int userId) => '/api/itineraries/user/$userId';
  static String itineraryById(int id) => '/api/itineraries/$id';

  // ── Travel Guide Endpoints ────────────────────────────────────────────────
  static const String travelGuides = '/api/travel-guides';
}
