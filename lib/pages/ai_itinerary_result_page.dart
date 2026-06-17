import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/itinerary_service.dart';
import '../services/auth_service.dart';
import '../models/itinerary_model.dart';
import '../utils/pdf_generator.dart';
import '../widgets/app_toast.dart';

class AIItineraryResultPage extends StatefulWidget {
  final int? days;
  final int? people;
  final String? budget;
  final List<String>? interests;
  final String? notes;
  final ItineraryModel? existingItinerary;

  const AIItineraryResultPage({
    super.key,
    this.days,
    this.people,
    this.budget,
    this.interests,
    this.notes,
    this.existingItinerary,
  });

  @override
  State<AIItineraryResultPage> createState() => _AIItineraryResultPageState();
}

class _AIItineraryResultPageState extends State<AIItineraryResultPage> {
  ItineraryModel? _itineraryData;

  @override
  void initState() {
    super.initState();
    if (widget.existingItinerary != null) {
      _itineraryData = widget.existingItinerary;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchItinerary();
      });
    }
  }

  Future<void> _fetchItinerary() async {
    final aiService = context.read<ItineraryService>();
    final auth = context.read<AuthService>();
    
    if (widget.days == null || widget.budget == null) return;

    final result = await aiService.generateItinerary(
      userId: auth.currentUser?.id,
      days: widget.days!,
      people: widget.people ?? 1,
      budgetType: widget.budget!,
      interests: widget.interests ?? [],
      notes: widget.notes ?? '',
    );

    if (mounted && result != null) {
      setState(() {
        _itineraryData = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiService = context.watch<ItineraryService>();
    final isGenerating = aiService.isGenerating;
    final error = aiService.error;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // ── Header Premium ──────────────────────────────────────────
          _buildHeader(isGenerating),

          // ── Content ─────────────────────────────────────────────────
          Expanded(
            child: isGenerating
                ? _buildShimmerLoading()
                : error != null
                    ? _buildErrorState(error)
                    : _itineraryData != null
                        ? _buildItineraryContent(_itineraryData!)
                        : const Center(child: Text('Tidak ada data.')),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isGenerating) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00AEEF), Color(0xFF008CC4)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Itinerary Siap!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_itineraryData?.days ?? widget.days ?? 1} hari · ${_itineraryData?.people ?? widget.people ?? 1} orang · Budget ${(_itineraryData?.budgetType ?? widget.budget ?? 'Hemat').toLowerCase()}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if (_itineraryData != null && !isGenerating) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Estimasi',
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${(_itineraryData!.estimatedCostMin / 1000).toInt()}k - ${(_itineraryData!.estimatedCostMax / 1000).toInt()}k',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transportasi',
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _itineraryData!.transportRecommendation.isNotEmpty
                                  ? _itineraryData!.transportRecommendation
                                  : 'Tersedia',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItineraryContent(ItineraryModel data) {
    final Map<int, List<ItineraryItemModel>> groupedItems = {};
    for (var item in data.items) {
      groupedItems.putIfAbsent(item.day, () => []).add(item);
    }
    final sortedDays = groupedItems.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 40),
      itemCount: sortedDays.length + 1, // +1 for the buttons at the bottom
      itemBuilder: (context, index) {
        if (index == sortedDays.length) {
          // Bottom Buttons
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Transportasi Rekomendasi
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4), // Light greenish
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDCFCE7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.near_me_outlined, color: Color(0xFF0284C7), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Transportasi Rekomendasi',
                            style: TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.transportRecommendation.isNotEmpty ? data.transportRecommendation : 'Sewa motor (Rp 80.000-120.000/hari)',
                        style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Download Offline
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      AppToast.info(context, 'Menyiapkan dokumen PDF...');
                      await PdfGenerator.generateAndPrintItinerary(data);
                                        },
                    icon: const Icon(Icons.file_download_outlined, color: Color(0xFF0284C7)),
                    label: const Text(
                      'Download untuk Akses Offline',
                      style: TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF38BDF8)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Buat Itinerary Baru
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _fetchItinerary,
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    label: const Text(
                      'Buat Itinerary Baru',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final dayIndex = sortedDays[index];
        final plan = groupedItems[dayIndex] ?? [];
        
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: index == 0, // Expand the first day by default
              tilePadding: const EdgeInsets.all(16),
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00AEEF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$dayIndex',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hari $dayIndex — Rute Wisata',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A2A3A)),
                        ),
                        if (plan.isNotEmpty)
                          Text(
                            plan.first.category,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                const Divider(height: 1),
                // Tags
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: plan.map((item) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Text(
                          item.destinationName,
                          style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Timeline List
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildTimeline(plan),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildTimeline(List<ItineraryItemModel> plan) {
    List<Widget> widgets = [];
    String currentPeriod = '';

    for (int i = 0; i < plan.length; i++) {
      final item = plan[i];
      final isLast = i == plan.length - 1;

      // Draw Period Tag (Pagi/Siang/Malam)
      if (item.period != currentPeriod) {
        currentPeriod = item.period;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 12, top: i == 0 ? 0.0 : 16.0),
            child: _buildPeriodBadge(currentPeriod),
          ),
        );
      }

      widgets.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline line and dot
              SizedBox(
                width: 24,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (!isLast)
                      Container(
                        width: 2,
                        margin: const EdgeInsets.only(top: 8),
                        color: Colors.grey.shade300,
                      ),
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time and Title
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${item.time} ',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: item.destinationName,
                              style: const TextStyle(color: Color(0xFF1A2A3A), fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Description
                      Text(
                        item.description,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      // Duration and Cost
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(item.duration, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          const SizedBox(width: 12),
                          Icon(Icons.account_balance_wallet_rounded, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(item.estimatedCost > 0 ? 'Rp ${(item.estimatedCost / 1000).toInt()}k' : 'Gratis', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                      
                      // Tips Card
                      if (item.tips.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade100),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TIP', style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 11)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.tips,
                                  style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Maps Button
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final query = Uri.encodeComponent('${item.destinationName} Tanjungpinang');
                          final urlString = (item.mapsUrl != null && item.mapsUrl!.isNotEmpty) 
                              ? item.mapsUrl! 
                              : 'https://www.google.com/maps/search/?api=1&query=$query';
                          final uri = Uri.parse(urlString);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            if (context.mounted) {
                              AppToast.error(context, 'Tidak dapat membuka Google Maps');
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.cyan.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.cyan.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_outlined, size: 16, color: Colors.cyan.shade700),
                              const SizedBox(width: 6),
                              Text(
                                'Lihat Rute Lokasi',
                                style: TextStyle(color: Colors.cyan.shade700, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_outward_rounded, size: 14, color: Colors.cyan.shade700),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildPeriodBadge(String period) {
    IconData icon;
    Color color;
    Color bgColor;

    switch (period.toLowerCase()) {
      case 'pagi':
        icon = Icons.wb_sunny_rounded;
        color = Colors.orange.shade700;
        bgColor = Colors.orange.shade50;
        break;
      case 'siang':
        icon = Icons.wb_sunny_outlined;
        color = Colors.red.shade600;
        bgColor = Colors.red.shade50;
        break;
      case 'sore':
        icon = Icons.wb_twilight_rounded;
        color = Colors.deepOrange.shade600;
        bgColor = Colors.deepOrange.shade50;
        break;
      default:
        icon = Icons.nights_stay_rounded;
        color = Colors.indigo.shade600;
        bgColor = Colors.indigo.shade50;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            period.isNotEmpty ? period : 'Pagi',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Gagal Membuat Itinerary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchItinerary,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 40),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Day)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(width: 36, height: 36, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 150, height: 16, color: Colors.white),
                            const SizedBox(height: 6),
                            Container(width: 80, height: 12, color: Colors.white),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(height: 1, color: Colors.white),
                // Timeline Items
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(3, (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 60, height: 14, color: Colors.white),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(width: double.infinity, height: 16, color: Colors.white),
                                const SizedBox(height: 8),
                                Container(width: 120, height: 12, color: Colors.white),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
