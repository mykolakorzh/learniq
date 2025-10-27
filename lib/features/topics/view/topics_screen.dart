import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../data/topics_repository.dart';
import '../../../services/progress_service.dart';
import '../../../services/subscription_service.dart';
import '../../../shared/models/topic.dart';
import '../../../widgets/modern_components.dart';
import '../../../widgets/animations.dart';
import '../../../core/theme/app_theme.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final _repository = TopicsRepository();
  
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryIndigo.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.appTitle,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'Master German Articles',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, '/statistics');
                        },
                        icon: const Icon(Icons.analytics),
                        color: AppTheme.primaryIndigo,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Topics grid
              Expanded(
                child: FutureBuilder<List<Topic>>(
                  future: _repository.getTopics(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingGrid();
                    }
                    
                    if (snapshot.hasError) {
                      return ModernErrorWidget(
                        title: 'Unable to Load Topics',
                        message: 'Please check your connection and try again.',
                        onRetry: () {
                          setState(() {});
                        },
                      );
                    }
                    
                    final topics = snapshot.data ?? [];
                    
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      color: AppTheme.primaryIndigo,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: topics.length,
                        itemBuilder: (context, index) {
                          final topic = topics[index];
                          return FutureBuilder<TopicProgress>(
                            future: ProgressService.getProgress(topic.id),
                            builder: (context, snap) {
                              final progress = snap.data;
                              final accuracy = progress?.lastAccuracy ?? 0.0;
                              final mistakesCount = progress?.mistakeIds.length ?? 0;

                              return _ModernTopicCard(
                                topic: topic,
                                accuracy01: accuracy,
                                mistakesCount: mistakesCount,
                                l10n: l10n,
                                onTap: () => _navigateToTopic(topic),
                                onPracticeMistakes: mistakesCount > 0
                                    ? () async {
                                        final canAccess = await _checkTopicAccess(topic);
                                        if (!canAccess && context.mounted) {
                                          Navigator.pushNamed(context, '/paywall');
                                          return;
                                        }
                                        if (context.mounted) {
                                          Navigator.pushNamed(context, '/test', arguments: topic.id);
                                        }
                                      }
                                    : null,
                              );
                            },
                          );
                        },
                      ),
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

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _SkeletonTopicCard();
      },
    );
  }
  
  Future<bool> _checkTopicAccess(Topic topic) async {
    if (topic.isFree) {
      return true; // Free topics are always accessible
    }

    final subscriptionService = await SubscriptionService.getInstance();
    return await subscriptionService.hasActiveSubscription();
  }

  Future<void> _navigateToTopic(Topic topic) async {
    // Check if user has access to this topic
    final canAccess = await _checkTopicAccess(topic);

    if (!canAccess && mounted) {
      // Show paywall for locked topics
      Navigator.pushNamed(context, '/paywall');
      return;
    }

    // Show topic options sheet if accessible
    if (mounted) {
      showModalBottomSheet(
        context: context,
        builder: (context) => _TopicOptionsSheet(topicId: topic.id),
      );
    }
  }
}

class _ModernTopicCard extends StatefulWidget {
  const _ModernTopicCard({
    required this.topic,
    required this.accuracy01,
    required this.mistakesCount,
    required this.l10n,
    required this.onTap,
    this.onPracticeMistakes,
  });

  final Topic topic;
  final double accuracy01;
  final int mistakesCount;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final VoidCallback? onPracticeMistakes;

  @override
  State<_ModernTopicCard> createState() => _ModernTopicCardState();
}

class _ModernTopicCardState extends State<_ModernTopicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Animations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: _getTopicGradient(widget.topic),
                boxShadow: [
                  BoxShadow(
                    color: _getTopicGradient(widget.topic).colors.first.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Topic icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getTopicIcon(widget.topic),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Title
                      Text(
                        widget.topic.titleRu,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Card count
                      Text(
                        widget.l10n.topicsCardCount(widget.topic.cardCount),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Progress section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Progress bar
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: widget.accuracy01.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Progress text
                          Text(
                            '${widget.l10n.topicsProgress}: ${(widget.accuracy01 * 100).round()}%',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          
                          if (widget.mistakesCount > 0) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${widget.l10n.topicsMistakes}: ${widget.mistakesCount}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Status and action
                      Row(
                        children: [
                          // Free/Lock status
                          if (widget.topic.isFree)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.l10n.topicsFree,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock_outline,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Premium',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          const Spacer(),
                          
                          // Practice mistakes button
                          if (widget.onPracticeMistakes != null)
                            GestureDetector(
                              onTap: widget.onPracticeMistakes,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.bolt,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Practice',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  LinearGradient _getTopicGradient(Topic topic) {
    final gradients = [
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF10B981), Color(0xFF059669)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
      ),
    ];
    
    return gradients[topic.order % gradients.length];
  }

  IconData _getTopicIcon(Topic topic) {
    final icons = [
      Icons.school,
      Icons.home,
      Icons.restaurant,
      Icons.sports,
      Icons.work,
      Icons.nature,
      Icons.shopping_cart,
      Icons.travel_explore,
    ];
    
    return icons[topic.order % icons.length];
  }
}

class _SkeletonTopicCard extends StatefulWidget {
  @override
  State<_SkeletonTopicCard> createState() => _SkeletonTopicCardState();
}

class _SkeletonTopicCardState extends State<_SkeletonTopicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon skeleton
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Title skeleton
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle skeleton
                Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                
                const Spacer(),
                
                // Progress skeleton
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Progress text skeleton
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopicOptionsSheet extends StatelessWidget {
  const _TopicOptionsSheet({required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.topicsChooseLearningMode,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      Text(l10n.topicsYourProgress),
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
                    '${l10n.topicsMistakes}: $mistakesCount',
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
                            Text(
                              l10n.topicsPracticeMistakes,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              l10n.topicsPracticeMistakesFocus(mistakes.length),
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
            title: l10n.topicsLearn,
            subtitle: l10n.topicsLearnSubtitle,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/learn', arguments: topicId);
            },
          ),
          const SizedBox(height: 16),
          _OptionButton(
            icon: Icons.quiz,
            title: l10n.topicsTest,
            subtitle: l10n.topicsTestSubtitle,
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