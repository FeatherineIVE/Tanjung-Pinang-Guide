import 'package:flutter/material.dart';
import '../widgets/destination_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';
import '../data/destination_data.dart';
import '../models/destination_model.dart';
import '../services/auth_service.dart';
import '../services/destination_service.dart';
import 'explore_detail_page.dart';

class HomeLoggedInPage extends StatefulWidget {
  final void Function(DestinationCategory category) onCategoryTap;

  const HomeLoggedInPage({super.key, required this.onCategoryTap});

  @override
  State<HomeLoggedInPage> createState() => _HomeLoggedInPageState();
}

class _HomeLoggedInPageState extends State<HomeLoggedInPage> {
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

  @override
  Widget build(BuildContext context) {
    final destSvc = context.watch<DestinationService>();

    // Ambil 3 destinasi populer dari backend (urutan berdasarkan id: Patung Seribu, Pantai Trikora, Pulau Penyengat)
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
                      // App bar
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
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_none_rounded,
                                  color: Colors.white, size: 20),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Builder(
                        builder: (context) {
                          final auth = context.watch<AuthService>();
                          final name = auth.currentUser?.nama ?? auth.currentUser?.email ?? 'Pengguna';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Selamat Datang, $name! 👋',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 4),
                              const Text('Jelajahi\nTanjung Pinang',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2)),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Search bar → buka explore
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

            // ── AI Guide Card ───────────────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _AiChatCard(),
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



// ── AI Itinerary Promo Card ────────────────────────────────────────────────
class _AiChatCard extends StatelessWidget {
  const _AiChatCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryBlue, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Itinerary Generator',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                SizedBox(height: 2),
                Text('Buat rencana wisata otomatis dengan AI',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Coba',
                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
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

/// Card untuk destinasi dari backend (DestinationModel)
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: DestinationImage(
                imagePath: dest.displayImagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imageFallback(dest),
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
                      style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 14),
                    const SizedBox(width: 3),
                    Text(
                        dest.rataRating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (dest.hargaTiket?.toLowerCase().contains('gratis') ?? false)
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

  Widget _imageFallback(DestinationModel dest) {
    return Container(
      height: 120,
      color: dest.categoryColor.withOpacity(0.2),
      child: Icon(Icons.image_not_supported_rounded,
          color: dest.categoryColor, size: 40),
    );
  }
}
