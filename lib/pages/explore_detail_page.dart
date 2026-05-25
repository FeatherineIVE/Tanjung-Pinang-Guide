import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';
import '../data/destination_data.dart';
import '../services/auth_service.dart';
import '../services/bookmark_service.dart';
import '../services/destination_service.dart';
import '../services/rating_service.dart';
import '../models/destination_model.dart';
import '../models/rating_model.dart';
import '../widgets/login_required_sheet.dart';

class ExploreDetailPage extends StatefulWidget {
  // Model lama (dari data dummy lokal)
  final DestinationData? destination;
  // Model baru (dari API backend)
  final DestinationModel? destinationModel;

  const ExploreDetailPage({
    super.key,
    this.destination,
    this.destinationModel,
  }) : assert(destination != null || destinationModel != null,
            'Harus menyediakan destination atau destinationModel');

  @override
  State<ExploreDetailPage> createState() => _ExploreDetailPageState();
}

class _ExploreDetailPageState extends State<ExploreDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Model yang di-resolve dari backend. Null jika belum/gagal fetch.
  /// Digunakan untuk fitur bookmark & rating pada destinasi yang dibuka
  /// dari data lokal (DestinationData) — secara otomatis di-fetch by slug.
  DestinationModel? _resolvedModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('[FAV-DEBUG] initState: destinationModel=${widget.destinationModel?.nama}, destination=${widget.destination?.title}');
      if (widget.destinationModel != null) {
        // Sudah ada model dari backend — gunakan langsung
        _resolvedModel = widget.destinationModel;
        debugPrint('[FAV-DEBUG] Langsung pakai destinationModel id=${widget.destinationModel!.id}');
        // Fetch ratings
        context.read<RatingService>().fetchByDestination(widget.destinationModel!.id);
      } else if (widget.destination != null) {
        // Data dari dummy lokal — resolve ke backend
        debugPrint('[FAV-DEBUG] Resolve dari dummy: title=${widget.destination!.title}');
        _resolveDestinationModel(widget.destination!.title);
      } else {
        debugPrint('[FAV-DEBUG] PERINGATAN: Tidak ada destinationModel maupun destination!');
      }
    });
  }

  /// Resolve DestinationModel dari backend untuk destinasi dummy.
  /// Strategi:
  ///   1. Cari di cache _destinations yang sudah di-fetch (by nama)
  ///   2. Jika tidak ada di cache, fetch semua dulu lalu cari
  ///   3. Fallback ke API by slug
  Future<void> _resolveDestinationModel(String title) async {
    final destService = context.read<DestinationService>();
    debugPrint('[FAV-DEBUG] Resolve title="$title", cache size=${destService.destinations.length}');

    // Strategi 1: Cari dari cache yang sudah ada
    DestinationModel? found = _findInCache(destService, title);
    debugPrint('[FAV-DEBUG] Strategi 1 (cache): ${found?.nama ?? "TIDAK DITEMUKAN"}');

    if (found == null) {
      // Strategi 2: Fetch semua dari backend, lalu cari
      debugPrint('[FAV-DEBUG] Strategi 2: fetchAll()');
      await destService.fetchAll();
      debugPrint('[FAV-DEBUG] fetchAll selesai, cache size=${destService.destinations.length}');
      debugPrint('[FAV-DEBUG] Nama di cache: ${destService.destinations.map((d) => d.nama).join(', ')}');
      found = _findInCache(destService, title);
      debugPrint('[FAV-DEBUG] Strategi 2 (setelah fetch): ${found?.nama ?? "TIDAK DITEMUKAN"}');
    }

    if (found == null) {
      // Strategi 3: Fallback ke API by slug
      final slug = _toSlug(title);
      debugPrint('[FAV-DEBUG] Strategi 3: getBySlug("$slug")');
      found = await destService.getBySlug(slug);
      debugPrint('[FAV-DEBUG] Strategi 3 hasil: ${found?.nama ?? "TIDAK DITEMUKAN"}');
    }

    if (found != null && mounted) {
      debugPrint('[FAV-DEBUG] BERHASIL resolve: id=${found.id} nama=${found.nama}');
      setState(() => _resolvedModel = found);
      context.read<RatingService>().fetchByDestination(found.id);
    } else {
      debugPrint('[FAV-DEBUG] GAGAL resolve semua strategi untuk title="$title"');
    }
  }

  /// Cari destinasi dari cache berdasarkan nama (toleran terhadap perbedaan kapital/spasi).
  DestinationModel? _findInCache(DestinationService service, String title) {
    final normalizedTitle = title.toLowerCase().trim();
    try {
      return service.destinations.firstWhere(
        (d) => d.nama.toLowerCase().trim() == normalizedTitle ||
               d.nama.toLowerCase().trim().contains(normalizedTitle) ||
               normalizedTitle.contains(d.nama.toLowerCase().trim()),
      );
    } catch (_) {
      return null;
    }
  }

  /// Konversi judul ke slug (lowercase, spasi jadi strip).
  String _toSlug(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9\s-]"), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper untuk akses data dari model manapun
  String get _title => widget.destinationModel?.nama ?? widget.destination?.title ?? '';
  String get _kategori => widget.destinationModel?.kategori ?? widget.destination?.categoryLabel ?? '';
  String get _deskripsi => widget.destinationModel?.deskripsi ?? widget.destination?.description ?? '';
  String get _lokasi => widget.destinationModel?.lokasi ?? widget.destination?.lokasi ?? '';
  String get _jamBuka => widget.destinationModel?.jamBuka ?? widget.destination?.jamBuka ?? '';
  String get _hargaTiket => widget.destinationModel?.hargaTiket ?? widget.destination?.hargaTiket ?? '';
  String get _imagePath => widget.destinationModel?.displayImagePath ?? widget.destination?.imagePath ?? 'assets/images/onboarding1.jpg';
  Color get _bgColor => widget.destinationModel?.categoryColor ?? widget.destination?.bgColor ?? AppColors.primaryBlue;
  double? get _mapsLat => widget.destinationModel?.mapsLat ?? widget.destination?.mapsLat;
  double? get _mapsLng => widget.destinationModel?.mapsLng ?? widget.destination?.mapsLng;

  Future<void> _openMaps() async {
    final lat   = _mapsLat;
    final lng   = _mapsLng;
    if (lat == null || lng == null) return;
    final label = Uri.encodeComponent(_title);
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng($label)');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final bm   = context.watch<BookmarkService>();

    // Model aktif: widget.destinationModel (dari luar) atau _resolvedModel (dari fetch)
    final activeModel = widget.destinationModel ?? _resolvedModel;
    // Tentukan status bookmark berdasarkan model aktif
    final destId = activeModel?.id;
    final isFav  = destId != null ? bm.isBookmarked(destId) : false;

    void handleFavoritePress() {
      debugPrint('[FAV-DEBUG] handleFavoritePress: isLoggedIn=${auth.isLoggedIn}, activeModel=${activeModel?.nama ?? "NULL"}, widgetModel=${widget.destinationModel?.nama ?? "NULL"}, resolvedModel=${_resolvedModel?.nama ?? "NULL"}');
      if (!auth.isLoggedIn) {
        LoginRequiredSheet.show(context);
        return;
      }
      if (activeModel != null) {
        // Punya model backend — bisa bookmark
        bm.toggle(activeModel);
      } else {
        // Belum resolve ke backend (tidak ditemukan / offline)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Destinasi ini belum tersedia di database, coba beberapa saat lagi'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // ── Hero App Bar ───────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                backgroundColor: AppColors.primaryBlue,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  // Favorit Button
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : Colors.white,
                          size: 20,
                        ),
                        onPressed: handleFavoritePress,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: const Icon(Icons.share_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: _bgColor.withOpacity(0.3),
                          child: Icon(Icons.image_not_supported_rounded,
                              color: _bgColor, size: 80),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _bgColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(_kategori,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(height: 6),
                            Text(_title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black54,
                                          blurRadius: 4)
                                    ])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Info Chips ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.cardBackground,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      _InfoChip(
                          icon: Icons.location_on_rounded,
                          label: _lokasi.split(',').first,
                          color: AppColors.primaryBlue),
                      const SizedBox(width: 8),
                      _InfoChip(
                          icon: Icons.access_time_rounded,
                          label: _jamBuka,
                          color: const Color(0xFF66BB6A)),
                      const SizedBox(width: 8),
                      _InfoChip(
                          icon: Icons.confirmation_number_rounded,
                          label: _hargaTiket,
                          color: const Color(0xFFFFB300)),
                    ],
                  ),
                ),
              ),

              // ── Tab Bar ──────────────────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primaryBlue,
                    unselectedLabelColor: AppColors.textGrey,
                    indicatorColor: AppColors.primaryBlue,
                    indicatorWeight: 3,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Info'),
                      Tab(text: 'Tips'),
                      Tab(text: 'Sekitar'),
                      Tab(text: 'Ulasan'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _InfoTab(
                  deskripsi: _deskripsi,
                  lokasi: _lokasi,
                  jamBuka: _jamBuka,
                  hargaTiket: _hargaTiket,
                  tags: widget.destination?.tags ?? [],
                ),
                _TipsTab(tips: widget.destination?.tips ?? []),
                _SekitarTab(nearby: widget.destination?.nearby ?? []),
                _UlasanTab(
                  destinationId: (widget.destinationModel ?? _resolvedModel)?.id,
                ),
              ],
            ),
          ),

          // ── Bottom Bar ────────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _openMaps,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.near_me_rounded,
                            color: Colors.white, size: 18),
                        label: const Text('Petunjuk Arah',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Favorit (sama fungsi dengan tombol di AppBar)
                  GestureDetector(
                    onTap: handleFavoritePress,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isFav ? Colors.red.shade50 : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: isFav ? Colors.red.shade200 : Colors.grey.shade300,
                            width: 1.5),
                      ),
                      child: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? Colors.red : Colors.red.shade400,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab: Info ─────────────────────────────────────────────────────────────────
