import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/topic.dart';
import '../models/card_item.dart';

/// Custom exception for data loading errors
class DataLoadException implements Exception {
  final String message;
  final String? file;
  
  DataLoadException(this.message, [this.file]);
  
  @override
  String toString() => 'DataLoadException: $message${file != null ? ' (file: $file)' : ''}';
}

class DataService {
  // Cache for loaded data
  static List<Topic>? _cachedTopics;
  static List<CardItem>? _cachedCards;
  static Map<String, List<CardItem>> _cachedCardsByTopic = {};

  /// Loads all topics from JSON, with caching and error handling
  static Future<List<Topic>> loadTopics() async {
    if (_cachedTopics != null) {
      return _cachedTopics!;
    }

    try {
      final String response = await rootBundle.loadString('assets/data/topics.json');
      final dynamic decoded = json.decode(response);
      
      // Validate JSON structure
      if (decoded is! List) {
        throw DataLoadException('Topics data must be a JSON array', 'topics.json');
      }
      
      final List<Topic> topics = [];
      for (int i = 0; i < decoded.length; i++) {
        try {
          final item = decoded[i];
          if (item is! Map<String, dynamic>) {
            continue; // Skip invalid items
          }
          topics.add(Topic.fromJson(item));
        } catch (e) {
          // Log invalid topic but continue loading others
          try {
            FirebaseCrashlytics.instance.recordError(
              Exception('Invalid topic at index $i: $e'),
              StackTrace.current,
              reason: 'Failed to parse topic',
              fatal: false,
            );
          } catch (_) {
            // Firebase not initialized - ignore
          }
        }
      }
      
      if (topics.isEmpty) {
        throw DataLoadException('No valid topics found in data file', 'topics.json');
      }
      
      _cachedTopics = topics;
      return topics;
    } on PlatformException catch (e) {
      throw DataLoadException('Failed to load topics.json: ${e.message}', 'topics.json');
    } on FormatException catch (e) {
      throw DataLoadException('Invalid JSON format in topics.json: ${e.message}', 'topics.json');
    } catch (e) {
      try {
        FirebaseCrashlytics.instance.recordError(
          e,
          StackTrace.current,
          reason: 'Unexpected error loading topics',
          fatal: false,
        );
      } catch (_) {
        // Firebase not initialized - ignore
      }
      throw DataLoadException('Unexpected error loading topics: $e', 'topics.json');
    }
  }

  /// Loads all cards from JSON, with caching and error handling
  static Future<List<CardItem>> loadCards() async {
    if (_cachedCards != null) {
      return _cachedCards!;
    }

    try {
      final String response = await rootBundle.loadString('assets/data/cards.json');
      final dynamic decoded = json.decode(response);
      
      // Validate JSON structure
      if (decoded is! List) {
        throw DataLoadException('Cards data must be a JSON array', 'cards.json');
      }
      
      final List<CardItem> cards = [];
      final List<String> invalidCards = [];
      
      for (int i = 0; i < decoded.length; i++) {
        try {
          final item = decoded[i];
          if (item is! Map<String, dynamic>) {
            continue; // Skip invalid items
          }
          
          final card = CardItem.fromJson(item);
          
          // Validate card has required fields
          if (!card.isValid()) {
            invalidCards.add(card.id);
            try {
              FirebaseCrashlytics.instance.recordError(
                Exception('Card ${card.id} has invalid image path: ${card.imageAsset}'),
                StackTrace.current,
                reason: 'Card validation failed',
                fatal: false,
              );
            } catch (_) {
              // Firebase not initialized - ignore
            }
            continue; // Skip invalid cards
          }
          
          cards.add(card);
        } catch (e) {
          // Log invalid card but continue loading others
          try {
            FirebaseCrashlytics.instance.recordError(
              Exception('Invalid card at index $i: $e'),
              StackTrace.current,
              reason: 'Failed to parse card',
              fatal: false,
            );
          } catch (_) {
            // Firebase not initialized - ignore
          }
        }
      }
      
      // Log summary of invalid cards
      if (invalidCards.isNotEmpty) {
        try {
          FirebaseCrashlytics.instance.log(
            'Loaded ${cards.length} valid cards, ${invalidCards.length} invalid cards skipped: ${invalidCards.join(", ")}',
          );
        } catch (_) {
          // Firebase not initialized - ignore
        }
      }
      
      if (cards.isEmpty) {
        throw DataLoadException('No valid cards found in data file', 'cards.json');
      }
      
      _cachedCards = cards;
      return cards;
    } on PlatformException catch (e) {
      throw DataLoadException('Failed to load cards.json: ${e.message}', 'cards.json');
    } on FormatException catch (e) {
      throw DataLoadException('Invalid JSON format in cards.json: ${e.message}', 'cards.json');
    } catch (e) {
      try {
        FirebaseCrashlytics.instance.recordError(
          e,
          StackTrace.current,
          reason: 'Unexpected error loading cards',
          fatal: false,
        );
      } catch (_) {
        // Firebase not initialized - ignore
      }
      throw DataLoadException('Unexpected error loading cards: $e', 'cards.json');
    }
  }

  /// Loads cards for a specific topic, with caching
  /// This is much more efficient than loading all 190 cards every time
  static Future<List<CardItem>> loadCardsForTopic(String topicId) async {
    // Check if already cached
    if (_cachedCardsByTopic.containsKey(topicId)) {
      return _cachedCardsByTopic[topicId]!;
    }

    try {
      // Load all cards once (this will be cached after first call)
      final List<CardItem> allCards = await loadCards();

      // Filter and cache for this topic
      final topicCards = allCards.where((card) => card.topicId == topicId).toList();
      _cachedCardsByTopic[topicId] = topicCards;

      return topicCards;
    } catch (e) {
      // Re-throw with context
      throw DataLoadException('Failed to load cards for topic $topicId: $e', 'cards.json');
    }
  }

  /// Clears all cached data (useful for testing or if data changes)
  static void clearCache() {
    _cachedTopics = null;
    _cachedCards = null;
    _cachedCardsByTopic.clear();
  }

  /// Validates data integrity - checks for common issues
  /// Returns a list of validation errors (empty if all valid)
  static Future<List<String>> validateDataIntegrity() async {
    final errors = <String>[];
    
    try {
      final topics = await loadTopics();
      final cards = await loadCards();
      
      // Check topic counts match
      for (final topic in topics) {
        final topicCards = cards.where((c) => c.topicId == topic.id).toList();
        if (topicCards.length != topic.cardCount) {
          errors.add(
            'Topic ${topic.id}: Expected ${topic.cardCount} cards, found ${topicCards.length}',
          );
        }
      }
      
      // Check for cards with invalid image paths
      final invalidCards = cards.where((c) => !c.isValid()).toList();
      if (invalidCards.isNotEmpty) {
        errors.add(
          'Found ${invalidCards.length} cards with invalid image paths: ${invalidCards.map((c) => c.id).join(", ")}',
        );
      }
      
      // Check for orphaned cards (cards without matching topic)
      final topicIds = topics.map((t) => t.id).toSet();
      final orphanedCards = cards.where((c) => !topicIds.contains(c.topicId)).toList();
      if (orphanedCards.isNotEmpty) {
        errors.add(
          'Found ${orphanedCards.length} orphaned cards: ${orphanedCards.map((c) => c.id).join(", ")}',
        );
      }
      
    } catch (e) {
      errors.add('Failed to validate data: $e');
    }
    
    return errors;
  }
}
