import 'destination_model.dart';

/// Model bookmark sesuai response backend (bookmark.model.js).
/// Backend mengembalikan data destinasi lengkap dari JOIN bookmarks+destinations
class BookmarkModel {
  final int id;
  final DestinationModel destination;

  const BookmarkModel({
    required this.id,
    required this.destination,
  });

  /// Backend mengembalikan row destinasi langsung (bukan nested),
  /// karena query SELECT d.* FROM bookmarks b JOIN destinations d
  factory BookmarkModel.fromDestinationJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id:          json['id'] as int,
      destination: DestinationModel.fromJson(json),
    );
  }
}