class _InfoTab extends StatelessWidget {
  final DestinationData? dest;
  final String deskripsi;
  final String lokasi;
  final String jamBuka;
  final String hargaTiket;
  final List<String> tags;

  const _InfoTab({
    this.dest,
    this.deskripsi = '',
    this.lokasi = '',
    this.jamBuka = '',
    this.hargaTiket = '',
    this.tags = const [],
  });

  @override
  Widget build(BuildContext context) {
    final descText = deskripsi.isNotEmpty ? deskripsi : (dest?.description ?? '');
    final lokasiText = lokasi.isNotEmpty ? lokasi : (dest?.lokasi ?? '');
    final jamText = jamBuka.isNotEmpty ? jamBuka : (dest?.jamBuka ?? '');
    final hargaText = hargaTiket.isNotEmpty ? hargaTiket : (dest?.hargaTiket ?? '');
    final tagsData = tags.isNotEmpty ? tags : (dest?.tags ?? []);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tentang Destinasi',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark)),
          const SizedBox(height: 10),
          Text(descText,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textGrey, height: 1.6)),
          const SizedBox(height: 20),
          _DetailRow(icon: Icons.location_on_rounded, label: 'Lokasi', value: lokasiText),
          const SizedBox(height: 12),
          _DetailRow(icon: Icons.access_time_rounded, label: 'Jam Buka', value: jamText),
          const SizedBox(height: 12),
          _DetailRow(icon: Icons.confirmation_number_rounded, label: 'Harga Tiket', value: hargaText),
          const SizedBox(height: 20),
          const Text('Tag',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tagsData.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                  ),
                  child: Text(tag, style: const TextStyle(fontSize: 12, color: AppColors.primaryBlue, fontWeight: FontWeight.w500)),
                )).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Tab: Tips ─────────────────────────────────────────────────────────────────
