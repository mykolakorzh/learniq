import 'package:flutter/material.dart';
import '../data/topics_repository.dart';
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
              return _TopicCard(
                topic: topic,
                onTap: () => _navigateToTopic(topic.id),
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
    required this.onTap,
  });

  final Topic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
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
        title: Text(topic.titleRu),
        subtitle: Text('${topic.cardCount} cards'),
        trailing: topic.isFree 
            ? const Chip(label: Text('Free'))
            : const Icon(Icons.lock_outline),
        onTap: onTap,
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