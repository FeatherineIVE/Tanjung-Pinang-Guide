import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tanjung_pinang_guide/models/itinerary_model.dart';

class PdfGenerator {
  static Future<void> generateAndPrintItinerary(ItineraryModel itinerary) async {
    final pdf = pw.Document();

    // Group items by day
    final Map<int, List<ItineraryItemModel>> groupedItems = {};
    for (var item in itinerary.items) {
      groupedItems.putIfAbsent(item.day, () => []).add(item);
    }
    final sortedDays = groupedItems.keys.toList()..sort();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(itinerary),
            pw.SizedBox(height: 20),
            _buildSummary(itinerary),
            pw.SizedBox(height: 20),
            pw.Text('Rencana Perjalanan', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...sortedDays.map((dayIndex) {
              final plan = groupedItems[dayIndex] ?? [];
              return _buildDayPlan(dayIndex, plan);
            }),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Itinerary_Tanjungpinang_${itinerary.title.replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.Widget _buildHeader(ItineraryModel itinerary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Tanjungpinang Guide AI', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
        pw.SizedBox(height: 8),
        pw.Text(itinerary.title, style: const pw.TextStyle(fontSize: 16)),
        pw.Divider(color: PdfColors.grey400),
      ],
    );
  }

  static pw.Widget _buildSummary(ItineraryModel itinerary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Ringkasan:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text('Durasi: ${itinerary.days} Hari'),
          pw.Text('Peserta: ${itinerary.people} Orang'),
          pw.Text('Tipe Liburan: ${itinerary.budgetType}'),
          pw.Text('Estimasi Biaya: Rp ${itinerary.estimatedCostMin}k - Rp ${itinerary.estimatedCostMax}k'),
          pw.SizedBox(height: 8),
          pw.Text('Rekomendasi Transportasi:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(itinerary.transportRecommendation.isNotEmpty ? itinerary.transportRecommendation : 'Tersedia'),
        ],
      ),
    );
  }

  static pw.Widget _buildDayPlan(int dayIndex, List<ItineraryItemModel> plan) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Text('Hari $dayIndex', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
          ),
          pw.SizedBox(height: 8),
          ...plan.map((item) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12, left: 12),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 60,
                    child: pw.Text(item.time, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(item.destinationName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 2),
                        pw.Text(item.description, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                        if (item.tips.isNotEmpty) ...[
                          pw.SizedBox(height: 4),
                          pw.Text('Tip: ${item.tips}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.orange700)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
