import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/rating_model.dart';

/// Service rating terhubung ke backend.
class RatingService extends ChangeNotifier {
  final ApiClient _api;

  // Cache ratings per destinasi { destinationId: [RatingModel] }
  final Map<int, List<RatingModel>> _ratingsCache = {};
  bool _isLoading  = false;
  bool _isPosting  = false;
  String? _error;

  RatingService({ApiClient? api}) : _api = api ?? ApiClient();

  // ── Getters ───────────────────────────────────────────────────────────────
  bool get isLoading  => _isLoading;
  bool get isPosting  => _isPosting;
  String? get error   => _error;

  List<RatingModel> ratingsFor(int destinationId) =>
      _ratingsCache[destinationId] ?? [];

  // ── Fetch Ratings ─────────────────────────────────────────────────────────
  Future<void> fetchByDestination(int destinationId) async {
    _setLoading(true);
    _error = null;
    try {
      final res = await _api.get(
        ApiConstants.ratingsByDestination(destinationId),
      );
      final List<dynamic> list = res['data'] as List<dynamic>? ?? [];
      _ratingsCache[destinationId] = list
          .map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Gagal memuat ulasan.';
    }
    _setLoading(false);
  }

  // ── Submit Rating ─────────────────────────────────────────────────────────
  /// Mengembalikan null jika sukses, atau pesan error.
  Future<String?> submitRating({
    required int destinationId,
    required double rating,
    required String komentar,
  }) async {
    _isPosting = true;
    _error     = null;
    notifyListeners();
    try {
      await _api.post(
        ApiConstants.ratingsByDestination(destinationId),
        body: {
          'rating':   rating.toInt(),
          'komentar': komentar.trim(),
        },
        withAuth: true,
      );
      // Refresh cache setelah submit
      await fetchByDestination(destinationId);
      _isPosting = false;
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      _isPosting = false;
      notifyListeners();
      return e.message;
    } catch (_) {
      _isPosting = false;
      notifyListeners();
      return 'Gagal mengirim ulasan. Periksa koneksi internet.';
    }
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
