import 'package:flutter/material.dart';
import 'ai_itinerary_result_page.dart';

class AIItineraryFormPage extends StatefulWidget {
  const AIItineraryFormPage({super.key});

  @override
  State<AIItineraryFormPage> createState() => _AIItineraryFormPageState();
}

class _AIItineraryFormPageState extends State<AIItineraryFormPage> {
  int _days = 1;
  int _people = 1;
  String _budget = '';
  final Set<String> _selectedInterests = {};
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, dynamic>> _interests = [
    {'name': 'Sejarah', 'icon': Icons.museum},
    {'name': 'Pantai', 'icon': Icons.beach_access},
    {'name': 'Kuliner', 'icon': Icons.restaurant},
    {'name': 'Alam', 'icon': Icons.park},
  ];

  void _resetForm() {
    setState(() {
      _days = 1;
      _people = 1;
      _budget = '';
      _selectedInterests.clear();
      _notesController.clear();
    });
  }

  void _createItinerary() {
    if (_budget.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih budget perjalanan terlebih dahulu')),
      );
      return;
    }

    // Navigasi ke halaman hasil
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AIItineraryResultPage(
          days: _days,
          people: _people,
          budget: _budget,
          interests: _selectedInterests.toList(),
          notes: _notesController.text,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                  // Days Section
                  const Row(
                    children: [
                      Icon(Icons.calendar_today, color: Color(0xFF1A9BD7), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Berapa Hari?',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(5, (i) {
                      final days = i + 1;
                      final selected = _days == days;
                      return GestureDetector(
                        onTap: () => setState(() => _days = days),
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 32 - 24) / 4,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF1A9BD7) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected ? const Color(0xFF1A9BD7) : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$days Hari',
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // People Section
                  const Row(
                    children: [
                      Icon(Icons.people, color: Color(0xFF1A9BD7), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Berapa Orang?',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            if (_people > 1) _people--;
                          }),
                          child: const Icon(Icons.remove, color: Color(0xFF1A9BD7), size: 28),
                        ),
                        Column(
                          children: [
                            Text(
                              '$_people',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'orang',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _people++),
                          child: const Icon(Icons.add, color: Color(0xFF1A9BD7), size: 28),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Budget Section
                  const Row(
                    children: [
                      Icon(Icons.wallet, color: Color(0xFF1A9BD7), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Budget Perjalanan',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      {'label': 'Hemat', 'range': '< Rp 200rb/hari', 'icon': Icons.money_off},
                      {'label': 'Sedang', 'range': 'Rp 200-500rb/hari', 'icon': Icons.attach_money},
                      {'label': 'Mewah', 'range': '> Rp 500rb/hari', 'icon': Icons.diamond},
                    ].map((b) {
                      final selected = _budget == b['label'];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _budget = b['label'] as String),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFF1A9BD7) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selected ? const Color(0xFF1A9BD7) : Colors.grey.shade300,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  b['icon'] as IconData,
                                  color: selected ? Colors.white : Colors.grey,
                                  size: 24,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  b['label'] as String,
                                  style: TextStyle(
                                    color: selected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  b['range'] as String,
                                  style: TextStyle(
                                    color: selected ? Colors.white70 : Colors.grey[600],
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Interests Section
                  const Row(
                    children: [
                      Icon(Icons.favorite, color: Color(0xFF1A9BD7), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Minat Wisata (Pilih bebas)',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Jika kosong, itinerary akan mencakup semua jenis wisata',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interests.map((interest) {
                      final isSelected = _selectedInterests.contains(interest['name']);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (isSelected) {
                            _selectedInterests.remove(interest['name']);
                          } else {
                            _selectedInterests.add(interest['name']);
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1A9BD7) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF1A9BD7) : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                interest['icon'],
                                color: isSelected ? Colors.white : Colors.grey,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                interest['name'],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Notes Section
                  const Row(
                    children: [
                      Icon(Icons.notes, color: Color(0xFF1A9BD7), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Catatan Tambahan (opsional)',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Ada anak kecil, tidak bisa berenang, vegetarian',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF1A9BD7), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A9BD7),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _createItinerary,
                      icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                      label: const Text(
                        'Buat Itinerary Sekarang',
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
