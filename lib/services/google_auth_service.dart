import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/network/token_storage.dart';
import '../models/user_model.dart';

/// Service Google Sign-In menggunakan Firebase Auth sebagai bridge.
///
/// Flow:
///  1. google_sign_in → user pilih akun Google
///  2. Firebase Auth → signInWithCredential → memastikan Google Auth valid
///  3. Ambil googleAuth.idToken (Google OAuth ID Token, bukan Firebase Token)
///  4. Kirim ke POST /api/auth/google → backend verifikasi → return JWT kita
class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<GoogleAuthResult> signIn() async {
    try {
      // Step 1: Pastikan tidak ada sesi aktif
      await _googleSignIn.signOut();
      try { await FirebaseAuth.instance.signOut(); } catch (_) {}

      // Step 2: Tampilkan Google account picker
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        return GoogleAuthResult.error('Login Google dibatalkan');
      }

      // Step 3: Ambil Google OAuth tokens
      final GoogleSignInAuthentication googleAuth;
      try {
        googleAuth = await googleAccount.authentication;
      } catch (e) {
        debugPrint('[GoogleAuth] authentication error: $e');
        return GoogleAuthResult.error(
            'Gagal mengambil token Google. Error: ${e.toString()}');
      }

      final googleIdToken     = googleAuth.idToken;
      final googleAccessToken = googleAuth.accessToken;

      debugPrint('[GoogleAuth] Google idToken: ${googleIdToken != null ? "ADA" : "NULL"}');
      debugPrint('[GoogleAuth] Google accessToken: ${googleAccessToken != null ? "ADA" : "NULL"}');

      // Step 4: Sign in ke Firebase (untuk sinkronisasi Firebase Auth state)
      // Ini TIDAK mengubah token yang dikirim ke backend kita
      if (googleIdToken != null || googleAccessToken != null) {
        try {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAccessToken,
            idToken: googleIdToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
          debugPrint('[GoogleAuth] Firebase sign-in success');
        } catch (e) {
          // Firebase sign-in gagal bukan masalah fatal
          // Kita tetap bisa lanjut dengan Google token
          debugPrint('[GoogleAuth] Firebase sign-in skipped: $e');
        }
      }

      // Step 5: Tentukan token untuk dikirim ke backend kita
      // PENTING: Gunakan Google OAuth ID Token (bukan Firebase ID Token)
      // Google OAuth ID Token = diverifikasi oleh oauth2.googleapis.com/tokeninfo
      // Firebase ID Token     = diverifikasi oleh Firebase Admin SDK (berbeda!)
      final Map<String, dynamic> requestBody = {};
      if (googleIdToken != null) {
        requestBody['idToken'] = googleIdToken;
        debugPrint('[GoogleAuth] Menggunakan Google OAuth idToken ke backend');
      } else if (googleAccessToken != null) {
        requestBody['accessToken'] = googleAccessToken;
        debugPrint('[GoogleAuth] Menggunakan Google accessToken ke backend (fallback)');
      } else {
        return GoogleAuthResult.error(
            'Tidak bisa mendapatkan token dari Google.');
      }

      // Step 6: Kirim ke backend kita
      debugPrint('[GoogleAuth] POST ${ApiConstants.baseUrl}${ApiConstants.googleAuth}');
      final http.Response response;
      try {
        response = await http
            .post(
              Uri.parse('${ApiConstants.baseUrl}${ApiConstants.googleAuth}'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(requestBody),
            )
            .timeout(const Duration(seconds: 20));
      } catch (e) {
        debugPrint('[GoogleAuth] HTTP error: $e');
        return GoogleAuthResult.error(
            'Gagal terhubung ke backend. Pastikan backend berjalan di port 3000.');
      }

      debugPrint('[GoogleAuth] Status: ${response.statusCode}');
      debugPrint('[GoogleAuth] Body: ${response.body}');

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 200) {
        final msg = responseBody['message'] as String? ?? 'Login Google gagal di server';
        return GoogleAuthResult.error(msg);
      }

      // Step 7: Simpan JWT backend ke SharedPreferences
      final data         = responseBody['data'] as Map<String, dynamic>;
      final jwtToken     = data['token'] as String;
      final refreshToken = data['refreshToken'] as String;
      final userData     = data['user'] as Map<String, dynamic>;

      await TokenStorage.saveAccessToken(jwtToken);
      await TokenStorage.saveRefreshToken(refreshToken);
      await TokenStorage.saveUserInfo(
        id:           userData['id'] as int,
        nama:         userData['nama'] as String,
        email:        userData['email'] as String,
        telepon:      userData['telepon'] as String?,
        isGoogleUser: true,
      );

      final user = UserModel(
        id:           userData['id'] as int,
        nama:         userData['nama'] as String,
        email:        userData['email'] as String,
        telepon:      userData['telepon'] as String?,
        isGoogleUser: true,
      );

      debugPrint('[GoogleAuth] ✅ Login berhasil: ${user.email}');
      return GoogleAuthResult.success(user);

    } catch (e, stack) {
      debugPrint('[GoogleAuth] Unhandled error: $e');
      debugPrint('[GoogleAuth] Stack: $stack');

      final errStr = e.toString();
      if (errStr.contains('ApiException: 10') || errStr.contains('DEVELOPER_ERROR')) {
        return GoogleAuthResult.error(
            'Konfigurasi SHA-1 tidak cocok. Pastikan SHA-1 debug sudah ditambahkan di Firebase Console.');
      }
      if (errStr.contains('sign_in_canceled') || errStr.contains('canceled')) {
        return GoogleAuthResult.error('Login Google dibatalkan');
      }
      if (errStr.contains('network_error') || errStr.contains('SocketException')) {
        return GoogleAuthResult.error('Tidak ada koneksi internet');
      }
      return GoogleAuthResult.error(
          'Error: ${errStr.length > 120 ? errStr.substring(0, 120) : errStr}');
    }
  }

  /// Sign out dari Google dan Firebase Auth
  static Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        FirebaseAuth.instance.signOut(),
      ]);
    } catch (e) {
      debugPrint('[GoogleAuth] signOut error: $e');
    }
  }
}

/// Hasil dari Google Sign-In
class GoogleAuthResult {
  final UserModel? user;
  final String? errorMessage;

  GoogleAuthResult.success(this.user) : errorMessage = null;
  GoogleAuthResult.error(this.errorMessage) : user = null;

  bool get isSuccess => user != null;
}
