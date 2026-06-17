import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class Activity {
  final String time;
  final String title;
  final String description;
  final String? icon;
  final List<String>? tips;
  final String? googleMapsUrl;

  Activity({
    required this.time,
    required this.title,
    required this.description,
    this.icon,
    this.tips,
    this.googleMapsUrl,
  });
}

class DailyPlan {
  final int day;
  final String dayTitle;
  final List<Activity> activities;

  DailyPlan({
    required this.day,
    required this.dayTitle,
    required this.activities,
  });
}

class ItineraryDetailPage extends StatefulWidget {
  final int days;
  final int people;
  final String budget;
  final List<String> interests;
  final String notes;

  const ItineraryDetailPage({
    required this.days,
    required this.people,
    required this.budget,
    required this.interests,
    required this.notes,
    super.key,
  });

  @override
  State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  late List<DailyPlan> dailyPlans;
  int _expandedDay = 0;

  @override
  void initState() {
    super.initState();
    _generateItinerary();
  }

  void _generateItinerary() {
    dailyPlans = [
      DailyPlan(
        day: 1,
        dayTitle: 'Tiba & Jelajah Kota',
        activities: [
          Activity(
            time: '08:00',
            title: 'Taman Tepi Laut',
            description:
                'Mulai pagi dengan sarapan di taman tepi laut sambil menikmati suasana kota.',
            icon: '🌅',
            tips: ['08 Jam', 'Gratis'],
            googleMapsUrl: '#',
          ),
          Activity(
            time: '09:30',
            title: 'Pulau Penyengat',
            description:
                'Naik perahu ke pulau bersejarah peniggalan Kesultanan Riau-Lingga. Kunjungi Masjid Sultan Riau dan struktur istana.',
            icon: '⛵',
            tips: ['3 jam', 'Pompa Rp 7.000/orang(trip)', 'Tiket gratis'],
            googleMapsUrl: '#',
          ),
          Activity(
            time: '12:30',
            title: 'Makan Siang — Kuliner Khas',
            description:
                'Santap makan siang dengan Gonggong (siput laut khas Tanjungpinang) di Pasar Bawah atau restoran pesisir.',
            icon: '🍽️',
            tips: ['1.5 jam', 'Rp 80.000-150.000/orang'],
          ),
          Activity(
            time: '17:30',
            title: 'Sunset di Tepi Laut',
            description:
                'Nikmati golden hour dan pemandangan matahari terbenam di Taman Tepi Laut atau Pelabuhan.',
            icon: '🌅',
            tips: ['1 jam', 'Gratis'],
          ),
          Activity(
            time: '19:00',
            title: 'Makan Malam — Seafood',
            description:
                'Makan malam seafood segar di warung-warung tradisional',
            icon: '🦐',
            tips: ['1.5 jam', 'Rp 100.000-200.000/orang'],
          ),
        ],
      ),
      DailyPlan(
        day: 2,
        dayTitle: 'Petualangan & Kultur',
        activities: [
          Activity(
            time: '08:00',
            title: 'Museum Raja Ali Haji',
            description:
                'Pelajari sejarah Kerajaan Riau melalui koleksi artefak dan benda-benda bersejarah.',
            icon: '🏛️',
            tips: ['2 jam', 'Rp 20.000/orang'],
            googleMapsUrl: '#',
          ),
          Activity(
            time: '10:30',
            title: 'Pasar Tradisional',
            description:
                'Jelajahi Pasar Bawah untuk mencari oleh-oleh dan souvenir khas Tanjungpinang.',
            icon: '🛍️',
            tips: ['1.5 jam', 'Terserah budget Anda'],
          ),
          Activity(
            time: '12:30',
            title: 'Makan Siang — Lokal',
            description: 'Nikmati makanan lokal di kedai kopi tradisional.',
            icon: '☕',
            tips: ['1 jam', 'Rp 30.000-50.000/orang'],
          ),
          Activity(
            time: '14:00',
            title: 'Pantai Trikora',
            description:
                'Bersantai di pantai dengan pasir putih, cocok untuk berenang dan bermain air.',
            icon: '🏖️',
            tips: ['3 jam', 'Gratis'],
            googleMapsUrl: '#',
          ),
        ],
      ),
    ];

    // Sesuaikan jumlah hari
    while (dailyPlans.length < widget.days) {
      dailyPlans.add(
        DailyPlan(
          day: dailyPlans.length + 1,
          dayTitle: 'Hari ${dailyPlans.length + 1}',
          activities: [
            Activity(
              time: '09:00',
              title: 'Aktivitas Lanjutan',
              description: 'Jelajahi destinasi menarik lainnya di Tanjungpinang',
              icon: '🎒',
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricePerPerson = _getEstimatedPrice();
    final totalPrice = pricePerPerson * widget.people;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(gradient: AppColors.headerGradient),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Back Button
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Itinerary Siap!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.days} hari, ${widget.people} orang - Budget ${widget.budget}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Estimasi',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${_formatCurrency(pricePerPerson)} (${widget.people} orang: Rp ${_formatCurrency(totalPrice)})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A2A3A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Transportasi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sewa Motor',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Daily Plans
                  const Text(
                    'Rencana Harian',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2A3A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // List of Days
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dailyPlans.length,
                    itemBuilder: (context, index) {
                      return _buildDayCard(dailyPlans[index], index);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.headerGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Itinerary disimpan ke riwayat'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bookmark_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Simpan Itinerary',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(DailyPlan dayPlan, int index) {
    final isExpanded = _expandedDay == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Day
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedDay = isExpanded ? -1 : index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9BD7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${dayPlan.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hari ${dayPlan.day} - ${dayPlan.dayTitle}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A2A3A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${dayPlan.activities.length} aktivitas',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Activities (when expanded)
          if (isExpanded) ...[
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  dayPlan.activities.length,
                  (actIndex) {
                    final activity = dayPlan.activities[actIndex];
                    return _buildActivityItem(activity);
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time & Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  activity.time,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A9BD7),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${activity.icon ?? '📍'} ${activity.title}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A2A3A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Tips
          if (activity.tips != null && activity.tips!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: activity.tips!.map((tip) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ℹ️ $tip',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.amber[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Google Maps Link
          if (activity.googleMapsUrl != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Membuka lokasi di Google Maps...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Lihat Lokasi di Google Maps',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Divider
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  int _getEstimatedPrice() {
    switch (widget.budget) {
      case 'Hemat':
        return 500000;
      case 'Sedang':
        return 1000000;
      case 'Mewah':
        return 2000000;
      default:
        return 1000000;
    }
  }
}