class _TipsTab extends StatelessWidget {
  final DestinationData? dest;
  final List<String> tips;
  const _TipsTab({this.dest, this.tips = const []});

  @override
  Widget build(BuildContext context) {
    final tipsList = tips.isNotEmpty ? tips : (dest?.tips ?? []);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tips Berkunjung',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 14),
          ...tipsList.map((tip) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFE082), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFB300), size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(tip, style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4))),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.25)),
            ),
            child: const Row(
              children: [
                Icon(Icons.smart_toy_rounded, color: AppColors.primaryBlue, size: 20),
                SizedBox(width: 10),
                Expanded(child: Text('Tanya AI Guide untuk tips lebih lengkap', style: TextStyle(fontSize: 13, color: AppColors.primaryBlue, fontWeight: FontWeight.w500))),
                Icon(Icons.chevron_right_rounded, color: AppColors.primaryBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab: Sekitar ──────────────────────────────────────────────────────────────
class _SekitarTab extends StatelessWidget {
  final DestinationData? dest;
  final List<NearbyDestination> nearby;
  const _SekitarTab({this.dest, this.nearby = const []});

  @override
  Widget build(BuildContext context) {
    final nearbyList = nearby.isNotEmpty ? nearby : (dest?.nearby ?? []);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Destinasi Terdekat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 14),
          if (nearbyList.isEmpty)
            Center(child: Text('Tidak ada destinasi terdekat', style: TextStyle(color: Colors.grey[500])))
          else
          ...nearbyList.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(item.imagePath, width: 60, height: 60, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: AppColors.primaryBlue.withOpacity(0.1),
                              child: const Icon(Icons.image_not_supported_rounded, color: AppColors.primaryBlue, size: 24))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                          const SizedBox(height: 3),
                          Row(children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 13),
                            const SizedBox(width: 3),
                            Text(item.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            const SizedBox(width: 6),
                            Text('• ${item.distance}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                          ]),
                          const SizedBox(height: 3),
                          Text(item.description, style: const TextStyle(fontSize: 11, color: AppColors.textGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.grey),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Tab: Ulasan ─────────────────────────────────────────────────────────────────
class _UlasanTab extends StatefulWidget {
  final int? destinationId;
  const _UlasanTab({this.destinationId});

  @override
  State<_UlasanTab> createState() => _UlasanTabState();
}

class _UlasanTabState extends State<_UlasanTab> {
  final _commentCtrl = TextEditingController();
  double _selectedRating = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitRating(BuildContext context) async {
    final auth = context.read<AuthService>();
    if (!auth.isLoggedIn) {
      LoginRequiredSheet.show(context);
      return;
    }
    if (widget.destinationId == null) return;
    if (_commentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tulis komentar terlebih dahulu'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _submitting = true);
    final ratingService = context.read<RatingService>();
    final err = await ratingService.submitRating(
      destinationId: widget.destinationId!,
      rating: _selectedRating,
      komentar: _commentCtrl.text.trim(),
    );
    setState(() => _submitting = false);

    if (!context.mounted) return;
    if (err == null) {
      _commentCtrl.clear();
      setState(() => _selectedRating = 5);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ulasan berhasil dikirim ✨'), backgroundColor: Color(0xFF66BB6A)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final ratingService = context.watch<RatingService>();
    final ratings = widget.destinationId != null
        ? ratingService.ratingsFor(widget.destinationId!)
        : <RatingModel>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ringkasan Rating ─────────────────────────────────────
          if (ratings.isNotEmpty) ...[  
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFFB300).withOpacity(0.1), const Color(0xFFFFE082).withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        (ratings.map((r) => r.rating).reduce((a, b) => a + b) / ratings.length).toStringAsFixed(1),
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFFFFB300)),
                      ),
                      Row(
                        children: List.generate(5, (i) => Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: i < ((ratings.map((r) => r.rating).reduce((a, b) => a + b) / ratings.length).round())
                              ? const Color(0xFFFFB300)
                              : Colors.grey.shade300,
                        )),
                      ),
                      const SizedBox(height: 4),
                      Text('${ratings.length} ulasan', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text('Berdasarkan ulasan pengunjung yang telah berkunjung ke destinasi ini.',
                        style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Form Tulis Ulasan ───────────────────────────────────
          if (widget.destinationId != null) ...[  
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auth.isLoggedIn ? 'Tulis Ulasan Kamu' : 'Login untuk Menulis Ulasan',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  if (auth.isLoggedIn) ...[  
                    // Bintang rating
                    Row(
                      children: List.generate(5, (i) => GestureDetector(
                        onTap: () => setState(() => _selectedRating = (i + 1).toDouble()),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            i < _selectedRating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: const Color(0xFFFFB300),
                            size: 32,
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(height: 12),
                    // Input komentar
                    TextField(
                      controller: _commentCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Bagikan pengalaman kamu...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textHint),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.greyBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.greyBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : () => _submitRating(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _submitting
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Kirim Ulasan', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ] else ...[  
                    OutlinedButton.icon(
                      onPressed: () => LoginRequiredSheet.show(context),
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const Text('Masuk untuk menulis ulasan'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        side: const BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── List Ulasan ────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Semua Ulasan (${ratings.length})',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              if (ratingService.isLoading)
                const SizedBox(width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue)),
            ],
          ),
          const SizedBox(height: 12),

          if (ratingService.isLoading && ratings.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ))
          else if (ratings.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.rate_review_rounded, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text('Belum ada ulasan', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('Jadilah yang pertama memberikan ulasan!',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                  ],
                ),
              ),
            )
          else
            ...ratings.map((r) => _RatingCard(rating: r)),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  final RatingModel rating;
  const _RatingCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.12),
                child: Text(
                  rating.namaUser.isNotEmpty ? rating.namaUser[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rating.namaUser,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(
                          i < rating.rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 13,
                          color: const Color(0xFFFFB300),
                        )),
                        const SizedBox(width: 4),
                        Text(rating.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(rating.createdAt),
                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
            ],
          ),
          if (rating.komentar.isNotEmpty) ...[  
            const SizedBox(height: 10),
            Text(rating.komentar,
                style: const TextStyle(fontSize: 13, color: AppColors.textGrey, height: 1.4)),
          ],
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays == 0) return 'Hari ini';
      if (diff.inDays == 1) return 'Kemarin';
      if (diff.inDays < 30) return '${diff.inDays} hari lalu';
      if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} bln lalu';
      return '${(diff.inDays / 365).floor()} thn lalu';
    } catch (_) {
      return raw;
    }
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 4),
            Flexible(child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primaryBlue, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            ],
          ),
        ),
      ],
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _StickyTabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Material(color: Colors.white, elevation: overlapsContent ? 2 : 0, child: tabBar);

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate old) => old.tabBar != tabBar;
}