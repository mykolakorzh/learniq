import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../../shared/models/topic.dart';
import '../../../shared/models/card_item.dart';

class TopicsRepository {
  static const String _topicsAssetPath = 'assets/data/topics.json';
  static const String _cardsAssetPath = 'assets/data/cards.json';

  List<Topic>? _topics;
  List<CardItem>? _cards;

  Future<List<Topic>> getTopics() async {
    if (_topics != null) return _topics!;

    try {
      final String jsonString = await rootBundle.loadString(_topicsAssetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      _topics = jsonList.map((json) => Topic.fromJson(json)).toList();

      // TODO: Implement premium gating after subscription system is set up
      // For now, all topics are free

      // Sort by order
      _topics!.sort((a, b) => a.order.compareTo(b.order));
      
      return _topics!;
    } catch (e) {
      debugPrint('Error loading topics: $e');
      return [];
    }
  }

  Future<List<CardItem>> getCardsByTopic(String topicId) async {
    if (_cards == null) {
      try {
        final String jsonString = await rootBundle.loadString(_cardsAssetPath);
        final List<dynamic> jsonList = json.decode(jsonString);
        _cards = jsonList.map((json) => CardItem.fromJson(json)).toList();
      } catch (e) {
        debugPrint('Error loading cards: $e');
        return [];
      }
    }

    return _cards!.where((card) => card.topicId == topicId).toList();
  }

  Future<Topic?> getTopicById(String topicId) async {
    final topics = await getTopics();
    try {
      return topics.firstWhere((topic) => topic.id == topicId);
    } catch (e) {
      return null;
    }
  }
} 