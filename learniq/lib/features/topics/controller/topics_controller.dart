import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/topics_repository.dart';
import '../models/topic.dart';

final topicsRepositoryProvider = Provider<TopicsRepository>((ref) {
  return TopicsRepository();
});

final topicsProvider = FutureProvider<List<Topic>>((ref) async {
  final repository = ref.read(topicsRepositoryProvider);
  return await repository.getTopics();
});

final topicProvider = FutureProvider.family<Topic?, String>((ref, topicId) async {
  final repository = ref.read(topicsRepositoryProvider);
  return await repository.getTopicById(topicId);
}); 