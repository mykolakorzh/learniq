enum Article { der, die, das }

class CardItem {
  final String id;
  final String topicId;
  final String nounDe;
  final Article article;
  final String phonetic;
  final String translationRu;
  final String translationUk;
  final String imageAsset;

  const CardItem({
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
      article: Article.values.firstWhere(
        (e) => e.name == json['article'],
        orElse: () => Article.der,
      ),
      phonetic: json['phonetic'] as String? ?? '',
      translationRu: json['translation_ru'] as String,
      translationUk: json['translation_uk'] as String? ?? '',
      imageAsset: json['image_asset'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_id': topicId,
      'noun_de': nounDe,
      'article': article.name,
      'phonetic': phonetic,
      'translation_ru': translationRu,
      'translation_uk': translationUk,
      'image_asset': imageAsset,
    };
  }

  String getTranslation(String languageCode) {
    switch (languageCode) {
      case 'uk':
        return translationUk.isEmpty ? translationRu : translationUk;
      case 'ru':
      default:
        return translationRu;
    }
  }

  String getArticleText() {
    return article.name;
  }
}