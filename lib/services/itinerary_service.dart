import 'package:flutter/foundation.dart';
import 'package:tanjung_pinang_guide/core/constants/api_constants.dart';
import 'package:tanjung_pinang_guide/core/network/api_client.dart';
import 'package:tanjung_pinang_guide/models/itinerary_model.dart';

class ItineraryService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  bool _isGenerating = false;
  String? _error;
  List<ItineraryModel> _itineraries = [];

  bool get isGenerating => _isGenerating;
  String? get error => _error;
  List<ItineraryModel> get itineraries => _itineraries;

  Future<ItineraryModel?> generateItinerary({
    int? userId,
    int days = 1,
    int people = 1,
    String budgetType = 'hemat',
    List<String> interests = const ['Semua Kategori'],
    String notes = '',
  }) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.post(
        ApiConstants.generateItinerary,
        body: {
          if (userId != null) 'userId': userId,
          'days': days,
          'people': people,
          'budgetType': budgetType.toLowerCase() == 'sedang'
              ? 'menengah'
              : budgetType.toLowerCase() == 'mewah'
                  ? 'premium'
                  : budgetType.toLowerCase(),
          'interests': interests.isEmpty ? ['Semua Kategori'] : interests,
          'notes': notes,
        },
        withAuth: userId != null,
      );

      if (response['success'] == true) {
        final itinerary = ItineraryModel.fromJson(response['data']);
        if (userId != null) {
          _itineraries.insert(0, itinerary);
        }
        _isGenerating = false;
        notifyListeners();
        return itinerary;
      } else {
        _error = response['message'] ?? 'Gagal membuat itinerary';
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isGenerating = false;
    notifyListeners();
    return null;
  }

  Future<void> fetchUserItineraries(int userId) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get(ApiConstants.userItineraries(userId), withAuth: true);
      if (response['success'] == true) {
        final List data = response['data'];
        _itineraries = data.map((json) => ItineraryModel.fromJson(json)).toList();
      } else {
        _error = response['message'];
      }
    } catch (e) {
      _error = 'Gagal mengambil riwayat itinerary';
    }

    _isGenerating = false;
    notifyListeners();
  }

  Future<bool> deleteItinerary(int id) async {
    try {
      final response = await _apiClient.delete(ApiConstants.itineraryById(id), withAuth: true);
      if (response['success'] == true) {
        _itineraries.removeWhere((i) => i.id == id);
        notifyListeners();
        return true;
      }
    } catch (_) {}
    return false;
  }
}

