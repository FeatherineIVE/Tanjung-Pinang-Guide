import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';

/// Service AI chat yang terhubung ke backend (POST /api/chat).
/// Backend meneruskan pesan ke Gemini Pro dan mengembalikan reply.
class ChatService extends ChangeNotifier {
  final ApiClient _api;

  bool _isLoading = false;
  String? _error;

  ChatService({ApiClient? api}) : _api = api ?? ApiClient();

  // ── Getters ───────────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  String? get error  => _error;

  // ── Send Message ──────────────────────────────────────────────────────────
  /// Mengirim pesan ke AI guide dan mengembalikan reply.
  /// Mengembalikan null jika gagal (error tersimpan di [error]).
  Future<String?> sendMessage(String message) async {
    if (message.trim().isEmpty) return null;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _api.post(
        ApiConstants.chat,
        body: {'message': message.trim()},
      );
      _isLoading = false;
      notifyListeners();
      final data = res['data'] as Map<String, dynamic>?;
      return data?['reply'] as String? ?? 'Maaf, saya tidak dapat menjawab saat ini.';
    } on ApiException catch (e) {
      _isLoading = false;
      _error = e.message;
      notifyListeners();
      return null;
    } catch (_) {
      _isLoading = false;
      _error = 'Gagal menghubungi AI. Periksa koneksi internet.';
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }
}
