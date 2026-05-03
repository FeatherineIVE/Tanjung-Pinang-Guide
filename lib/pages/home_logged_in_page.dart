import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../data/destination_data.dart';
import '../data/auth_service.dart';
import 'explore_detail_page.dart';

class HomeLoggedInPage extends StatelessWidget {
  final void Function(DestinationCategory category) onCategoryTap;

  const HomeLoggedInPage({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final popularDestinations = [
      allDestinations.firstWhere((d) => d.title == 'Pantai Trikora'),
      allDestinations.firstWhere((d) => d.title == 'Masjid Raya Sultan Riau'),
      allDestinations.firstWhere((d) => d.title == 'Pulau Penyengat'),
    ];

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
                              // ── Logo putih ──────────────
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
                          // Ikon notifikasi (sudah login)
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
                          final auth = AuthProvider.of(context);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Selamat Datang, ${auth.userName}! 👋',
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
                        onTap: () =>
                            onCategoryTap(DestinationCategory.semua),
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
                            onTap: () => onCategoryTap(
                                DestinationCategory.sejarah),
                          ),
                          _CategoryItem(
                            icon: Icons.beach_access_rounded,
                            label: 'Pantai',
                            color: AppColors.primaryBlue,
                            onTap: () => onCategoryTap(
                                DestinationCategory.pantai),
                          ),
                          _CategoryItem(
                            icon: Icons.park_rounded,
                            label: 'Alam',
                            color: const Color(0xFF66BB6A),
                            onTap: () =>
                                onCategoryTap(DestinationCategory.alam),
                          ),
                          _CategoryItem(
                            icon: Icons.restaurant_rounded,
                            label: 'Kuliner',
                            color: const Color(0xFFAB47BC),
                            onTap: () => onCategoryTap(
                                DestinationCategory.kuliner),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── AI Guide (tanpa login/daftar) ──────────────────────────────
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
                    // Suggest chips (langsung bisa digunakan)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SuggestChip(
                          label: '🏖️ Pantai terbaik?',
                          onTap: () {},
                        ),
                        _SuggestChip(
                          label: '🍜 Kuliner wajib coba?',
                          onTap: () {},
                        ),
                        _SuggestChip(
                          label: '🚢 Cara ke Penyengat?',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Chat input field (menggantikan tombol masuk/daftar)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.greyBorder, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Ketik pertanyaan...',
                                hintStyle: TextStyle(
                                    fontSize: 13, color: AppColors.textHint),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: AppColors.buttonGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.send_rounded,
                                  color: Colors.white, size: 16),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
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
                    onSeeAll: () =>
                        onCategoryTap(DestinationCategory.semua),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: popularDestinations.length,
                      itemBuilder: (context, index) {
                        final dest = popularDestinations[index];
                        return _DestinationCard(
                          destination: dest,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExploreDetailPage(destination: dest),
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
          border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.3), width: 1),
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

class _DestinationCard extends StatelessWidget {
  final DestinationData destination;
  final VoidCallback onTap;

  const _DestinationCard({required this.destination, required this.onTap});

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
              child: Image.asset(
                dest.imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: dest.bgColor.withOpacity(0.2),
                  child: Icon(Icons.image_not_supported_rounded,
                      color: dest.bgColor, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dest.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(dest.lokasi.split(',').first,
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
                        dest.nearby.isNotEmpty
                            ? dest.nearby.first.rating.toString()
                            : '4.8',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF66BB6A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        dest.hargaTiket.toLowerCase().contains('gratis')
                            ? 'Gratis'
                            : dest.hargaTiket.split('/').first,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF66BB6A),
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
