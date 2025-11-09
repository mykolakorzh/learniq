import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/data_service.dart';
import '../models/topic.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/modern_components.dart';
import '../widgets/animations.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'dart:math' as math;

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundLight,
              AppTheme.surfaceLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CustomAnimatedScale(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.primaryIndigo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.statsYourProgress,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            l10n.statsSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryIndigo.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.analytics,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Topic>>(
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
                child: ModernErrorWidget(
                  title: l10n.statsErrorTitle,
                  message: l10n.statsErrorMessage,
                  icon: Icons.analytics_outlined,
                  onRetry: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Statistics Card with circular progress
                    StaggeredAnimationItem(
                      index: 0,
                      child: _buildOverallStatsCard(stats, l10n),
                    ),

                    const SizedBox(height: 20),

                    // Achievement Card
                    StaggeredAnimationItem(
                      index: 1,
                      child: _buildAchievementCard(stats, l10n),
                    ),

                    const SizedBox(height: 20),

                    // Topic Breakdown
                    StaggeredAnimationItem(
                      index: 2,
                      child: _buildTopicBreakdown(topics, progressMap, l10n),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStatsCard(Map<String, dynamic> stats, AppLocalizations l10n) {
    final avgAccuracy = stats['avgAccuracy'] as int;
    final accuracyProgress = avgAccuracy / 100.0;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernSectionHeader(
            title: l10n.statsOverall,
            icon: Icons.analytics,
          ),
          const SizedBox(height: 24),

          // Circular progress indicator
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: accuracyProgress),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                        backgroundColor: AppTheme.textSecondary.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation(
                          _getAccuracyColor(accuracyProgress),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: avgAccuracy),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          '$value%',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: _getAccuracyColor(accuracyProgress),
                          ),
                        );
                      },
                    ),
                    Text(
                      l10n.statsAvgAccuracy,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildModernStatItem(
                  icon: Icons.school,
                  label: l10n.statsTopics,
                  value: '${stats['topicsStudied']}/${stats['totalTopics']}',
                  color: AppTheme.primaryIndigo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModernStatItem(
                  icon: Icons.credit_card,
                  label: l10n.statsCardsTotal,
                  value: '${stats['totalCards']}',
                  color: AppTheme.secondaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildModernStatItem(
                  icon: Icons.error_outline,
                  label: l10n.statsToReview,
                  value: '${stats['cardsToReview']}',
                  color: AppTheme.dieColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModernStatItem(
                  icon: Icons.trending_up,
                  label: l10n.statsProgress,
                  value: '${((stats['topicsStudied'] as int) / (stats['totalTopics'] as int) * 100).round()}%',
                  color: AppTheme.accentGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> stats, AppLocalizations l10n) {
    final avgAccuracy = stats['avgAccuracy'] as int;
    String achievement;
    String message;
    IconData icon;
    Gradient gradient;

    if (avgAccuracy >= 90) {
      achievement = l10n.statsMaster;
      message = l10n.statsMasterMessage;
      icon = Icons.emoji_events;
      gradient = const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
      );
    } else if (avgAccuracy >= 75) {
      achievement = l10n.statsGreatProgress;
      message = l10n.statsGreatProgressMessage;
      icon = Icons.star;
      gradient = AppTheme.primaryGradient;
    } else if (avgAccuracy >= 50) {
      achievement = l10n.statsGoodStart;
      message = l10n.statsGoodStartMessage;
      icon = Icons.thumb_up;
      gradient = AppTheme.successGradient;
    } else {
      achievement = l10n.statsKeepLearning;
      message = l10n.statsKeepLearningMessage;
      icon = Icons.school;
      gradient = const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryIndigo.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          AnimatedPulse(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicBreakdown(
    List<Topic> topics,
    Map<String, TopicProgress> progressMap,
    AppLocalizations l10n,
  ) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernSectionHeader(
            title: l10n.statsTopicBreakdown,
            icon: Icons.list,
          ),
          const SizedBox(height: 16),
          ...topics.asMap().entries.map((entry) {
            final index = entry.key;
            final topic = entry.value;
            final progress = progressMap[topic.id];
            final accuracy = progress?.lastAccuracy ?? 0.0;
            final mistakes = progress?.mistakeIds.length ?? 0;

            return StaggeredAnimationItem(
              index: index,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getAccuracyColor(accuracy).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getAccuracyColor(accuracy).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getAccuracyColor(accuracy).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.folder,
                            color: _getAccuracyColor(accuracy),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                topic.titleRu,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (accuracy > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getAccuracyColor(accuracy),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${(accuracy * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.textSecondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              l10n.statsNotStarted,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (accuracy > 0) ...[
                      const SizedBox(height: 12),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: accuracy),
                        duration: Duration(milliseconds: 800 + (index * 100)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: AppTheme.textSecondary.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation(
                                _getAccuracyColor(accuracy),
                              ),
                              minHeight: 6,
                            ),
                          );
                        },
                      ),
                      if (mistakes > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 16,
                              color: AppTheme.dieColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.statsToReviewCount(mistakes),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.dieColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return AppTheme.accentGreen;
    if (accuracy >= 0.6) return AppTheme.primaryIndigo;
    if (accuracy >= 0.4) return Colors.orange;
    return AppTheme.dieColor;
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
