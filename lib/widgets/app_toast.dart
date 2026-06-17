import 'package:flutter/material.dart';

/// Helper global untuk menampilkan toast di posisi antara atas dan tengah layar.
class AppToast {
  /// Tampilkan toast sukses (hijau)
  static void success(BuildContext context, String message) {
    _show(context, message, isError: false);
  }

  /// Tampilkan toast error (merah)
  static void error(BuildContext context, String message) {
    _show(context, message, isError: true);
  }

  /// Tampilkan toast info (biru)
  static void info(BuildContext context, String message) {
    _show(context, message, isInfo: true);
  }

  static void _show(BuildContext context, String message,
      {bool isError = false, bool isInfo = false}) {
    // Hapus overlay sebelumnya jika ada
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    // Posisi: antara atas dan tengah (sekitar 25% dari atas)
    final topPosition = topPadding + (screenHeight * 0.18);

    Color bgColor;
    IconData icon;
    if (isInfo) {
      bgColor = const Color(0xFF1976D2);
      icon = Icons.info_outline;
    } else if (isError) {
      bgColor = const Color(0xFFE53935);
      icon = Icons.error_outline;
    } else {
      bgColor = const Color(0xFF43A047);
      icon = Icons.check_circle_outline;
    }

    final entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        bgColor: bgColor,
        icon: icon,
        topPosition: topPosition,
      ),
    );

    _currentOverlay = entry;
    overlay.insert(entry);

    // Auto-dismiss
    Future.delayed(Duration(seconds: isError ? 3 : 2), () {
      if (entry.mounted) {
        entry.remove();
      }
      if (_currentOverlay == entry) _currentOverlay = null;
    });
  }

  static OverlayEntry? _currentOverlay;
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Color bgColor;
  final IconData icon;
  final double topPosition;

  const _ToastWidget({
    required this.message,
    required this.bgColor,
    required this.icon,
    required this.topPosition,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.topPosition,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: widget.bgColor.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
