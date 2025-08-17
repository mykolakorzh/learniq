import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../controller/topics_controller.dart';
import '../controller/progress_controller.dart';
import '../models/topic.dart';

class TopicDetailScreen extends ConsumerWidget {
  final String topicId;

  const TopicDetailScreen({
    super.key,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicAsync = ref.watch(topicProvider(topicId));

    return Scaffold(
      appBar: AppBar(
        title: Text('topic_detail.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: topicAsync.when(
        data: (topic) {
          if (topic == null) {
            return Center(
              child: Text('topic_detail.not_found'.tr()),
            );
          }

          return _buildTopicDetail(context, ref, topic);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('topic_detail.error'.tr()),
        ),
      ),
    );
  }

  Widget _buildTopicDetail(
    BuildContext context,
    WidgetRef ref,
    Topic topic,
  ) {
    final progressController = ref.watch(progressControllerProvider.notifier);
    final lastAccuracy = progressController.getLastAccuracy(topicId);
    final mistakes = progressController.getMistakes(topicId);
    final hasMistakes = mistakes.isNotEmpty;
    final percent = (lastAccuracy * 100).round();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.book, color: Colors.grey, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.getTitle(context.locale.languageCode),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'topic_detail.cards_count'.tr(args: [topic.cardCount.toString()]),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Accuracy label
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: lastAccuracy >= 0.9 ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: lastAccuracy >= 0.9 ? Colors.green.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'topic_detail.accuracy_label'.tr(args: [percent.toString()]),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: lastAccuracy >= 0.9 ? Colors.green : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action buttons
          if (!topic.isFree) ...[
            // Locked topic - show unlock button
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.lock,
                      size: 48,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'topic_detail.locked_message'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/paywall');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('topic_detail.unlock'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Free topic - action buttons
            Text(
              'topic_detail.actions'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Learn button (enabled if topic.isFree)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: topic.isFree ? () {
                  context.go('/learn/$topicId');
                } : null,
                icon: const Icon(Icons.school),
                label: Text('topic_detail.learn'.tr()),
              ),
            ),
            const SizedBox(height: 12),
            
            // Test button (enabled if topic.isFree)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: topic.isFree ? () {
                  context.go('/test/$topicId');
                } : null,
                icon: const Icon(Icons.quiz),
                label: Text('topic_detail.test'.tr()),
              ),
            ),
            const SizedBox(height: 12),
            
            // Retry mistakes button (enabled if topic.isFree and mistakes not empty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (topic.isFree && hasMistakes) ? () {
                  // TODO: Implement retry mistakes
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('topic_detail.retry_mistakes_coming_soon'.tr())),
                  );
                } : null,
                icon: const Icon(Icons.refresh),
                label: Text('topic_detail.retry_mistakes'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 