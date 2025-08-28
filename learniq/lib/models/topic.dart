class Topic {
  final String id;
  final String titleRu;
  final String titleUk;
  final bool isFree;
  final int cardCount;
  final String iconAsset;
  final int order;

  Topic({
    required this.id,
    required this.titleRu,
    required this.titleUk,
    required this.isFree,
    required this.cardCount,
    required this.iconAsset,
    required this.order,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as String,
      titleRu: json['title_ru'] as String,
      titleUk: json['title_uk'] as String,
      isFree: json['is_free'] as bool,
      cardCount: json['card_count'] as int,
      iconAsset: json['icon_asset'] as String,
      order: json['order'] as int,
    );
  }

  String get title => titleRu; // Default to Russian for now
}
