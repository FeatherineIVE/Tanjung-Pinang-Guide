import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'ai_itinerary_form_page.dart';
import 'ai_itinerary_history.dart';

class AIItineraryPage extends StatefulWidget {
  const AIItineraryPage({super.key});

  @override
  State<AIItineraryPage> createState() => _AIItineraryPageState();
}

class _AIItineraryPageState extends State<AIItineraryPage> {
  bool _isForm = true;

  void _switchTab(bool isForm) {
    if (_isForm != isForm) {
      setState(() => _isForm = isForm);
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 40,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative circles
          Positioned(
            top: -30, left: -30,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: -10, right: -20,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 12),
                const Text(
                  'AI Itinerary Planner',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Rancang perjalanan terbaik Anda',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _switchTab(true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: _isForm ? AppColors.buttonGradient : null,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Text('Buat Baru',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _isForm ? Colors.white : AppColors.textGrey)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _switchTab(false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: !_isForm ? AppColors.buttonGradient : null,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Text('Riwayat',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: !_isForm ? Colors.white : AppColors.textGrey)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabToggle(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _isForm
                  ? const AIItineraryFormPage(key: ValueKey('form'))
                  : const AIItineraryHistory(key: ValueKey('history')),
            ),
          ],
        ),
      ),
    );
  }
}
