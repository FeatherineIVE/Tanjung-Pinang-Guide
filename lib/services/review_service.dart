import 'package:flutter/foundation.dart';
import 'package:tanjung_pinang_guide/core/constants/api_constants.dart';
import 'package:tanjung_pinang_guide/core/network/api_client.dart';
import 'package:tanjung_pinang_guide/models/review_model.dart';

class ReviewService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  final Map<int, List<ReviewModel>> _reviewsByDest = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<ReviewModel> reviewsFor(int destinationId) {
    return _reviewsByDest[destinationId] ?? [];
  }

  Future<void> fetchReviews(int destinationId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiClient.get(ApiConstants.reviewsByDestination(destinationId));
      if (response['success'] == true) {
        final List data = response['data'];
        _reviewsByDest[destinationId] = data.map((json) => ReviewModel.fromJson(json)).toList();
      }
    } catch (_) { }
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> submitReview({
    required int destinationId,
    required double rating,
    required String komentar,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.reviews,
        body: {
          'destinationId': destinationId,
          'rating': rating,
          'comment': komentar, // pastikan key-nya 'comment' atau 'komentar' sesuai backend
        },
        withAuth: true,
      );
      if (response['success'] == true) {
        await fetchReviews(destinationId);
        return null; // success
      }
      return response['message']?.toString();
    } catch (e) {
      return 'Gagal mengirim ulasan';
    }
  }
}

