import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';
import '../data/destination_data.dart';
import '../widgets/login_required_sheet.dart';

class ExploreDetailPage extends StatefulWidget {
  final DestinationData destination;
  const ExploreDetailPage({super.key, required this.destination});

  @override
  State<ExploreDetailPage> createState() => _ExploreDetailPageState();
}

class _ExploreDetailPageState extends State<ExploreDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openMaps() async {
    final lat = widget.destination.mapsLat;
    final lng = widget.destination.mapsLng;
    final label = Uri.encodeComponent(widget.destination.title);
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng($label)');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dest = widget.destination;

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
                  // Favorit → LoginRequiredSheet
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => LoginRequiredSheet.show(context),
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
                        dest.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: dest.bgColor.withOpacity(0.3),
                          child: Icon(Icons.image_not_supported_rounded,
                              color: dest.bgColor, size: 80),
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
                                color: dest.bgColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(dest.categoryLabel,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(height: 6),
                            Text(dest.title,
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
                          label: dest.distance,
                          color: AppColors.primaryBlue),
                      const SizedBox(width: 8),
                      _InfoChip(
                          icon: Icons.access_time_rounded,
                          label: dest.jamBuka,
                          color: const Color(0xFF66BB6A)),
                      const SizedBox(width: 8),
                      _InfoChip(
                          icon: Icons.confirmation_number_rounded,
                          label: dest.hargaTiket,
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
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Info'),
                      Tab(text: 'Tips'),
                      Tab(text: 'Sekitar'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _InfoTab(dest: dest),
                _TipsTab(dest: dest),
                _SekitarTab(dest: dest),
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
                  // Favorit → LoginRequiredSheet
                  GestureDetector(
                    onTap: () => LoginRequiredSheet.show(context),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: Colors.red.shade200, width: 1.5),
                      ),
                      child: Icon(Icons.favorite_border_rounded,
                          color: Colors.red.shade400, size: 22),
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
  final DestinationData dest;
  const _InfoTab({required this.dest});

  @override
  Widget build(BuildContext context) {
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
          Text(dest.description,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textGrey, height: 1.6)),
          const SizedBox(height: 20),
          _DetailRow(icon: Icons.location_on_rounded, label: 'Lokasi', value: dest.lokasi),
          const SizedBox(height: 12),
          _DetailRow(icon: Icons.access_time_rounded, label: 'Jam Buka', value: dest.jamBuka),
          const SizedBox(height: 12),
          _DetailRow(icon: Icons.confirmation_number_rounded, label: 'Harga Tiket', value: dest.hargaTiket),
          const SizedBox(height: 20),
          const Text('Tag',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: dest.tags.map((tag) => Container(
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
  final DestinationData dest;
  const _TipsTab({required this.dest});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tips Berkunjung',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 14),
          ...dest.tips.map((tip) => Container(
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
  final DestinationData dest;
  const _SekitarTab({required this.dest});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Destinasi Terdekat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 14),
          ...dest.nearby.map((item) => Container(
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