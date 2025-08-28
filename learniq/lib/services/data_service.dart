import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/topic.dart';
import '../models/card_item.dart';

class DataService {
  static Future<List<Topic>> loadTopics() async {
    final String response = await rootBundle.loadString('assets/data/topics.json');
    final List<dynamic> jsonList = json.decode(response);
    return jsonList.map((json) => Topic.fromJson(json)).toList();
  }

  static Future<List<CardItem>> loadCards() async {
    final String response = await rootBundle.loadString('assets/data/cards.json');
    final List<dynamic> jsonList = json.decode(response);
    return jsonList.map((json) => CardItem.fromJson(json)).toList();
  }

  static Future<List<CardItem>> loadCardsForTopic(String topicId) async {
    final List<CardItem> allCards = await loadCards();
    return allCards.where((card) => card.topicId == topicId).toList();
  }
}
