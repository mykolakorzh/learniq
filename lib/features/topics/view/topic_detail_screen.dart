// Temporarily commented out due to missing flutter_riverpod dependency
/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/topic.dart';
import '../../progress/controller/progress_controller.dart';

class TopicDetailScreen extends ConsumerWidget {
  const TopicDetailScreen({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final progress = ref.watch(progressControllerProvider);
    final topicProgress = progress[topic.id];
    
    final accuracy = (topicProgress?['lastAccuracy'] as double?) ?? 0.0;
    final mistakes = (topicProgress?['mistakes'] as List<dynamic>?)?.cast<String>() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(topic.titleRu),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(progressControllerProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Topic info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.titleRu,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${topic.cardCount} ${l10n.cards}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            l10n.progress,
                            '${(accuracy * 100).round()}%',
                            Colors.blue,
                            accuracy,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            l10n.mistakes,
                            '${mistakes.length}',
                            mistakes.isNotEmpty ? Colors.red : Colors.green,
                            null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            _buildActionButton(
              context,
              icon: Icons.school,
              title: l10n.learn,
              subtitle: l10n.learnSubtitle,
              onTap: () {
                Navigator.pushNamed(context, '/learn/${topic.id}');
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              context,
              icon: Icons.quiz,
              title: l10n.test,
              subtitle: l10n.testSubtitle,
              onTap: () {
                Navigator.pushNamed(context, '/test/${topic.id}');
              },
            ),
            if (mistakes.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildActionButton(
                context,
                icon: Icons.bolt,
                title: l10n.practiceMistakes,
                subtitle: l10n.practiceMistakesSubtitle,
                onTap: () {
                  Navigator.pushNamed(context, '/test/${topic.id}', arguments: {'mistakesOnly': true});
                },
                isPrimary: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    double? progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Theme.of(context).primaryColor : null,
          foregroundColor: isPrimary ? Colors.white : null,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isPrimary ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isPrimary ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isPrimary ? Colors.white70 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
*/