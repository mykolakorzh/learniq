import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/card_item.dart';
import '../services/data_service.dart';
import '../services/audio/tts_service.dart';
import '../services/image_service.dart';
import '../services/streak_service.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/modern_components.dart';
import '../widgets/animations.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../core/routing/app_router.dart';

class LearnScreen extends StatefulWidget {
  final String topicId;

  const LearnScreen({super.key, required this.topicId});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late Future<List<CardItem>> _cardsFuture;
  late PageController _pageController;
  int _currentIndex = 0;
  final Set<String> _reviewedCardIds = {}; // Track which cards have been reviewed for streak

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _cardsFuture = DataService.loadCardsForTopic(widget.topicId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) async {
    setState(() {
      _currentIndex = index;
    });
    
    // Preload next 2-3 images for smooth scrolling
    _preloadNextImages(index);
    
    // Record streak when user views a new card (only once per card per session)
    _cardsFuture.then((cards) {
      if (index < cards.length) {
        final cardId = cards[index].id;
        if (!_reviewedCardIds.contains(cardId)) {
          _reviewedCardIds.add(cardId);
          // Record review for streak tracking (only once per card)
          StreakService.recordReview().catchError((e) {
            // Silently handle errors - streak is not critical
            debugPrint('Failed to record streak: $e');
          });
        }
      }
    });
  }

  void _preloadNextImages(int currentIndex) {
    _cardsFuture.then((cards) {
      if (cards.isEmpty) return;
      
      final imagesToPreload = <String>[];
      for (int i = currentIndex + 1; i <= currentIndex + 3 && i < cards.length; i++) {
        final imagePath = cards[i].getImagePathWithFallback();
        if (imagePath.isNotEmpty) {
          imagesToPreload.add(imagePath);
        }
      }
      
      if (imagesToPreload.isNotEmpty) {
        ImageService.preloadImages(imagesToPreload);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: FutureBuilder<List<CardItem>>(
            future: _cardsFuture,
            builder: (context, snapshot) {
              final l10n = AppLocalizations.of(context)!;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ModernLoadingIndicator(
                    message: l10n.learnLoading,
                  ),
                );
              }

              if (snapshot.hasError) {
                return ModernErrorWidget(
                  title: l10n.learnErrorTitle,
                  message: l10n.learnErrorMessage,
                  onRetry: () {
                    setState(() {
                      _cardsFuture = DataService.loadCardsForTopic(widget.topicId);
                    });
                  },
                );
              }

              final cards = snapshot.data!;

              // Preload first few images
              if (cards.isNotEmpty && _currentIndex == 0) {
                final imagesToPreload = cards
                    .take(3)
                    .map((card) => card.getImagePathWithFallback())
                    .where((path) => path.isNotEmpty)
                    .toList();
                if (imagesToPreload.isNotEmpty) {
                  ImageService.preloadImages(imagesToPreload);
                }
                
                // Record first card for streak (if not already recorded)
                if (cards.isNotEmpty && !_reviewedCardIds.contains(cards[0].id)) {
                  _reviewedCardIds.add(cards[0].id);
                  StreakService.recordReview().catchError((e) {
                    debugPrint('Failed to record streak: $e');
                  });
                }
              }

              if (cards.isEmpty) {
                return ModernSuccessWidget(
                  title: l10n.learnNoCardsTitle,
                  message: l10n.learnNoCardsMessage,
                  icon: Icons.inbox_outlined,
                  onContinue: () => SafeNavigation.pop(context),
                );
              }

              if (_currentIndex >= cards.length) {
                return ModernSuccessWidget(
                  title: l10n.learnCongratulations,
                  message: l10n.learnCompletedCards(cards.length),
                  icon: Icons.check_circle,
                  onContinue: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                );
              }

              return Column(
                children: [
                  // Modern header with progress
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
                                l10n.learnModeTitle,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                l10n.learnCardProgress(_currentIndex + 1, cards.length),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryIndigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${((_currentIndex + 1) / cards.length * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryIndigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ModernProgressIndicator(
                      value: (_currentIndex + 1) / cards.length,
                      height: 6,
                      backgroundColor: AppTheme.textSecondary.withValues(alpha: 0.1),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: cards.length,
                      physics: const BouncingScrollPhysics(),
                      cacheExtent: 2, // Limit cache to 2 pages on each side
                      itemBuilder: (context, index) {
                        final currentCard = cards[index];
                        return RepaintBoundary(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _ModernFlashcard(
                              card: currentCard,
                              onFlip: () {
                                // Card flip is handled internally
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Swipe instruction
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.learnSwipeHint,
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getArticleColor(String article) {
    return ArticleColors.getArticleColor(article);
  }
}

class _ModernFlashcard extends StatefulWidget {
  final CardItem card;
  final VoidCallback onFlip;

  const _ModernFlashcard({
    required this.card,
    required this.onFlip,
  });

  @override
  State<_ModernFlashcard> createState() => _ModernFlashcardState();
}

class _ModernFlashcardState extends State<_ModernFlashcard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Animations.medium,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flipCard() {
    HapticFeedback.mediumImpact();
    if (_isFlipped) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isShowingFront = _animation.value < 0.5;
          final rotation = _animation.value * 3.14159;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotation),
            child: isShowingFront ? _buildFront() : _buildBack(),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundLight,
            AppTheme.surfaceLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryIndigo.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.card.getImagePathWithFallback(),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppTheme.textSecondary.withValues(alpha: 0.05),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: AppTheme.primaryIndigo,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.textSecondary.withValues(alpha: 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image not found',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // German word with article and TTS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: ArticleColors.getArticleColor(widget.card.article),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: ArticleColors.getArticleColor(widget.card.article).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.card.article.toUpperCase()} ${widget.card.nounDe}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () async {
                      HapticFeedback.selectionClick();
                      await TTSService.speak('${widget.card.article} ${widget.card.nounDe}');
                    },
                    icon: const Icon(Icons.volume_up_rounded),
                    color: Colors.white,
                    iconSize: 24,
                    tooltip: l10n.learnHearPronunciation,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tap instruction
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryIndigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 16,
                    color: AppTheme.primaryIndigo,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.learnTapToReveal,
                    style: TextStyle(
                      color: AppTheme.primaryIndigo,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryIndigo,
              AppTheme.secondaryPurple,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryIndigo.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Translation
              Text(
                widget.card.getTranslation(locale),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Article info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ArticleColors.getArticleEmoji(widget.card.article),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.card.article.toUpperCase()} ${widget.card.nounDe}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tap instruction
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.learnTapToFlipBack,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
