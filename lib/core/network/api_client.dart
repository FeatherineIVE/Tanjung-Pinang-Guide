import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'token_storage.dart';

/// Exception terstruktur dari API backend.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// HTTP client terpusat untuk seluruh request ke backend.
/// - Auto-inject Authorization header dari TokenStorage
/// - Refresh access token otomatis jika expired (401)
/// - Parse response JSON secara konsisten
/// - Panggil [onSessionExpired] jika refresh token juga gagal (auto-logout)
class ApiClient {
  final http.Client _http;

  /// Dipanggil oleh [AuthService] untuk handle auto-logout ketika sesi benar-benar expired
  Future<void> Function()? onSessionExpired;

  ApiClient({http.Client? client}) : _http = client ?? http.Client();

  // ── Headers ────────────────────────────────────────────────────────────────
  Future<Map<String, String>> _buildHeaders({bool withAuth = false}) async {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader:      'application/json',
    };
    if (withAuth) {
      final token = await TokenStorage.getAccessToken();
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }
    }
    return headers;
  }

  // ── Response Handler ───────────────────────────────────────────────────────
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    final msg = body['message'] as String? ?? 'Terjadi kesalahan';
    throw ApiException(response.statusCode, msg);
  }

  // ── Auto Refresh ───────────────────────────────────────────────────────────
  /// Jika response 401, coba refresh token lalu ulangi request
  Future<http.Response> _requestWithRefresh({
    required Future<http.Response> Function(Map<String, String> headers) requestFn,
  }) async {
    var headers = await _buildHeaders(withAuth: true);
    var response = await requestFn(headers);

    if (response.statusCode == 401) {
      // Coba refresh
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final refreshHeaders = await _buildHeaders();
          final refreshRes = await _http.post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.refresh}'),
            headers: refreshHeaders,
            body: json.encode({'refreshToken': refreshToken}),
          );
          if (refreshRes.statusCode == 200) {
            final refreshBody = json.decode(utf8.decode(refreshRes.bodyBytes));
            final newToken = refreshBody['data']['token'] as String;
            await TokenStorage.saveAccessToken(newToken);
            // Ulangi request asli dengan token baru
            headers = await _buildHeaders(withAuth: true);
            response = await requestFn(headers);
          } else {
            // Refresh juga gagal — sesi benar-benar expired, trigger auto-logout
            await TokenStorage.clearAll();
            onSessionExpired?.call();
          }
        } catch (_) {
          // Error jaringan saat refresh — biarkan 401 melewati
        }
      } else {
        // Tidak ada refresh token — sesi tidak valid
        onSessionExpired?.call();
      }
    }
    return response;
  }

  // ── GET ────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParams,
    bool withAuth = false,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path')
        .replace(queryParameters: queryParams);

    final response = await _requestWithRefresh(
      requestFn: (headers) => _http.get(uri, headers: headers),
    );
    return _handleResponse(response);
  }

  // ── POST ───────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = false,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final response = await _requestWithRefresh(
      requestFn: (headers) => _http.post(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      ),
    );
    return _handleResponse(response);
  }

  // ── PUT ────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final response = await _requestWithRefresh(
      requestFn: (headers) => _http.put(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      ),
    );
    return _handleResponse(response);
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> delete(
    String path, {
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final response = await _requestWithRefresh(
      requestFn: (headers) => _http.delete(uri, headers: headers),
    );
    return _handleResponse(response);
  }

  void dispose() => _http.close();
}
