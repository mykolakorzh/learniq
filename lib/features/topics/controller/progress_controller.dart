// Temporarily commented out due to missing flutter_riverpod dependency
/*
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressController extends StateNotifier<Map<String, Map<String, dynamic>>> {
  ProgressController() : super({});

  double getLastAccuracy(String topicId) {
    final topicData = state[topicId];
    if (topicData == null) return 0.0;
    return (topicData['lastAccuracy'] as double?) ?? 0.0;
  }

  List<String> getMistakes(String topicId) {
    final topicData = state[topicId];
    if (topicData == null) return [];
    final mistakes = topicData['mistakes'] as List<dynamic>?;
    return mistakes?.cast<String>() ?? [];
  }

  void setLastAccuracy(String topicId, double value) {
    // Clamp value between 0.0 and 1.0
    final clampedValue = value.clamp(0.0, 1.0);
    
    final currentData = state[topicId] ?? {};
    final updatedData = Map<String, dynamic>.from(currentData);
    updatedData['lastAccuracy'] = clampedValue;
    
    state = {...state, topicId: updatedData};
  }

  void setMistakes(String topicId, List<String> ids) {
    final currentData = state[topicId] ?? {};
    final updatedData = Map<String, dynamic>.from(currentData);
    updatedData['mistakes'] = List<String>.from(ids);
    
    state = {...state, topicId: updatedData};
  }

  bool isLearned(String topicId) => getLastAccuracy(topicId) >= 0.9;
}

final progressControllerProvider = StateNotifierProvider<ProgressController, Map<String, Map<String, dynamic>>>(
  (ref) => ProgressController(),
);
*/