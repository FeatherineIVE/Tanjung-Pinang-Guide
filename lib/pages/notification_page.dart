import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final notifications = [
      {
        'title': 'Destinasi Baru!',
        'message': 'Pantai Trikora 4 kini telah ditambahkan ke panduan kami. Cek sekarang!',
        'time': 'Baru saja',
        'icon': Icons.beach_access_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Tips Liburan',
        'message': 'Jangan lupa bawa payung, cuaca di Tanjung Pinang hari ini cukup terik.',
        'time': '2 jam yang lalu',
        'icon': Icons.wb_sunny_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'Itinerary Selesai',
        'message': 'Itinerary 3 hari Anda telah berhasil di-generate oleh AI.',
        'time': '1 hari yang lalu',
        'icon': Icons.auto_awesome,
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A9BD7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (notif['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notif['icon'] as IconData,
                    color: notif['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notif['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            notif['time'] as String,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['message'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
