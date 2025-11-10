import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/topic.dart';
import '../models/card_item.dart';

class DataService {
  // Cache for loaded data
  static List<Topic>? _cachedTopics;
  static List<CardItem>? _cachedCards;
  static Map<String, List<CardItem>> _cachedCardsByTopic = {};

  /// Loads all topics from JSON, with caching
  static Future<List<Topic>> loadTopics() async {
    if (_cachedTopics != null) {
      return _cachedTopics!;
    }

    final String response = await rootBundle.loadString('assets/data/topics.json');
    final List<dynamic> jsonList = json.decode(response);
    _cachedTopics = jsonList.map((json) => Topic.fromJson(json)).toList();
    return _cachedTopics!;
  }

  /// Loads all cards from JSON, with caching
  static Future<List<CardItem>> loadCards() async {
    if (_cachedCards != null) {
      return _cachedCards!;
    }

    final String response = await rootBundle.loadString('assets/data/cards.json');
    final List<dynamic> jsonList = json.decode(response);
    _cachedCards = jsonList.map((json) => CardItem.fromJson(json)).toList();
    return _cachedCards!;
  }

  /// Loads cards for a specific topic, with caching
  /// This is much more efficient than loading all 190 cards every time
  static Future<List<CardItem>> loadCardsForTopic(String topicId) async {
    // Check if already cached
    if (_cachedCardsByTopic.containsKey(topicId)) {
      return _cachedCardsByTopic[topicId]!;
    }

    // Load all cards once (this will be cached after first call)
    final List<CardItem> allCards = await loadCards();

    // Filter and cache for this topic
    final topicCards = allCards.where((card) => card.topicId == topicId).toList();
    _cachedCardsByTopic[topicId] = topicCards;

    return topicCards;
  }

  /// Clears all cached data (useful for testing or if data changes)
  static void clearCache() {
    _cachedTopics = null;
    _cachedCards = null;
    _cachedCardsByTopic.clear();
  }
}
