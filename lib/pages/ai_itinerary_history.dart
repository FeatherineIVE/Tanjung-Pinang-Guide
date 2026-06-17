import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/itinerary_service.dart';
import '../models/itinerary_model.dart';
import '../utils/app_colors.dart';
import 'ai_itinerary_form_page.dart';
import 'ai_itinerary_result_page.dart';

class AIItineraryHistory extends StatefulWidget {
  const AIItineraryHistory({super.key});

  @override
  State<AIItineraryHistory> createState() => _AIItineraryHistoryState();
}

class _AIItineraryHistoryState extends State<AIItineraryHistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthService>();
      if (auth.isLoggedIn) {
        context.read<ItineraryService>().fetchUserItineraries(auth.currentUser!.id);
      }
    });
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itineraryService = context.watch<ItineraryService>();
    final auth = context.watch<AuthService>();

    if (!auth.isLoggedIn) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.lock_outline, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('Silakan login untuk melihat riwayat',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      );
    }

    if (itineraryService.isGenerating && itineraryService.itineraries.isEmpty) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ));
    }

    final historyList = itineraryService.itineraries;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (historyList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('Belum ada riwayat itinerary',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
              ),
            ),
          ...historyList.map((history) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A9BD7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${history.days} Hari · ${history.people} Orang',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDate(history.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              history.budgetType.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Highlights
                      if (history.interests.isNotEmpty) ...[
                        const Text(
                          'MINAT WISATA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: history.interests
                              .map(
                                (highlight) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A9BD7).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xFF1A9BD7).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    highlight,
                                    style: const TextStyle(
                                      color: Color(0xFF1A9BD7),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Cost
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet,
                              color: Colors.green.shade600, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Rp ${((history.estimatedCostMin) / 1000).toStringAsFixed(0)}k - Rp ${((history.estimatedCostMax) / 1000).toStringAsFixed(0)}k',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1A9BD7),
                                side: const BorderSide(color: Color(0xFF1A9BD7)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AIItineraryResultPage(
                                      existingItinerary: history,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.visibility, size: 16),
                              label: const Text(
                                'Lihat Itinerary',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                itineraryService.deleteItinerary(history.id);
                              },
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: const Text(
                                'Hapus',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          }),

          // Create New Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A9BD7),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // If this is embedded in AIItineraryPage, switching tab is better.
                // We'll let user switch tabs on top instead of pushing a new page.
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: const Text(
                'Buat Itinerary Baru',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

