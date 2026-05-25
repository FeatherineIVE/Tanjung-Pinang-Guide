import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/token_storage.dart';
import '../models/user_model.dart';
import 'google_auth_service.dart';

/// AuthService terhubung ke backend REST API.
/// Menggantikan auth_service.dart (dummy) dengan real API calls + JWT.
class AuthService extends ChangeNotifier {
  final ApiClient _api;

  UserModel? _currentUser;
  bool _isLoggedIn     = false;
  bool _isGuest        = false;
  bool _isLoading      = false;
  bool _isInitializing = true; // true sampai init() selesai
  String? _error;

  AuthService({ApiClient? api}) : _api = api ?? ApiClient() {
    // Pasang callback auto-logout jika sesi expired
    _api.onSessionExpired = _handleSessionExpired;
  }

  // ── Getters ─────────────────────────────────────────────────────────────────
  bool get isLoggedIn      => _isLoggedIn;
  bool get isGuest         => _isGuest;
  bool get isLoading       => _isLoading;
  bool get isInitializing  => _isInitializing;
  String? get error        => _error;
  UserModel? get currentUser => _currentUser;

  String get userName  => _currentUser?.nama ?? 'Tamu';
  String get userEmail => _currentUser?.email ?? '';
  String? get userPhone => _currentUser?.telepon;
  String? get userBio   => _currentUser?.bio;

  // ── Inisialisasi (cek sesi tersimpan) ───────────────────────────────────
  Future<void> init() async {
    _isInitializing = true;
    final loggedIn = await TokenStorage.isLoggedIn();
    if (loggedIn) {
      final info = await TokenStorage.getUserInfo();
      if (info != null) {
        _currentUser = UserModel(
          id:           info['id'] as int,
          nama:         info['nama'] as String,
          email:        info['email'] as String,
          telepon:      info['telepon'] as String?,
          isGoogleUser: info['isGoogleUser'] as bool? ?? false,
        );
        _isLoggedIn = true;
      } else {
        await TokenStorage.clearAll();
      }
    }
    _isInitializing = false;
    notifyListeners();
  }

  /// Baca ulang state dari SharedPreferences (dipakai setelah Google Sign-In).
  Future<void> restoreFromStorage() async {
    final loggedIn = await TokenStorage.isLoggedIn();
    if (loggedIn) {
      final info = await TokenStorage.getUserInfo();
      if (info != null) {
        _currentUser = UserModel(
          id:           info['id'] as int,
          nama:         info['nama'] as String,
          email:        info['email'] as String,
          telepon:      info['telepon'] as String?,
          isGoogleUser: info['isGoogleUser'] as bool? ?? false,
        );
        _isLoggedIn = true;
        _isGuest    = false;
        notifyListeners();
      }
    }
  }

  // ── Register ──────────────────────────────────────────────────────────────
  /// Mengembalikan null jika sukses, atau pesan error.
  Future<String?> register({
    required String nama,
    required String email,
    required String password,
    String? telepon,
  }) async {
    _setLoading(true);
    try {
      await _api.post(
        ApiConstants.register,
        body: {
          'nama':     nama.trim(),
          'email':    email.trim().toLowerCase(),
          'password': password,
          if (telepon != null && telepon.isNotEmpty) 'telepon': telepon.trim(),
        },
      );
      _setLoading(false);
      return null; // sukses
    } on ApiException catch (e) {
      _setLoading(false);
      return e.message;
    } catch (e) {
      _setLoading(false);
      return 'Gagal terhubung ke server. Periksa koneksi internet.';
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final res = await _api.post(
        ApiConstants.login,
        body: {
          'email':    email.trim().toLowerCase(),
          'password': password,
        },
      );

      final tokens = AuthTokens.fromJson(res['data'] as Map<String, dynamic>);

      // Simpan token dan user info
      await TokenStorage.saveAccessToken(tokens.token);
      await TokenStorage.saveRefreshToken(tokens.refreshToken);
      await TokenStorage.saveUserInfo(
        id:      tokens.user.id,
        nama:    tokens.user.nama,
        email:   tokens.user.email,
        telepon: tokens.user.telepon,
      );

      _currentUser = tokens.user;
      _isLoggedIn  = true;
      _isGuest     = false;
      _setLoading(false);
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      _setLoading(false);
      return e.message;
    } catch (e) {
      _setLoading(false);
      return 'Gagal terhubung ke server. Periksa koneksi internet.';
    }
  }

  // ── Login Tamu ─────────────────────────────────────────────────────────────
  void loginAsGuest() {
    _currentUser = null;
    _isLoggedIn  = false;
    _isGuest     = true;
    notifyListeners();
  }

  // ── Logout ───────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await _api.post(
          ApiConstants.logout,
          body: {'refreshToken': refreshToken},
        );
      }
    } catch (_) {
      // Logout lokal tetap berjalan walau server error
    }

    // Sign out dari Google jika user login via Google
    await GoogleAuthService.signOut();

    await TokenStorage.clearAll();
    _currentUser = null;
    _isLoggedIn  = false;
    _isGuest     = false;
    notifyListeners();
  }

  // ── Auto-logout (session expired / refresh token habis) ────────────────────────
  Future<void> _handleSessionExpired() async {
    await TokenStorage.clearAll();
    await GoogleAuthService.signOut();
    _currentUser = null;
    _isLoggedIn  = false;
    _isGuest     = false;
    notifyListeners();
  }

  // ── Update User Lokal (setelah update profil) ───────────────────────────
  void updateLocalUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // ── Private ───────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }
}
