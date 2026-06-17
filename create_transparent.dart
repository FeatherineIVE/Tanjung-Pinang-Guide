import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // Create a 288x288 transparent image (Android 12 splash size)
  final image = img.Image(width: 288, height: 288, numChannels: 4);
  
  // Fill with transparent color
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      image.setPixelRgba(x, y, 0, 0, 0, 0); // Fully transparent
    }
  }
  
  // Save to file
  final png = img.encodePng(image);
  File('assets/images/transparent.png').writeAsBytesSync(png);
  print('Transparent PNG created successfully at assets/images/transparent.png');
}
