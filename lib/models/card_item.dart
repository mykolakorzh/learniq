class CardItem {
  final String id;
  final String topicId;
  final String nounDe;
  final String article;
  final String phonetic;
  final String translationRu;
  final String translationUk;
  final String imageAsset;

  CardItem({
    required this.id,
    required this.topicId,
    required this.nounDe,
    required this.article,
    required this.phonetic,
    required this.translationRu,
    required this.translationUk,
    required this.imageAsset,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id'] as String,
      topicId: json['topic_id'] as String,
      nounDe: json['noun_de'] as String,
      article: json['article'] as String,
      phonetic: json['phonetic'] as String,
      translationRu: json['translation_ru'] as String,
      translationUk: json['translation_uk'] as String,
      imageAsset: json['image_asset'] as String,
    );
  }

  /// Returns translation based on locale code ('uk', 'ru', or 'en')
  /// Defaults to Russian if locale not recognized
  String getTranslation(String locale) {
    switch (locale.toLowerCase()) {
      case 'uk':
        return translationUk.isNotEmpty ? translationUk : translationRu;
      case 'ru':
      case 'en': // English users see Russian (transliteration)
      default:
        return translationRu;
    }
  }

  /// Deprecated: Use getTranslation(locale) instead
  /// This maintains backward compatibility but always returns Russian
  @Deprecated('Use getTranslation(locale) to get locale-aware translation')
  String get translation => translationRu;
}
