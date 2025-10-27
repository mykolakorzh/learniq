import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/data_service.dart';
import '../models/topic.dart';
import '../widgets/skeleton_loader.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Topic>>(
        future: DataService.loadTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SkeletonStatCard(),
                  SizedBox(height: 24),
                  SkeletonStatCard(),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to Load Statistics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'There was a problem loading your progress data. Please check your connection and try again.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          final topics = snapshot.data ?? [];

          return FutureBuilder<Map<String, TopicProgress>>(
            future: _loadAllProgress(topics),
            builder: (context, progressSnapshot) {
              if (progressSnapshot.connectionState == ConnectionState.waiting) {
                return const SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SkeletonStatCard(),
                      SizedBox(height: 24),
                      SkeletonStatCard(),
                    ],
                  ),
                );
              }

              final progressMap = progressSnapshot.data ?? {};
              final stats = _calculateStats(topics, progressMap);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Statistics Card
                    _buildOverallStatsCard(stats),

                    const SizedBox(height: 24),

                    // Achievement Card
                    _buildAchievementCard(stats),

                    const SizedBox(height: 24),

                    // Topic Breakdown
                    _buildTopicBreakdown(topics, progressMap),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOverallStatsCard(Map<String, dynamic> stats) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue[700], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Overall Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.school,
                    label: 'Topics',
                    value: '${stats['topicsStudied']}/${stats['totalTopics']}',
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.stars,
                    label: 'Avg Accuracy',
                    value: '${stats['avgAccuracy']}%',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.credit_card,
                    label: 'Cards Total',
                    value: '${stats['totalCards']}',
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.error_outline,
                    label: 'To Review',
                    value: '${stats['cardsToReview']}',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> stats) {
    final avgAccuracy = stats['avgAccuracy'] as int;
    String achievement;
    String message;
    IconData icon;
    Color color;

    if (avgAccuracy >= 90) {
      achievement = 'Master!';
      message = 'Excellent work! You\'re mastering German articles!';
      icon = Icons.emoji_events;
      color = Colors.amber;
    } else if (avgAccuracy >= 75) {
      achievement = 'Great Progress!';
      message = 'You\'re doing really well! Keep it up!';
      icon = Icons.star;
      color = Colors.blue;
    } else if (avgAccuracy >= 50) {
      achievement = 'Good Start!';
      message = 'You\'re making progress! Practice makes perfect.';
      icon = Icons.thumb_up;
      color = Colors.green;
    } else {
      achievement = 'Keep Learning!';
      message = 'Every expert was once a beginner. Keep going!';
      icon = Icons.school;
      color = Colors.orange;
    }

    return Card(
      elevation: 4,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicBreakdown(
    List<Topic> topics,
    Map<String, TopicProgress> progressMap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Topic Breakdown',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...topics.map((topic) {
          final progress = progressMap[topic.id];
          final accuracy = progress?.lastAccuracy ?? 0.0;
          final mistakes = progress?.mistakeIds.length ?? 0;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getAccuracyColor(accuracy).withValues(alpha: 0.2),
                child: Icon(
                  Icons.book,
                  color: _getAccuracyColor(accuracy),
                ),
              ),
              title: Text(
                topic.titleRu,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: accuracy,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(
                      _getAccuracyColor(accuracy),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Accuracy: ${(accuracy * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (mistakes > 0)
                        Text(
                          '$mistakes to review',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              trailing: accuracy > 0
                  ? Icon(
                      Icons.check_circle,
                      color: _getAccuracyColor(accuracy),
                    )
                  : Icon(Icons.circle_outlined, color: Colors.grey[400]),
            ),
          );
        }),
      ],
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.blue;
    if (accuracy >= 0.4) return Colors.orange;
    return Colors.red;
  }

  Future<Map<String, TopicProgress>> _loadAllProgress(List<Topic> topics) async {
    final Map<String, TopicProgress> progressMap = {};
    for (final topic in topics) {
      try {
        final progress = await ProgressService.getProgress(topic.id);
        progressMap[topic.id] = progress;
      } catch (e) {
        // Continue if one topic fails
      }
    }
    return progressMap;
  }

  Map<String, dynamic> _calculateStats(
    List<Topic> topics,
    Map<String, TopicProgress> progressMap,
  ) {
    int topicsStudied = 0;
    double totalAccuracy = 0.0;
    int cardsToReview = 0;
    int totalCards = 0;

    for (final topic in topics) {
      totalCards += topic.cardCount;
      final progress = progressMap[topic.id];
      if (progress != null && progress.lastAccuracy > 0) {
        topicsStudied++;
        totalAccuracy += progress.lastAccuracy;
        cardsToReview += progress.mistakeIds.length;
      }
    }

    final avgAccuracy = topicsStudied > 0
        ? ((totalAccuracy / topicsStudied) * 100).toInt()
        : 0;

    return {
      'topicsStudied': topicsStudied,
      'totalTopics': topics.length,
      'avgAccuracy': avgAccuracy,
      'totalCards': totalCards,
      'cardsToReview': cardsToReview,
    };
  }
}
