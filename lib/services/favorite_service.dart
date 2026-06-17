import 'package:flutter/foundation.dart';
import 'package:tanjung_pinang_guide/core/constants/api_constants.dart';
import 'package:tanjung_pinang_guide/core/network/api_client.dart';
import 'package:tanjung_pinang_guide/models/destination_model.dart';

class FavoriteService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<DestinationModel> _favorites = [];
  bool _isLoading = false;

  List<DestinationModel> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> fetchFavorites(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiClient.get('${ApiConstants.favorites}?userId=$userId', withAuth: true);
      if (response['success'] == true) {
        final List data = response['data'];
        _favorites = data.map((json) => DestinationModel.fromJson(json)).toList();
      }
    } catch (e, stacktrace) {
      print('Error fetchFavorites: $e');
      print(stacktrace);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkFavorite(int userId, int destinationId) async {
    try {
      final response = await _apiClient.get('${ApiConstants.checkFavorite(destinationId)}?userId=$userId', withAuth: true);
      if (response['success'] == true) {
        return response['data']['isFavorite'] == true;
      }
    } catch (_) { }
    return false;
  }

  Future<bool> addFavorite(int userId, DestinationModel destination) async {
    // Optimistic update
    if (!_favorites.any((d) => d.id == destination.id)) {
      _favorites.insert(0, destination);
      notifyListeners();
    }
    try {
      final response = await _apiClient.post(
        ApiConstants.favorites,
        body: {'userId': userId, 'destinationId': destination.id},
        withAuth: true,
      );
      if (response['success'] == true) {
        // Biarkan background fetch update ulang
        fetchFavorites(userId);
        return true;
      }
    } catch (_) { }
    // Rollback jika gagal
    _favorites.removeWhere((d) => d.id == destination.id);
    notifyListeners();
    return false;
  }

  Future<bool> removeFavorite(int userId, int destinationId) async {
    // Optimistic update
    final backup = _favorites.toList();
    _favorites.removeWhere((d) => d.id == destinationId);
    notifyListeners();

    try {
      final response = await _apiClient.delete(
        ApiConstants.removeFavorite(destinationId),
        body: {'userId': userId},
        withAuth: true,
      );
      if (response['success'] == true) {
        fetchFavorites(userId);
        return true;
      }
    } catch (_) { }
    
    // Rollback
    _favorites = backup;
    notifyListeners();
    return false;
  }

  void clear() {
    _favorites.clear();
    notifyListeners();
  }
}

