class Topic {
  final String id;
  final String titleRu;
  final String titleUk;
  final bool isFree;
  final int cardCount;
  final String? iconAsset; // Made optional to handle missing icon files
  final int order;

  Topic({
    required this.id,
    required this.titleRu,
    required this.titleUk,
    required this.isFree,
    required this.cardCount,
    this.iconAsset, // No longer required
    required this.order,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as String,
      titleRu: json['title_ru'] as String,
      titleUk: json['title_uk'] as String,
      isFree: json['is_free'] as bool,
      cardCount: json['card_count'] as int,
      iconAsset: json['icon_asset'] as String?, // Made optional
      order: json['order'] as int,
    );
  }

  /// Returns title based on locale code ('uk', 'ru', or 'en')
  /// Defaults to Russian if locale not recognized
  String getTitle(String locale) {
    switch (locale.toLowerCase()) {
      case 'uk':
        return titleUk;
      case 'ru':
      case 'en': // English users see Russian (transliteration)
      default:
        return titleRu;
    }
  }

  /// Deprecated: Use getTitle(locale) instead
  /// This maintains backward compatibility but always returns Russian
  @Deprecated('Use getTitle(locale) to get locale-aware title')
  String get title => titleRu;
}
