import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/destination_model.dart';

/// Service bookmark yang terhubung ke backend (JWT-protected).
/// Menggantikan FavoriteService (dummy) dengan real API calls.
class BookmarkService extends ChangeNotifier {
  final ApiClient _api;

  // Set ID destinasi yang sudah dibookmark (untuk O(1) lookup)
  final Set<int> _bookmarkedIds = {};
  List<DestinationModel> _bookmarks = [];
  bool _isLoading = false;
  String? _error;

  BookmarkService({ApiClient? api}) : _api = api ?? ApiClient();

  // ── Getters ───────────────────────────────────────────────────────────────
  List<DestinationModel> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isBookmarked(int destinationId) => _bookmarkedIds.contains(destinationId);

  // ── Fetch All ─────────────────────────────────────────────────────────────
  Future<void> fetchAll() async {
    _setLoading(true);
    _error = null;
    try {
      final res = await _api.get(ApiConstants.bookmarks, withAuth: true);
      final List<dynamic> list = res['data'] as List<dynamic>? ?? [];
      _bookmarks = list
          .map((e) => DestinationModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _bookmarkedIds
        ..clear()
        ..addAll(_bookmarks.map((d) => d.id));
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Gagal memuat favorit.';
    }
    _setLoading(false);
  }

  // ── Toggle Bookmark ────────────────────────────────────────────────────────
  /// Mengembalikan true jika berhasil, false jika gagal.
  Future<bool> toggle(DestinationModel destination) async {
    if (isBookmarked(destination.id)) {
      return await remove(destination.id);
    } else {
      return await add(destination);
    }
  }

  // ── Add ────────────────────────────────────────────────────────────────────
  Future<bool> add(DestinationModel destination) async {
    try {
      await _api.post(
        ApiConstants.bookmarkById(destination.id),
        withAuth: true,
      );
      _bookmarks.add(destination);
      _bookmarkedIds.add(destination.id);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Gagal menambahkan ke favorit.';
      notifyListeners();
      return false;
    }
  }

  // ── Remove ─────────────────────────────────────────────────────────────────
  Future<bool> remove(int destinationId) async {
    try {
      await _api.delete(
        ApiConstants.bookmarkById(destinationId),
        withAuth: true,
      );
      _bookmarks.removeWhere((d) => d.id == destinationId);
      _bookmarkedIds.remove(destinationId);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Gagal menghapus dari favorit.';
      notifyListeners();
      return false;
    }
  }

  // ── Clear (saat logout) ────────────────────────────────────────────────────
  void clear() {
    _bookmarks.clear();
    _bookmarkedIds.clear();
    _error = null;
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
