import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/topic.dart';
import '../models/card_item.dart';
import '../services/data_service.dart';
import '../services/progress_service.dart';
import '../services/spaced_repetition_service.dart';
import 'learn_screen.dart';
import 'test_screen.dart';
import '../l10n/app_localizations.dart';
import '../widgets/modern_components.dart';
import '../widgets/animations.dart';
import '../core/theme/app_theme.dart';
import '../core/routing/app_router.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  bool _isLoading = true;
  List<CardItem> _previewCards = [];
  TopicProgress? _progress;
  int _dueCardsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final cards = await DataService.loadCardsForTopic(widget.topic.id);
      final progress = await ProgressService.getProgress(widget.topic.id);
      final dueCount = await SpacedRepetitionService.getDueCardsCount(widget.topic.id);

      setState(() {
        _previewCards = cards.take(3).toList(); // Show first 3 cards as preview
        _progress = progress;
        _dueCardsCount = dueCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

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
          child: _isLoading
              ? Center(
                  child: ModernLoadingIndicator(
                    message: l10n.learnLoading,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Modern header
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CustomAnimatedScale(
                              onTap: () => SafeNavigation.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
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
                                    widget.topic.getTitle(locale),
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.topicsCardCount(widget.topic.cardCount),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      if (_dueCardsCount > 0) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryIndigo,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '$_dueCardsCount due',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: widget.topic.isFree
                                    ? AppTheme.accentGreen.withValues(alpha: 0.1)
                                    : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.topic.isFree ? l10n.topicsFree : l10n.topicsPremium,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: widget.topic.isFree ? AppTheme.accentGreen : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Progress Card (if available)
                      if (_progress != null && _progress!.lastAccuracy > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ModernCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ModernSectionHeader(
                                  title: l10n.topicsYourProgress,
                                  icon: Icons.show_chart,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        label: l10n.statsAvgAccuracy,
                                        value: '${(_progress!.lastAccuracy * 100).round()}%',
                                        color: _getAccuracyColor(_progress!.lastAccuracy),
                                        icon: Icons.stars,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildStatItem(
                                        label: l10n.statsToReview,
                                        value: '${_progress!.mistakeIds.length}',
                                        color: AppTheme.dieColor,
                                        icon: Icons.error_outline,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_progress!.mistakeIds.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  ModernButton(
                                    text: l10n.topicsPracticeMistakes,
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TestScreen(
                                            topicId: widget.topic.id,
                                            startMistakesOnly: true,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icons.bolt,
                                    width: double.infinity,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Card Preview Section
                      if (_previewCards.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ModernCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ModernSectionHeader(
                                  title: l10n.topicsPreview,
                                  icon: Icons.photo_library,
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _previewCards.length,
                                    itemBuilder: (context, index) {
                                      final card = _previewCards[index];
                                      return _buildPreviewCard(card);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: StaggeredAnimation(
                          children: [
                            ModernButton(
                              text: l10n.topicsLearn,
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LearnScreen(topicId: widget.topic.id),
                                  ),
                                );
                              },
                              icon: Icons.school,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 16),
                            ModernButton(
                              text: l10n.topicsTest,
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TestScreen(topicId: widget.topic.id),
                                  ),
                                );
                              },
                              icon: Icons.quiz,
                              isPrimary: false,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Mode Descriptions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ModernCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ModernSectionHeader(
                                title: l10n.topicsChooseLearningMode,
                                icon: Icons.lightbulb_outline,
                              ),
                              const SizedBox(height: 16),
                              _buildModeDescription(
                                icon: Icons.school,
                                title: l10n.topicsLearn,
                                subtitle: l10n.topicsLearnSubtitle,
                                color: AppTheme.primaryIndigo,
                              ),
                              const SizedBox(height: 12),
                              _buildModeDescription(
                                icon: Icons.quiz,
                                title: l10n.topicsTest,
                                subtitle: l10n.topicsTestSubtitle,
                                color: AppTheme.accentGreen,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(CardItem card) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.asset(
              card.imageAsset,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.textSecondary.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 32,
                    color: AppTheme.textSecondary,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Text(
                  card.nounDe,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeDescription({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return AppTheme.accentGreen;
    if (accuracy >= 0.6) return Colors.blue;
    if (accuracy >= 0.4) return Colors.orange;
    return AppTheme.dieColor;
  }
}
