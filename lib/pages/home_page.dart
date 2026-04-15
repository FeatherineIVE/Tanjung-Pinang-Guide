import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Header ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A9BD7), Color(0xFF0D7AB5)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Bar Row
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
                                child: const Icon(Icons.explore_rounded,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'TanjungPinang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigate to login
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.4)),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Selamat Datang! 👋',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Jelajahi\nTanjung Pinang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Search Bar
                      Container(
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
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari destinasi, kuliner...',
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: Colors.grey[400]),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A9BD7),
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
                    ],
                  ),
                ),
              ),
            ),

            // ── Kategori Wisata ──────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      const Text(
                        'Kategori Wisata',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2A3A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _CategoryItem(
                              icon: Icons.beach_access_rounded,
                              label: 'Pantai',
                              color: Color(0xFF1A9BD7)),
                          _CategoryItem(
                              icon: Icons.account_balance_rounded,
                              label: 'Budaya',
                              color: Color(0xFFFF7043)),
                          _CategoryItem(
                              icon: Icons.restaurant_rounded,
                              label: 'Kuliner',
                              color: Color(0xFF66BB6A)),
                          _CategoryItem(
                              icon: Icons.hotel_rounded,
                              label: 'Hotel',
                              color: Color(0xFFAB47BC)),
                          _CategoryItem(
                              icon: Icons.directions_boat_rounded,
                              label: 'Wisata',
                              color: Color(0xFFFFB300)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Login / Daftar Gratis Banner ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A9BD7), Color(0xFF0D6EA3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mulai Perjalananmu!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Daftar gratis & nikmati semua fitur eksklusif',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              // Masuk
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // TODO: Navigate to login
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF1A9BD7),
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
                              // Daftar Gratis
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // TODO: Navigate to register
                                    },
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

            // ── AI Guide Chat ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A9BD7).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.smart_toy_rounded,
                              color: Color(0xFF1A9BD7), size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Guide',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A2A3A),
                              ),
                            ),
                            Text(
                              'Tanya apa saja tentang Tanjung Pinang',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
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
                          child: const Text(
                            '● Online',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF66BB6A),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Chat bubble dari AI
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '👋 Halo! Saya AI Guide kamu. Mau tanya soal destinasi wisata, kuliner, atau transportasi di Tanjung Pinang?',
                        style: TextStyle(
                            fontSize: 13, color: Color(0xFF1A2A3A), height: 1.4),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Suggested questions
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SuggestChip(label: '🏖️ Pantai terbaik?'),
                        _SuggestChip(label: '🍜 Kuliner wajib coba?'),
                        _SuggestChip(label: '🚢 Cara ke Penyengat?'),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Input bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F4FD),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Ketik pertanyaanmu...',
                                hintStyle: TextStyle(
                                    fontSize: 13, color: Colors.grey),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A9BD7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Destinasi Populer ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  _SectionHeader(
                      title: 'Destinasi Populer', onSeeAll: () {}),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      children: const [
                        _DestinationCard(
                          bgColor: Color(0xFF1A9BD7),
                          emoji: '🏖️',
                          title: 'Pantai Trikora',
                          subtitle: 'Bintan, Kep. Riau',
                          rating: '4.8',
                        ),
                        _DestinationCard(
                          bgColor: Color(0xFF26A69A),
                          emoji: '🕌',
                          title: 'Masjid Raya',
                          subtitle: 'Tanjung Pinang',
                          rating: '4.7',
                        ),
                        _DestinationCard(
                          bgColor: Color(0xFFEF5350),
                          emoji: '🏯',
                          title: 'Pulau Penyengat',
                          subtitle: 'Kota TPI',
                          rating: '4.9',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Kuliner Khas ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  _SectionHeader(title: 'Kuliner Khas', onSeeAll: () {}),
                  const SizedBox(height: 12),
                  const _CulinaryListItem(
                    emoji: '🍜',
                    title: 'Mie Tarempa',
                    desc: 'Mie khas Anambas dengan bumbu rempah kuat',
                    color: Color(0xFFFF8A65),
                  ),
                  const _CulinaryListItem(
                    emoji: '🥘',
                    title: 'Gonggong',
                    desc: 'Siput laut rebus, kuliner ikonik Tanjung Pinang',
                    color: Color(0xFF4DB6AC),
                  ),
                  const _CulinaryListItem(
                    emoji: '🍱',
                    title: 'Nasi Dagang',
                    desc: 'Nasi lemak khas Melayu dengan lauk ikan',
                    color: Color(0xFF7986CB),
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

// ─── Private Widgets ─────────────────────────────────────────────────────────

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CategoryItem(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700])),
      ],
    );
  }
}

class _SuggestChip extends StatelessWidget {
  final String label;
  const _SuggestChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF1A9BD7).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color(0xFF1A9BD7).withOpacity(0.3), width: 1),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1A9BD7),
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
                color: Color(0xFF1A2A3A))),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text('Lihat Semua →',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1A9BD7),
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final Color bgColor;
  final String emoji;
  final String title;
  final String subtitle;
  final String rating;

  const _DestinationCard({
    required this.bgColor,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
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
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.15),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 48))),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF1A2A3A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFB300), size: 14),
                  const SizedBox(width: 3),
                  Text(rating,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2A3A))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CulinaryListItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String desc;
  final Color color;

  const _CulinaryListItem(
      {required this.emoji,
      required this.title,
      required this.desc,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1A2A3A))),
                const SizedBox(height: 2),
                Text(desc,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }
}