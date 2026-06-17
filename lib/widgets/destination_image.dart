import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DestinationImage extends StatelessWidget {
  static final Map<String, Uint8List> _base64Cache = {};

  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const DestinationImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
        ),
        errorWidget: (context, url, error) => errorBuilder != null
            ? errorBuilder!(context, error, null)
            : Container(
                width: width,
                height: height,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
              ),
      );
    } else if (imagePath.startsWith('data:image')) {
      try {
        final base64String = imagePath.split(',').last;
        if (!_base64Cache.containsKey(base64String)) {
          _base64Cache[base64String] = base64Decode(base64String);
        }
        return Image.memory(
          _base64Cache[base64String]!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: errorBuilder,
        );
      } catch (e) {
        if (errorBuilder != null) return errorBuilder!(context, e, null);
        return SizedBox(width: width, height: height);
      }
    } else {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }
  }
}
