import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../data/destination_data.dart';
import '../models/destination_model.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
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
                    const SizedBox(
                      height: 210,
                      child: Center(child: CircularProgressIndicator()),
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
                                // Langsung pass destinationModel — tidak perlu resolve!
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

// ── AI Chat Card ──────────────────────────────────────────────────────────────
class _AiChatCard extends StatefulWidget {
  const _AiChatCard();
  @override
  State<_AiChatCard> createState() => _AiChatCardState();
}

class _AiChatCardState extends State<_AiChatCard> {
  final _ctrl = TextEditingController();
  String? _lastQuestion;
  String? _lastReply;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _send(BuildContext ctx, {String? preset}) async {
    final msg = preset ?? _ctrl.text.trim();
    if (msg.isEmpty) return;
    setState(() { _lastQuestion = msg; _lastReply = null; });
    _ctrl.clear();
    final reply = await ctx.read<ChatService>().sendMessage(msg);
    if (!mounted) return;
    setState(() => _lastReply = reply ?? 'Maaf, tidak dapat menjawab saat ini.');
  }

  @override
  Widget build(BuildContext context) {
    final chatSvc = context.watch<ChatService>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.smart_toy_rounded, color: AppColors.primaryBlue, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('AI Guide', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Text('Tanya apa saja tentang Tanjung Pinang', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
            ]),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF66BB6A).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: const Text('● Online', style: TextStyle(fontSize: 11, color: Color(0xFF66BB6A), fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
            child: chatSvc.isLoading
                ? const Row(children: [
                    SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue)),
                    SizedBox(width: 10),
                    Text('AI Guide sedang mengetik...', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                  ])
                : Text(
                    _lastReply ?? '👋 Halo! Saya AI Guide kamu. Mau tanya soal destinasi wisata, kuliner, atau transportasi di Tanjung Pinang?',
                    style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
                  ),
          ),
          if (_lastQuestion != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(12)),
                child: Text(_lastQuestion!, style: const TextStyle(fontSize: 13, color: Colors.white)),
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (_lastQuestion == null)
            Wrap(spacing: 8, runSpacing: 8, children: [
              _SuggestChip(label: '🏖️ Pantai terbaik?', onTap: () => _send(context, preset: 'Pantai terbaik di Tanjung Pinang?')),
              _SuggestChip(label: '🍜 Kuliner wajib coba?', onTap: () => _send(context, preset: 'Kuliner wajib coba di Tanjung Pinang?')),
              _SuggestChip(label: '🚢 Cara ke Penyengat?', onTap: () => _send(context, preset: 'Bagaimana cara ke Pulau Penyengat?')),
            ]),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyBorder, width: 1),
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  enabled: !chatSvc.isLoading,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(context),
                  decoration: const InputDecoration(
                    hintText: 'Ketik pertanyaan...',
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.textHint),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 6),
                width: 36, height: 36,
                decoration: BoxDecoration(
                  gradient: chatSvc.isLoading
                      ? LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade300])
                      : AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: chatSvc.isLoading ? null : () => _send(context),
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                  padding: EdgeInsets.zero,
                ),
              ),
            ]),
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
              child: Image.asset(
                dest.displayImagePath,
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
