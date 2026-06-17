import 'package:flutter/material.dart';
import '../widgets/destination_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';
import '../data/destination_data.dart';
import '../models/destination_model.dart';
import '../screens/auth_screen.dart';
import '../services/destination_service.dart';
import '../widgets/login_required_sheet.dart';
import 'explore_detail_page.dart';

class HomePage extends StatefulWidget {
  final void Function(DestinationCategory category) onCategoryTap;

  const HomePage({super.key, required this.onCategoryTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final svc = context.read<DestinationService>();
      if (svc.destinations.isEmpty) {
        svc.fetchAll();
      }
    });
  }

  void _goToAuth(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final destSvc = context.watch<DestinationService>();
    final allDests = destSvc.destinations;
    final popularDestinations = allDests.isNotEmpty
        ? allDests.take(3).toList()
        : <DestinationModel>[];
        
    final recommendedDestinations = allDests.length > 3
        ? allDests.skip(3).take(5).toList()
        : <DestinationModel>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Header ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: AppColors.headerGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/logo_white.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.explore_rounded,
                                        color: Colors.white,
                                        size: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text('TanjungPinang',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          // Tombol Masuk
                          GestureDetector(
                            onTap: () => _goToAuth(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.4)),
                              ),
                              child: const Text('Masuk',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text('Selamat Datang! 👋',
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('Jelajahi\nTanjung Pinang',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              height: 1.2)),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => widget.onCategoryTap(DestinationCategory.semua),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Cari destinasi, kuliner...',
                                hintStyle: const TextStyle(
                                    color: AppColors.textHint, fontSize: 14),
                                prefixIcon: const Icon(Icons.search_rounded,
                                    color: AppColors.grey),
                                suffixIcon: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.tune_rounded,
                                      color: Colors.white, size: 18),
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Kategori Wisata ────────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kategori Wisata',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _CategoryItem(
                            icon: Icons.account_balance_rounded,
                            label: 'Sejarah',
                            color: const Color(0xFFFF7043),
                            onTap: () => widget.onCategoryTap(DestinationCategory.sejarah),
                          ),
                          _CategoryItem(
                            icon: Icons.beach_access_rounded,
                            label: 'Pantai',
                            color: AppColors.primaryBlue,
                            onTap: () => widget.onCategoryTap(DestinationCategory.pantai),
                          ),
                          _CategoryItem(
                            icon: Icons.park_rounded,
                            label: 'Alam',
                            color: const Color(0xFF66BB6A),
                            onTap: () => widget.onCategoryTap(DestinationCategory.alam),
                          ),
                          _CategoryItem(
                            icon: Icons.restaurant_rounded,
                            label: 'Kuliner',
                            color: const Color(0xFFAB47BC),
                            onTap: () => widget.onCategoryTap(DestinationCategory.kuliner),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Login / Daftar Banner ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mulai Perjalananmu!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Daftar gratis & nikmati semua fitur eksklusif',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12)),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: ElevatedButton(
                                    onPressed: () => _goToAuth(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primaryBlue,
                                      elevation: 0,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: const Text('Masuk',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: OutlinedButton(
                                    onPressed: () => _goToAuth(context),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.white, width: 1.5),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: const Text('Daftar Gratis',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('🗺️', style: TextStyle(fontSize: 52)),
                  ],
                ),
              ),
            ),

            // ── AI Guide (preview — tidak interaktif) ─────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.smart_toy_rounded,
                              color: AppColors.primaryBlue, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI Guide',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark)),
                            Text('Tanya apa saja tentang Tanjung Pinang',
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.textGrey)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF66BB6A).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('● Online',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF66BB6A),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '👋 Halo! Saya AI Guide kamu. Mau tanya soal destinasi wisata, kuliner, atau transportasi di Tanjung Pinang?',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textDark,
                            height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SuggestChip(
                          label: '🏖️ Pantai terbaik?',
                          onTap: () => LoginRequiredSheet.show(context),
                        ),
                        _SuggestChip(
                          label: '🍜 Kuliner wajib coba?',
                          onTap: () => LoginRequiredSheet.show(context),
                        ),
                        _SuggestChip(
                          label: '🚢 Cara ke Penyengat?',
                          onTap: () => LoginRequiredSheet.show(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () => _goToAuth(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryBlue,
                                side: const BorderSide(
                                    color: AppColors.primaryBlue, width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Masuk',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: AppColors.buttonGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              onPressed: () => _goToAuth(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Daftar Gratis',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Destinasi Populer ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                children: [
                  _SectionHeader(
                    title: 'Destinasi Populer',
                    onSeeAll: () => widget.onCategoryTap(DestinationCategory.semua),
                  ),
                  const SizedBox(height: 12),
                  if (destSvc.isLoading)
                    SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: 165,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else if (popularDestinations.isEmpty)
                    const SizedBox(
                      height: 80,
                      child: Center(
                        child: Text('Tidak dapat memuat destinasi',
                            style: TextStyle(color: AppColors.textGrey)),
                      ),
                    )
                  else
                    SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: popularDestinations.length,
                        itemBuilder: (context, index) {
                          final dest = popularDestinations[index];
                          return _DestinationModelCard(
                            destination: dest,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExploreDetailPage(destinationModel: dest),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // ── Rekomendasi ──────────────────────────────────────────
            if (destSvc.isLoading || recommendedDestinations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  children: [
                    _SectionHeader(
                      title: 'Rekomendasi Untukmu',
                      onSeeAll: () => widget.onCategoryTap(DestinationCategory.semua),
                    ),
                    const SizedBox(height: 12),
                    if (destSvc.isLoading)
                      SizedBox(
                        height: 210,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 165,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      SizedBox(
                        height: 210,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: recommendedDestinations.length,
                          itemBuilder: (context, index) {
                            final dest = recommendedDestinations[index];
                            return _DestinationModelCard(
                              destination: dest,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExploreDetailPage(destinationModel: dest),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey)),
        ],
      ),
    );
  }
}

class _SuggestChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: AppColors.primaryBlue.withOpacity(0.3), width: 1),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark)),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text('Lihat Semua →',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

/// Card untuk DestinationModel dari backend
class _DestinationModelCard extends StatelessWidget {
  final DestinationModel destination;
  final VoidCallback onTap;

  const _DestinationModelCard({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dest = destination;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: DestinationImage(
                imagePath: dest.displayImagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: dest.categoryColor.withOpacity(0.2),
                  child: Icon(Icons.image_not_supported_rounded,
                      color: dest.categoryColor, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dest.nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(dest.lokasi?.split(',').first ?? '',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFB300), size: 14),
                    const SizedBox(width: 3),
                    Text(
                        dest.rataRating != null
                            ? dest.rataRating!.toStringAsFixed(1)
                            : '4.8',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (dest.hargaTiket?.toLowerCase().contains('gratis') ??
                                  false)
                              ? 'Gratis'
                              : (dest.hargaTiket?.split('/').first ?? ''),
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF66BB6A),
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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