import 'package:flutter/material.dart';

/// Model user sederhana
class UserData {
  final String nama;
  final String email;
  String password;

  UserData({
    required this.nama,
    required this.email,
    required this.password,
  });
}

/// AuthService – mengelola state login dengan dummy data.
/// Digunakan sebagai InheritedWidget agar bisa diakses dari mana saja.
class AuthService extends ChangeNotifier {
  // ── Dummy Users ──────────────────────────────────────────────────────────
  final List<UserData> _registeredUsers = [
    UserData(
      nama: 'Ahmad Rizki',
      email: 'ahmad@gmail.com',
      password: '123456',
    ),
    UserData(
      nama: 'Siti Nurhaliza',
      email: 'siti@gmail.com',
      password: '123456',
    ),
    UserData(
      nama: 'Demo User',
      email: 'demo@demo.com',
      password: 'demo123',
    ),
  ];

  UserData? _currentUser;
  bool _isGuest = false;

  // ── Getters ──────────────────────────────────────────────────────────────
  bool get isLoggedIn => _currentUser != null;
  bool get isGuest => _isGuest;
  UserData? get currentUser => _currentUser;
  String get userName => _currentUser?.nama ?? 'Tamu';
  String get userEmail => _currentUser?.email ?? '';

  // ── Login ────────────────────────────────────────────────────────────────
  /// Mengembalikan `null` jika berhasil, atau pesan error jika gagal.
  String? login(String email, String password) {
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPass = password.trim();

    if (trimmedEmail.isEmpty) return 'Email tidak boleh kosong';
    if (trimmedPass.isEmpty) return 'Password tidak boleh kosong';

    // Cari di daftar user terdaftar
    final user = _registeredUsers.cast<UserData?>().firstWhere(
      (u) => u!.email.toLowerCase() == trimmedEmail && u.password == trimmedPass,
      orElse: () => null,
    );

    if (user == null) return 'Email atau password salah';

    _currentUser = user;
    _isGuest = false;
    notifyListeners();
    return null; // sukses
  }

  // ── Register ─────────────────────────────────────────────────────────────
  /// Mengembalikan `null` jika berhasil, atau pesan error jika gagal.
  String? register(String nama, String email, String password, String confirmPassword) {
    final trimmedNama = nama.trim();
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPass = password.trim();
    final trimmedConfirm = confirmPassword.trim();

    if (trimmedNama.isEmpty) return 'Nama lengkap tidak boleh kosong';
    if (trimmedEmail.isEmpty) return 'Email tidak boleh kosong';
    if (!trimmedEmail.contains('@')) return 'Format email tidak valid';
    if (trimmedPass.isEmpty) return 'Password tidak boleh kosong';
    if (trimmedPass.length < 6) return 'Password minimal 6 karakter';
    if (trimmedPass != trimmedConfirm) return 'Password tidak cocok';

    // Cek apakah email sudah terdaftar
    final exists = _registeredUsers.any(
      (u) => u.email.toLowerCase() == trimmedEmail,
    );
    if (exists) return 'Email sudah terdaftar';

    // Daftarkan user baru
    final newUser = UserData(
      nama: trimmedNama,
      email: trimmedEmail,
      password: trimmedPass,
    );
    _registeredUsers.add(newUser);
    _currentUser = newUser;
    _isGuest = false;
    notifyListeners();
    return null; // sukses
  }

  // ── Guest Login ──────────────────────────────────────────────────────────
  void loginAsGuest() {
    _currentUser = null;
    _isGuest = true;
    notifyListeners();
  }

  // ── Reset Password (Lupa Password) ──────────────────────────────────────
  /// Cari user berdasarkan email, lalu ganti password-nya.
  /// Mengembalikan `null` jika berhasil, atau pesan error jika gagal.
  String? resetPassword(String email, String newPassword, String confirmPassword) {
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPass = newPassword.trim();
    final trimmedConfirm = confirmPassword.trim();

    if (trimmedEmail.isEmpty) return 'Email tidak boleh kosong';
    if (!trimmedEmail.contains('@')) return 'Format email tidak valid';
    if (trimmedPass.isEmpty) return 'Password baru tidak boleh kosong';
    if (trimmedPass.length < 6) return 'Password minimal 6 karakter';
    if (trimmedPass != trimmedConfirm) return 'Password tidak cocok';

    // Cari user berdasarkan email
    final user = _registeredUsers.cast<UserData?>().firstWhere(
      (u) => u!.email.toLowerCase() == trimmedEmail,
      orElse: () => null,
    );

    if (user == null) return 'Email tidak ditemukan';

    // Update password
    user.password = trimmedPass;
    notifyListeners();
    return null; // sukses
  }

  // ── Change Password (Ubah Password dari Profil) ─────────────────────────
  /// User yang sudah login mengubah password-nya.
  /// Mengembalikan `null` jika berhasil, atau pesan error jika gagal.
  String? changePassword(String oldPassword, String newPassword, String confirmPassword) {
    if (_currentUser == null) return 'Anda belum login';

    final trimmedOld = oldPassword.trim();
    final trimmedNew = newPassword.trim();
    final trimmedConfirm = confirmPassword.trim();

    if (trimmedOld.isEmpty) return 'Password lama tidak boleh kosong';
    if (trimmedNew.isEmpty) return 'Password baru tidak boleh kosong';
    if (trimmedNew.length < 6) return 'Password baru minimal 6 karakter';
    if (trimmedNew != trimmedConfirm) return 'Password baru tidak cocok';
    if (trimmedOld != _currentUser!.password) return 'Password lama salah';
    if (trimmedOld == trimmedNew) return 'Password baru tidak boleh sama dengan yang lama';

    // Update password
    _currentUser!.password = trimmedNew;
    notifyListeners();
    return null; // sukses
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  void logout() {
    _currentUser = null;
    _isGuest = false;
    notifyListeners();
  }
}

/// InheritedWidget wrapper agar AuthService bisa diakses via
/// `AuthProvider.of(context)` dari mana saja di widget tree.
class AuthProvider extends InheritedNotifier<AuthService> {
  const AuthProvider({
    super.key,
    required AuthService auth,
    required super.child,
  }) : super(notifier: auth);

  static AuthService of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    assert(provider != null, 'AuthProvider not found in widget tree');
    return provider!.notifier!;
  }
}
