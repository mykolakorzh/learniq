import 'package:flutter/material.dart';
import '../data/topics_repository.dart';
import '../../../services/progress_service.dart';
import '../../../shared/models/topic.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final _repository = TopicsRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LearnIQ'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Topic>>(
        future: _repository.getTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  const Text('Failed to load topics'),
                ],
              ),
            );
          }
          
          final topics = snapshot.data ?? [];
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return FutureBuilder<TopicProgress>(
                future: ProgressService.getProgress(topic.id),
                builder: (context, snap) {
                  final progress = snap.data;
                  final accuracy = progress?.lastAccuracy ?? 0.0;
                  final mistakesCount = progress?.mistakeIds.length ?? 0;

                  return _TopicCard(
                    topic: topic,
                    accuracy01: accuracy,
                    mistakesCount: mistakesCount,
                    onTap: () => _navigateToTopic(topic.id),
                    onPracticeMistakes: mistakesCount > 0
                        ? () {
                            Navigator.popUntil(context, (r) => r.isFirst);
                            Navigator.pushNamed(context, '/test', arguments: topic.id);
                          }
                        : null,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
  
  void _navigateToTopic(String topicId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _TopicOptionsSheet(topicId: topicId),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.accuracy01,
    required this.mistakesCount,
    required this.onTap,
    this.onPracticeMistakes,
  });

  final Topic topic;
  final double accuracy01;
  final int mistakesCount;
  final VoidCallback onTap;
  final VoidCallback? onPracticeMistakes;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Leading icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      topic.titleRu,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Card count
                    Text(
                      '${topic.cardCount} cards',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        value: accuracy01,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Progress text
                    Text(
                      'Progress: ${(accuracy01 * 100).round()}% · Mistakes: $mistakesCount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Trailing actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Free/Lock status
                  if (topic.isFree) 
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Free',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else 
                    Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  
                  // Practice mistakes button
                  if (onPracticeMistakes != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: onPracticeMistakes,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(0, 32),
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                        child: Text(
                          'Fix mistakes',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicOptionsSheet extends StatelessWidget {
  const _TopicOptionsSheet({required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose Learning Mode',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Progress summary (accuracy + mistakes)
          FutureBuilder<TopicProgress>(
            future: ProgressService.getProgress(topicId),
            builder: (context, snap) {
              final progress = snap.data;
              final accuracy01 = progress?.lastAccuracy ?? 0.0;
              final mistakesCount = progress?.mistakeIds.length ?? 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your progress'),
                      Text('${(accuracy01 * 100).round()}%'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: accuracy01,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Mistakes: $mistakesCount',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          // Practice Mistakes button (if mistakes exist) - Primary button at top
          FutureBuilder<TopicProgress>(
            future: ProgressService.getProgress(topicId),
            builder: (context, snap) {
              final mistakes = snap.data?.mistakeIds ?? const [];
              if (mistakes.isEmpty) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/test', arguments: topicId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Practice Mistakes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Focus on your weak words (${mistakes.length})',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          _OptionButton(
            icon: Icons.school,
            title: 'Learn',
            subtitle: 'Study vocabulary cards',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/learn', arguments: topicId);
            },
          ),
          const SizedBox(height: 16),
          _OptionButton(
            icon: Icons.quiz,
            title: 'Test',
            subtitle: 'Practice with quiz',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/test', arguments: topicId);
            },
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}