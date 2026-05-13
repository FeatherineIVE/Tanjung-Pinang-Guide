import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'ai_itinerary_form_page.dart';
import 'ai_itinerary_history.dart';
import 'ai_itinerary_result_page.dart';

class AIItineraryPage extends StatefulWidget {
  const AIItineraryPage({super.key});

  @override
  State<AIItineraryPage> createState() => _AIItineraryPageState();
}

class _AIItineraryPageState extends State<AIItineraryPage> {
  @override
  Widget build(BuildContext context) {
    return const AIItineraryFormPage();
  }
}
