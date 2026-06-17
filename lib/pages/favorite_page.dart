import 'package:flutter/material.dart';
import '../widgets/destination_image.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import '../models/destination_model.dart';
import '../screens/auth_screen.dart';
import 'explore_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    // Fetch bookmarks saat halaman pertama dibuka (jika sudah login)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthService>();
      if (auth.isLoggedIn) {
        context.read<FavoriteService>().fetchFavorites(auth.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth  = context.watch<AuthService>();
    final bm    = context.watch<FavoriteService>();

    // ── Belum login ───────────────────────────────────────────────────────
    if (!auth.isLoggedIn && !auth.isGuest) {
      return _NotLoggedInView();
    }

    if (auth.isGuest || !auth.isLoggedIn) {
      return _GuestView();
    }

    final favorites = bm.favorites;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => bm.fetchFavorites(auth.currentUser!.id),
        color: AppColors.primaryBlue,
        child: CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(gradient: AppColors.headerGradient),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Favorit Saya',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${favorites.length} destinasi tersimpan',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Loading ─────────────────────────────────────────────────
            if (bm.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primaryBlue),
                ),
              )

            // ── Kosong ──────────────────────────────────────────────────
            else if (favorites.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_outline_rounded, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('Belum ada favorit',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text(
                        'Simpan destinasi favorit Anda\nuntuk akses cepat',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )

            // ── Daftar ──────────────────────────────────────────────────
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final dest = favorites[index];
                      return _FavoriteCard(
                        destination: dest,
                        onRemove: () async {
                          final success = await bm.removeFavorite(auth.currentUser!.id, dest.id);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${dest.nama} dihapus dari favorit'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red[400],
                              ),
                            );
                          }
                        },
                      );
                    },
                    childCount: favorites.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── View untuk tamu ─────────────────────────────────────────────────────────────
class _GuestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 20),
                const Text('Login untuk menyimpan favorit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Buat akun gratis dan simpan\ndestinasi favoritmu!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Masuk / Daftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotLoggedInView extends _GuestView {}

// ── Kartu Favorit ─────────────────────────────────────────────────────────────
class _FavoriteCard extends StatelessWidget {
  final DestinationModel destination;
  final VoidCallback onRemove;

  const _FavoriteCard({required this.destination, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gambar + Badge ─────────────────────────────────────────
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  color: destination.categoryColor,
                  child: DestinationImage(
                    imagePath: destination.displayImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: destination.categoryColor.withOpacity(0.3),
                      child: Icon(Icons.image_not_supported_rounded, size: 48, color: Colors.grey[300]),
                    ),
                  ),
                ),
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: destination.categoryColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(destination.kategori,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
                        const SizedBox(width: 4),
                        Text(destination.ratingFormatted,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A2A3A))),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Konten ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(destination.nama,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A2A3A)),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(destination.deskripsi ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.location_on_rounded, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(destination.lokasi?.split(',').first ?? '',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    const SizedBox(width: 12),
                    const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFC107)),
                    const SizedBox(width: 4),
                    Text('${destination.jumlahUlasan} ulasan',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExploreDetailPage(destinationModel: destination),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF1A9BD7)),
                            SizedBox(width: 6),
                            Text('Lihat Detail',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A9BD7))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onRemove,
                      child: Row(children: [
                        Icon(Icons.close_rounded, size: 14, color: Colors.red[400]),
                        const SizedBox(width: 6),
                        Text('Hapus', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red[400])),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
