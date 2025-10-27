// Temporarily commented out due to missing flutter_riverpod dependency
/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/topics_repository.dart';
import '../models/topic.dart';

final topicsRepositoryProvider = Provider<TopicsRepository>((ref) => TopicsRepository());

final topicsProvider = FutureProvider<List<Topic>>((ref) async {
  final repository = ref.read(topicsRepositoryProvider);
  return repository.getTopics();
});

final topicProvider = FutureProvider.family<Topic?, String>((ref, topicId) async {
  final repository = ref.read(topicsRepositoryProvider);
  final topics = await repository.getTopics();
  return topics.firstWhere((topic) => topic.id == topicId, orElse: () => null);
});
*/