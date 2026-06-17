import 'package:flutter_test/flutter_test.dart';
import 'package:tanjung_pinang_guide/models/destination_model.dart';

void main() {
  test('test fromJson', () {
    final json = {
      "id": 1,
      "slug": "patung-seribu",
      "name": "Patung Seribu",
      "category": "Sejarah",
      "location": "Tanjungpinang",
      "description": "Patung Seribu Wajah",
      "image": "http://example.com/image.jpg",
      "ratingAverage": 4.8,
      "reviewCount": 120,
      "visitCount": 500,
      "savedAt": "2023-10-10T00:00:00Z"
    };

    try {
      final model = DestinationModel.fromJson(json);
      print('Success: ${model.nama}');
    } catch (e, stacktrace) {
      print('Error: $e');
      print(stacktrace);
    }
  });
}
