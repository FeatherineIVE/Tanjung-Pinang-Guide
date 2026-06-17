import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/destination_model.dart';

/// Service untuk mengambil data destinasi dari backend API.
class DestinationService extends ChangeNotifier {
  final ApiClient _api;

  List<DestinationModel> _destinations = [];
  bool _isLoading = false;
  String? _error;

  DestinationService({ApiClient? api}) : _api = api ?? ApiClient();

  // ── Getters ───────────────────────────────────────────────────────────────
  List<DestinationModel> get destinations => _destinations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── Get All ───────────────────────────────────────────────────────────────
  /// Ambil semua destinasi, opsional filter berdasarkan kategori.
  /// kategori: 'pantai' | 'sejarah' | 'alam' | 'kuliner' | null (semua)
  Future<void> fetchAll({String? kategori}) async {
    _setLoading(true);
    _error = null;
    try {
      final res = await _api.get(
        ApiConstants.destinations,
        queryParams: kategori != null ? {'kategori': kategori} : null,
      );
      final List<dynamic> list = res['data'] as List<dynamic>? ?? [];
      _destinations = list
          .map((e) => DestinationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Gagal memuat destinasi. Periksa koneksi internet.';
    }
    _setLoading(false);
  }

  // ── Get By ID ─────────────────────────────────────────────────────────────
  Future<DestinationModel?> getById(int id) async {
    try {
      final res = await _api.get(ApiConstants.destinationById(id));
      return DestinationModel.fromJson(res['data'] as Map<String, dynamic>);
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    } catch (_) {
      _error = 'Gagal memuat detail destinasi.';
      notifyListeners();
      return null;
    }
  }

  // ── Increment Visit ───────────────────────────────────────────────────────
  Future<void> incrementVisit(int id) async {
    try {
      await _api.patch(ApiConstants.destinationVisit(id));
    } catch (_) {
      // Abaikan jika gagal increment
    }
  }

  // ── Get By Slug ───────────────────────────────────────────────────────────
  Future<DestinationModel?> getBySlug(String slug) async {
    try {
      final res = await _api.get(ApiConstants.destinationBySlug(slug));
      return DestinationModel.fromJson(res['data'] as Map<String, dynamic>);
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    } catch (_) {
      _error = 'Gagal memuat destinasi.';
      notifyListeners();
      return null;
    }
  }

  // ── Filter Lokal ──────────────────────────────────────────────────────────
  List<DestinationModel> filterByKategori(String? kategori) {
    if (kategori == null || kategori.isEmpty || kategori == 'semua') {
      return _destinations;
    }
    return _destinations
        .where((d) => d.kategori.toLowerCase() == kategori.toLowerCase())
        .toList();
  }

  // ── Cari ─────────────────────────────────────────────────────────────────
  List<DestinationModel> search(String query) {
    if (query.isEmpty) return _destinations;
    final q = query.toLowerCase();
    return _destinations.where((d) {
      return d.nama.toLowerCase().contains(q) ||
          (d.deskripsi?.toLowerCase().contains(q) ?? false) ||
          (d.lokasi?.toLowerCase().contains(q) ?? false) ||
          d.kategori.toLowerCase().contains(q);
    }).toList();
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
