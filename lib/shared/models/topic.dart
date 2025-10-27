class Topic {
  final String id;
  final String titleRu;
  final String titleUk;
  final bool isFree;
  final int cardCount;
  final String iconAsset;
  final int order;

  const Topic({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ru': titleRu,
      'title_uk': titleUk,
      'is_free': isFree,
      'card_count': cardCount,
      'icon_asset': iconAsset,
      'order': order,
    };
  }
}