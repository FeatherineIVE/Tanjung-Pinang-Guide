import 'package:flutter/material.dart';
import 'destination_data.dart';

/// Service untuk mengelola favorit destinasi
/// Gunakan sebagai ChangeNotifier provider di widget tree
class FavoriteService extends ChangeNotifier {
  static FavoriteService? _instance;

  factory FavoriteService() {
    _instance ??= FavoriteService._private();
    return _instance!;
  }

  FavoriteService._private();

  final List<DestinationData> _favorites = [];

  List<DestinationData> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(DestinationData destination) {
    return _favorites.any((d) => d.title == destination.title);
  }

  void toggleFavorite(DestinationData destination) {
    if (isFavorite(destination)) {
      _favorites.removeWhere((d) => d.title == destination.title);
    } else {
      _favorites.add(destination);
    }
    notifyListeners();
  }

  void addFavorite(DestinationData destination) {
    if (!isFavorite(destination)) {
      _favorites.add(destination);
      notifyListeners();
    }
  }

  void removeFavorite(DestinationData destination) {
    final index = _favorites.indexWhere((d) => d.title == destination.title);
    if (index != -1) {
      _favorites.removeAt(index);
      notifyListeners();
    }
  }

  void clearAllFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
