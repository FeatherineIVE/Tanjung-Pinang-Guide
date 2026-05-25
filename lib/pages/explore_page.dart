import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../data/destination_data.dart';
import '../services/destination_service.dart';
import '../models/destination_model.dart';
import 'explore_detail_page.dart';

class ExplorePage extends StatefulWidget {
  final DestinationCategory initialCategory;

  const ExplorePage({
    super.key,
    this.initialCategory = DestinationCategory.semua,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late DestinationCategory _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _searchController.addListener(
        () => setState(() => _searchQuery = _searchController.text.toLowerCase()));
    // Fetch dari backend jika belum ada data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final svc = context.read<DestinationService>();
      if (svc.destinations.isEmpty) {
        svc.fetchAll();
      }
    });
  }

  // ── Saat initialCategory berubah (user tap kategori di home) ──────────────
  @override
  void didUpdateWidget(covariant ExplorePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      setState(() => _selectedCategory = widget.initialCategory);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  List<DestinationModel> _filteredApi(List<DestinationModel> all) {
    return all.where((d) {
      // Cocokkan kategori: frontend pakai 'pantai', backend pakai 'Wisata Pantai'
      final matchCat = _selectedCategory == DestinationCategory.semua ||
          d.kategori.toLowerCase().contains(_selectedCategory.label.toLowerCase());
      final matchSearch = _searchQuery.isEmpty ||
          d.nama.toLowerCase().contains(_searchQuery) ||
          (d.deskripsi?.toLowerCase().contains(_searchQuery) ?? false) ||
          (d.lokasi?.toLowerCase().contains(_searchQuery) ?? false);
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<DestinationService>();
    // Selalu pakai data API — tidak ada fallback ke dummy
    final apiResults = _filteredApi(svc.destinations);
    final totalResults = apiResults.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => svc.fetchAll(),
        color: AppColors.primaryBlue,
        child: Column(
        children: [
          // ── Header Biru (fixed) ──────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(gradient: AppColors.headerGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        if (Navigator.canPop(context))
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 16),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Jelajahi Destinasi',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                _selectedCategory == DestinationCategory.semua
                                    ? 'Temukan tempat impianmu'
                                    : 'Jelajahi ${_selectedCategory.label.toLowerCase()}',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Search bar
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(Icons.search_rounded,
                              color: AppColors.grey, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Cari destinasi...',
                                hintStyle: TextStyle(
                                    color: AppColors.textHint, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.close_rounded,
                                    color: AppColors.grey, size: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Category Filter (fixed, selalu terlihat) ─────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  DestinationCategory.semua,
                  DestinationCategory.sejarah,
                  DestinationCategory.pantai,
                  DestinationCategory.alam,
                  DestinationCategory.kuliner,
                ].map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected ? AppColors.buttonGradient : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.greyBorder,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: AppColors.primaryBlue
                                        .withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2))
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat.icon,
                              size: 14,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textGrey),
                          const SizedBox(width: 6),
                          Text(cat.label,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textGrey)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Divider tipis
          Container(height: 1, color: AppColors.greyBorder),

          // ── Jumlah hasil ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text('$totalResults destinasi ditemukan',
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w500)),
                if (svc.isLoading) ...[
                  const SizedBox(width: 10),
                  const SizedBox(
                    width: 14, height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── List Destinasi (scrollable) ───────────────────────────────────
          Expanded(
            child: svc.isLoading && svc.destinations.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Memuat destinasi...'),
                      ],
                    ),
                  )
                : (totalResults == 0 && !svc.isLoading)
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.search_off_rounded,
                                  size: 40, color: AppColors.primaryBlue),
                            ),
                            const SizedBox(height: 16),
                            const Text('Destinasi tidak ditemukan',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark)),
                            const SizedBox(height: 6),
                            Text('Coba kata kunci lain',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[500])),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: apiResults.length,
                        itemBuilder: (context, index) {
                          final dest = apiResults[index];
                          return _DestinationListCardApi(
                            destination: dest,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ExploreDetailPage(destinationModel: dest),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
        ), // Column
      ), // RefreshIndicator
    );
  }
}

// ── Destination Card dari API ─────────────────────────────────────────────────────────────────
class _DestinationListCardApi extends StatelessWidget {
  final DestinationModel destination;
  final VoidCallback onTap;
  const _DestinationListCardApi({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dest = destination;
    final isGratis = dest.hargaTiket?.toLowerCase().contains('gratis') ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    dest.displayImagePath,
                    height: 170, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 170,
                      color: dest.categoryColor.withOpacity(0.15),
                      child: Center(child: Icon(Icons.image_not_supported_rounded, color: dest.categoryColor, size: 48)),
                    ),
                  ),
                ),
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: dest.categoryColor, borderRadius: BorderRadius.circular(20)),
                    child: Text(dest.kategori,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isGratis ? const Color(0xFF66BB6A) : const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(isGratis ? 'Gratis' : (dest.hargaTiket ?? ''),
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dest.nama,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_rounded, size: 13, color: AppColors.primaryBlue),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(dest.lokasi ?? '',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(dest.deskripsi ?? '',
                      style: const TextStyle(fontSize: 13, color: AppColors.textGrey, height: 1.4),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(children: [
                    _MiniChip(icon: Icons.star_rounded, label: dest.ratingFormatted, color: const Color(0xFFFFB300)),
                    const SizedBox(width: 6),
                    _MiniChip(icon: Icons.access_time_rounded, label: dest.jamBuka ?? '-', color: const Color(0xFF66BB6A)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(gradient: AppColors.buttonGradient, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Lihat Detail',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Destination List Card (Lokal) ──────────────────────────────────────────────────────
class _DestinationListCard extends StatelessWidget {
  final DestinationData destination;
  final VoidCallback onTap;

  const _DestinationListCard(
      {required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dest = destination;
    final isGratis = dest.hargaTiket.toLowerCase().contains('gratis');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gambar ────────────────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: Image.asset(
                    dest.imagePath,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 170,
                      color: dest.bgColor.withOpacity(0.15),
                      child: Center(
                        child: Icon(Icons.image_not_supported_rounded,
                            color: dest.bgColor, size: 48),
                      ),
                    ),
                  ),
                ),
                // Badge kategori
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: dest.bgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(dest.categoryLabel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                // Badge harga
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isGratis
                          ? const Color(0xFF66BB6A)
                          : const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                        isGratis ? 'Gratis' : dest.hargaTiket,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),

            // ── Info ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dest.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 13, color: AppColors.primaryBlue),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(dest.lokasi,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textGrey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(dest.shortDesc,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                          height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _MiniChip(
                          icon: Icons.location_on_rounded,
                          label: dest.distance.split(' ').first,
                          color: AppColors.primaryBlue),
                      const SizedBox(width: 6),
                      _MiniChip(
                          icon: Icons.access_time_rounded,
                          label: dest.jamBuka,
                          color: const Color(0xFF66BB6A)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Lihat Detail',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}