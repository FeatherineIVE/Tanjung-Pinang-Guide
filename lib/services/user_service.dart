import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/user_model.dart';

/// Service profil user yang terhubung ke backend (JWT-protected).
class UserService extends ChangeNotifier {
  final ApiClient _api;

  UserModel? _profile;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _error;

  UserService({ApiClient? api}) : _api = api ?? ApiClient();

  // ── Getters ───────────────────────────────────────────────────────────────
  UserModel? get profile   => _profile;
  bool get isLoading       => _isLoading;
  bool get isUpdating      => _isUpdating;
  String? get error        => _error;

  // ── Get Profile ───────────────────────────────────────────────────────────
  Future<void> fetchProfile() async {
    _setLoading(true);
    _error = null;
    try {
      final res = await _api.get(ApiConstants.profile, withAuth: true);
      _profile = UserModel.fromJson(res['data'] as Map<String, dynamic>);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Gagal memuat profil.';
    }
    _setLoading(false);
  }

  // ── Update Profile ────────────────────────────────────────────────────────
  /// Mengembalikan null jika sukses, atau pesan error.
  Future<String?> updateProfile({
    required String nama,
    String? bio,
    String? telepon,
  }) async {
    _isUpdating = true;
    _error      = null;
    notifyListeners();
    try {
      final res = await _api.put(
        ApiConstants.profile,
        body: {
          'nama':    nama.trim(),
          'bio':     bio?.trim(),
          'telepon': telepon?.trim(),
        },
        withAuth: true,
      );
      _profile = UserModel.fromJson(res['data'] as Map<String, dynamic>);
      _isUpdating = false;
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      _isUpdating = false;
      notifyListeners();
      return e.message;
    } catch (_) {
      _isUpdating = false;
      notifyListeners();
      return 'Gagal memperbarui profil. Periksa koneksi internet.';
    }
  }

  // ── Clear (saat logout) ────────────────────────────────────────────────────
  void clear() {
    _profile = null;
    _error   = null;
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
