import 'package:flutter/services.dart';

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
    final imageAsset = json['image_asset'] as String? ?? '';
    
    return CardItem(
      id: json['id'] as String,
      topicId: json['topic_id'] as String,
      nounDe: json['noun_de'] as String,
      article: json['article'] as String,
      phonetic: json['phonetic'] as String? ?? '',
      translationRu: json['translation_ru'] as String,
      translationUk: json['translation_uk'] as String,
      imageAsset: imageAsset,
    );
  }

  /// Checks if the card has a valid image path
  bool isValid() {
    return imageAsset.isNotEmpty;
  }

  /// Gets image path with fallback options
  /// Returns the original path, or attempts to find alternative extensions
  String getImagePathWithFallback() {
    if (imageAsset.isEmpty) {
      return '';
    }

    // Try original path first
    try {
      // In Flutter, we can't check file existence at runtime easily
      // So we return the path and let Image.asset handle errors
      return imageAsset;
    } catch (e) {
      // If original fails, try common alternatives
      final basePath = imageAsset.split('.').first;
      final extensions = ['.jpg', '.png', '.jpeg'];
      
      for (final ext in extensions) {
        final alternativePath = '$basePath$ext';
        if (alternativePath != imageAsset) {
          return alternativePath;
        }
      }
      
      return imageAsset; // Return original as last resort
    }
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
