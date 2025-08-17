import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../controller/topics_controller.dart';
import '../controller/progress_controller.dart';
import 'topic_card.dart';

class TopicsScreen extends ConsumerWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsAsync = ref.watch(topicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('topics.title'.tr()),
      ),
      body: topicsAsync.when(
        data: (topics) {
          if (topics.isEmpty) {
            return Center(
              child: Text('topics.empty'.tr()),
            );
          }

          // Sort: isFree desc, then order asc
          final sortedTopics = List.from(topics)
            ..sort((a, b) {
              if (a.isFree != b.isFree) {
                return b.isFree ? 1 : -1; // Free topics first (desc)
              }
              return a.order.compareTo(b.order); // Then by order asc
            });

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: sortedTopics.length,
            itemBuilder: (context, index) {
              final topic = sortedTopics[index];
              return TopicCard(topic: topic);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('topics.error'.tr()),
        ),
      ),
    );
  }
} 