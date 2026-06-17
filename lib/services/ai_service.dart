import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiService extends ChangeNotifier {
  static const String chatbotUrl = 'https://sirojulf-chatbot-itinerary.hf.space';
  static const String recoUrl = 'https://sirojulf-recommendation-system.hf.space';

  static const Duration _timeout = Duration(seconds: 90);

  bool _isGenerating = false;
  String? _error;
  
  bool get isGenerating => _isGenerating;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Chatbot ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> generateItinerary({
    required int days,
    required int budgetPerDay,
    required List<String> interests,
    required String activeHours,
    required String startLocation,
    double minRating = 4.0,
    int maxPriceLevel = 2,
  }) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final res = await http
          .post(
          Uri.parse('$chatbotUrl/itinerary'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'days': days,
            'budget_per_day': budgetPerDay,
            'interests': interests,
            'active_hours': activeHours,
            'start_location': startLocation,
            'min_rating': minRating,
            'max_price_level': maxPriceLevel,
          }),
        )
        .timeout(_timeout);

      if (res.statusCode != 200) {
        _error = _parseError(res);
        _isGenerating = false;
        notifyListeners();
        return null;
      }
      
      _isGenerating = false;
      notifyListeners();
      return jsonDecode(utf8.decode(res.bodyBytes));
    } catch (e) {
      _error = 'Gagal menghubungi AI. Pastikan koneksi stabil.';
      _isGenerating = false;
      notifyListeners();
      return null;
    }
  }

  // ── Recommendation ───────────────────────────────────────────────────

  Future<Map<String, dynamic>> getRecommendations({
    required String placeName,
    int topN = 10,
    double alpha = 0.8,
  }) async {
    final uri = Uri.parse('$recoUrl/recommendations/').replace(
      queryParameters: {
        'place_name': placeName,
        'top_n': '$topN',
        'alpha': '$alpha',
      },
    );
    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) {
      throw ApiException(res.statusCode, _parseError(res));
    }
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  Future<List<dynamic>> getFeatured({int limit = 10}) async {
    final uri = Uri.parse('$recoUrl/recommendations/featured')
        .replace(queryParameters: {'limit': '$limit'});
    final res = await http.get(uri).timeout(_timeout);
    final data = jsonDecode(utf8.decode(res.bodyBytes));
    return data['results'] as List<dynamic>;
  }

  Future<List<String>> searchPlaces({
    required String query,
    int limit = 10,
  }) async {
    final uri = Uri.parse('$recoUrl/recommendations/search').replace(
      queryParameters: {'query': query, 'limit': '$limit'},
    );
    final res = await http.get(uri).timeout(_timeout);
    final data = jsonDecode(utf8.decode(res.bodyBytes));
    return List<String>.from(data['results']);
  }

  Future<Map<String, dynamic>> getPlaceDetail(String placeName) async {
    final uri = Uri.parse('$recoUrl/recommendations/detail')
        .replace(queryParameters: {'place_name': placeName});
    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) {
      throw ApiException(res.statusCode, _parseError(res));
    }
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  // ── Helper ────────────────────────────────────────────────────────────

  static String _parseError(http.Response res) {
    try {
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      return body['detail']?.toString() ?? res.reasonPhrase ?? 'Unknown error';
    } catch (_) {
      return res.reasonPhrase ?? 'Unknown error';
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
