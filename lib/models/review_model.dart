class ReviewModel {
  final int id;
  final int? destinationId;
  final String? destinationName;
  final int? userId;
  final String userName;
  final String? userAvatar;
  final String? userPhoto;
  final double rating;
  final String comment;
  final String status;
  final String? createdAt;
  final bool isVerifiedVisit;

  const ReviewModel({
    required this.id,
    this.destinationId,
    this.destinationName,
    this.userId,
    required this.userName,
    this.userAvatar,
    this.userPhoto,
    required this.rating,
    required this.comment,
    this.status = 'visible',
    this.createdAt,
    this.isVerifiedVisit = false,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int,
      destinationId: json['destinationId'] as int?,
      destinationName: json['destinationName'] as String?,
      userId: json['userId'] as int?,
      userName: json['userName'] as String? ?? 'Pengguna',
      userAvatar: json['userAvatar'] as String?,
      userPhoto: json['userPhoto'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? '',
      status: json['status'] as String? ?? 'visible',
      createdAt: json['createdAt'] as String?,
      isVerifiedVisit: json['isVerifiedVisit'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'destinationId': destinationId,
        'destinationName': destinationName,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'userPhoto': userPhoto,
        'rating': rating,
        'comment': comment,
        'status': status,
        'createdAt': createdAt,
        'isVerifiedVisit': isVerifiedVisit,
      };
}
