class ItineraryModel {
  final int id;
  final int userId;
  final String title;
  final int days;
  final int people;
  final String budgetType;
  final List<String> interests;
  final String notes;
  final num estimatedCostMin;
  final num estimatedCostMax;
  final String transportRecommendation;
  final String? createdAt;
  final List<ItineraryItemModel> items;

  ItineraryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.days,
    required this.people,
    required this.budgetType,
    required this.interests,
    required this.notes,
    required this.estimatedCostMin,
    required this.estimatedCostMax,
    required this.transportRecommendation,
    this.createdAt,
    this.items = const [],
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    return ItineraryModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      days: json['days'] ?? 1,
      people: json['people'] ?? 1,
      budgetType: json['budgetType'] ?? 'hemat',
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      notes: json['notes'] ?? '',
      estimatedCostMin: json['estimatedCostMin'] ?? 0,
      estimatedCostMax: json['estimatedCostMax'] ?? 0,
      transportRecommendation: json['transportRecommendation'] ?? '',
      createdAt: json['createdAt'],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ItineraryItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ItineraryItemModel {
  final int id;
  final int day;
  final String time;
  final String period;
  final String destinationName;
  final int? destinationId;
  final String? destinationSlug;
  final String category;
  final String duration;
  final num estimatedCost;
  final String description;
  final String tips;
  final String? mapsUrl;

  ItineraryItemModel({
    required this.id,
    required this.day,
    required this.time,
    required this.period,
    required this.destinationName,
    this.destinationId,
    this.destinationSlug,
    required this.category,
    required this.duration,
    required this.estimatedCost,
    required this.description,
    required this.tips,
    this.mapsUrl,
  });

  factory ItineraryItemModel.fromJson(Map<String, dynamic> json) {
    return ItineraryItemModel(
      id: json['id'] ?? 0,
      day: json['day'] ?? 1,
      time: json['time'] ?? '',
      period: json['period'] ?? '',
      destinationName: json['destinationName'] ?? '',
      destinationId: json['destinationId'],
      destinationSlug: json['destinationSlug'],
      category: json['category'] ?? '',
      duration: json['duration'] ?? '',
      estimatedCost: json['estimatedCost'] ?? 0,
      description: json['description'] ?? '',
      tips: json['tips'] ?? '',
      mapsUrl: json['mapsUrl'],
    );
  }
}
