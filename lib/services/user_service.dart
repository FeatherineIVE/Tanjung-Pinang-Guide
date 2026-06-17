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

  Map<String, dynamic> _stats = {
    'viewedCount': 0,
    'savedCount': 0,
    'averageRating': 0.0,
    'reviewCount': 0,
  };

  // ── Getters ───────────────────────────────────────────────────────────────
  UserModel? get profile   => _profile;
  bool get isLoading       => _isLoading;
  bool get isUpdating      => _isUpdating;
  String? get error        => _error;
  Map<String, dynamic> get stats => _stats;

  // ── Set Local Profile (from AuthService) ──────────────────────────────────
  void setLocalProfile(UserModel user) {
    _profile = user;
    notifyListeners();
  }

  // ── Get Profile Stats ─────────────────────────────────────────────────────
  Future<void> fetchProfileStats(int userId) async {
    _setLoading(true);
    _error = null;
    try {
      final res = await _api.get(ApiConstants.profileStats(userId), withAuth: true);
      if (res['success'] == true) {
        _stats = res['data'] as Map<String, dynamic>;
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Gagal memuat statistik profil.';
    }
    _setLoading(false);
  }

  // ── Update Profile ────────────────────────────────────────────────────────
  Future<String?> updateProfile({
    required int userId,
    required String nama,
    String? bio,
    String? telepon,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final res = await _api.put(
        ApiConstants.updateProfile(userId),
        body: {
          'nama': nama,
          'bio': bio,
          'telepon': telepon,
        },
      );

      if (res['success'] == true) {
        _isUpdating = false;
        notifyListeners();
        return null;
      } else {
        _isUpdating = false;
        notifyListeners();
        return res['message'] ?? 'Gagal memperbarui profil';
      }
    } on ApiException catch (e) {
      _isUpdating = false;
      notifyListeners();
      return e.message;
    } catch (_) {
      _isUpdating = false;
      notifyListeners();
      return 'Gagal terhubung ke server.';
    }
  }

  // ── Clear (saat logout) ────────────────────────────────────────────────────
  void clear() {
    _profile = null;
    _error   = null;
    _stats = {
      'viewedCount': 0,
      'savedCount': 0,
      'averageRating': 0.0,
      'reviewCount': 0,
    };
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
