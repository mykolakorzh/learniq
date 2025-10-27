import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../models/card_item.dart';
import '../services/data_service.dart';
import '../services/progress_service.dart';
import '../services/audio/tts_service.dart';
import '../widgets/modern_components.dart';
import '../widgets/animations.dart';
import '../core/theme/app_theme.dart';

class TestScreen extends StatefulWidget {
  final String topicId;
  final bool startMistakesOnly;

  const TestScreen({super.key, required this.topicId, this.startMistakesOnly = false});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<CardItem> _quizCards = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _isQuizComplete = false;
  final List<String> _mistakes = [];
  final List<CardItem> _mistakeCards = [];
  bool _isLoading = true;
  String? _selectedArticle;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isMistakesOnlyMode = false;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final cards = await DataService.loadCardsForTopic(widget.topicId);
      // If starting mistakes-only, load mistake cards first
      if (widget.startMistakesOnly) {
        final progress = await ProgressService.getProgress(widget.topicId);
        final mistakeIds = progress.mistakeIds;
        final mistakeCards = cards.where((c) => mistakeIds.contains(c.id)).toList();
        setState(() {
          _quizCards = (mistakeCards.isNotEmpty ? mistakeCards : cards)..shuffle();
          _isMistakesOnlyMode = mistakeCards.isNotEmpty;
          _isLoading = false;
        });
      } else {
        setState(() {
          _quizCards = cards..shuffle();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onArticleDropped(String article) {
    if (_showResult) return;

    setState(() {
      _selectedArticle = article;
      _showResult = true;

      final currentCard = _quizCards[_currentQuestionIndex];
      _isCorrect = article == currentCard.article;

      if (_isCorrect) {
        _correctAnswers++;
        _showConfetti = true;
        // Success haptic feedback
        HapticFeedback.mediumImpact();
        // Hide confetti after animation
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showConfetti = false;
            });
          }
        });
      } else {
        _mistakes.add('${currentCard.nounDe} - ${currentCard.article}');
        if (!_mistakeCards.any((c) => c.id == currentCard.id)) {
          _mistakeCards.add(currentCard);
        }
        // Error haptic feedback
        HapticFeedback.vibrate();
      }
    });

    // Auto-advance after showing result
    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  Future<void> _nextQuestion() async {
    if (_currentQuestionIndex < _quizCards.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedArticle = null;
        _showResult = false;
        _isCorrect = false;
        _showConfetti = false;
      });
    } else {
      // Persist progress
      final total = _quizCards.isEmpty ? 1 : _quizCards.length;
      final accuracy01 = _correctAnswers / total;
      try {
        await ProgressService.setAccuracy(widget.topicId, accuracy01);
        await ProgressService.setMistakes(
          widget.topicId,
          _mistakeCards.map((c) => c.id).toList(),
        );
      } catch (_) {}

      if (mounted) {
        setState(() {
          _isQuizComplete = true;
        });
      }
    }
  }


  void _retryMistakesOnly() {
    if (_mistakeCards.isEmpty) return;
    
    setState(() {
      _quizCards = List.from(_mistakeCards)..shuffle();
      _mistakeCards.clear();
      _mistakes.clear();
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _isQuizComplete = false;
      _selectedArticle = null;
      _showResult = false;
      _isCorrect = false;
      _isMistakesOnlyMode = true;
      _showConfetti = false;
    });
  }

  String _getGrayImagePath(String originalPath) {
    // Convert regular image path to gray version
    final fileName = originalPath.split('/').last;
    final nameWithoutExt = fileName.split('.').first;
    final extension = fileName.split('.').last;
    final directory = originalPath.substring(0, originalPath.lastIndexOf('/'));
    return '$directory/${nameWithoutExt}_gray.$extension';
  }

  Color _getArticleColor(String article) {
    return ArticleColors.getArticleColor(article);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
          child: const Center(
            child: ModernLoadingIndicator(
              message: 'Loading test cards...',
            ),
          ),
        ),
      );
    }

    if (_quizCards.isEmpty) {
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
          child: ModernErrorWidget(
            title: 'No Cards Available',
            message: 'No cards available for this topic.',
            icon: Icons.inbox_outlined,
          ),
        ),
      );
    }

    if (_isQuizComplete) {
      final accuracy = (_correctAnswers / _quizCards.length * 100).round();
      final hasMistakes = _mistakes.isNotEmpty;
      
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      AnimatedScale(
                        onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
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
                            Icons.home,
                            color: AppTheme.primaryIndigo,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _isMistakesOnlyMode ? 'Review Complete!' : 'Test Complete!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Success icon with animation
                        AnimatedPulse(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: accuracy >= 80
                                  ? AppTheme.successGradient
                                  : const LinearGradient(
                                      colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
                                    ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (accuracy >= 80 ? AppTheme.accentGreen : Colors.orange).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              accuracy >= 80 ? Icons.check_circle : Icons.emoji_events,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Score card
                        ModernCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                '$_correctAnswers / ${_quizCards.length}',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Accuracy: $accuracy%',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: accuracy >= 80 
                                      ? AppTheme.accentGreen
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Action buttons
                  Column(
                    children: [
                      if (hasMistakes && !_isMistakesOnlyMode) ...[
                        ModernButton(
                          text: 'Practice Mistakes (${_mistakes.length})',
                          onPressed: _retryMistakesOnly,
                          icon: Icons.bolt,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      ModernButton(
                        text: 'Go Home',
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        isPrimary: false,
                        icon: Icons.home,
                        width: double.infinity,
                      ),
                    ],
                  ),
                  
                  if (_mistakes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    ModernCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mistakes to Review:',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              itemCount: _mistakes.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.close,
                                        color: AppTheme.dieColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _mistakes[index],
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    final currentCard = _quizCards[_currentQuestionIndex];
    final grayImagePath = _getGrayImagePath(currentCard.imageAsset);
    final colorfulImagePath = currentCard.imageAsset;

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
                    AnimatedScale(
                      onTap: () => Navigator.pop(context),
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
                            'Test Mode',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '${_currentQuestionIndex + 1} of ${_quizCards.length} questions',
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
                        color: AppTheme.primaryIndigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${((_currentQuestionIndex + 1) / _quizCards.length * 100).round()}%',
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
                  value: (_currentQuestionIndex + 1) / _quizCards.length,
                  height: 6,
                  backgroundColor: AppTheme.textSecondary.withOpacity(0.1),
                ),
              ),

              const SizedBox(height: 20),

              // Image
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryIndigo.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          _showResult && _isCorrect ? colorfulImagePath : grayImagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppTheme.textSecondary.withOpacity(0.1),
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: AppTheme.textSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Drag and drop area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ModernCard(
                  child: Column(
                    children: [
                      Text(
                        'Drag the correct article:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Drop target
                          DragTarget<String>(
                            onAcceptWithDetails: (details) => _onArticleDropped(details.data),
                            builder: (context, candidateData, rejectedData) {
                              return AnimatedContainer(
                                duration: Animations.fast,
                                width: 80,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: _selectedArticle != null 
                                      ? ArticleColors.getArticleColor(_selectedArticle!)
                                      : AppTheme.textSecondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: candidateData.isNotEmpty 
                                        ? AppTheme.primaryIndigo
                                        : AppTheme.textSecondary.withOpacity(0.3),
                                    width: candidateData.isNotEmpty ? 3 : 2,
                                  ),
                                  boxShadow: candidateData.isNotEmpty ? [
                                    BoxShadow(
                                      color: AppTheme.primaryIndigo.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ] : null,
                                ),
                                child: Center(
                                  child: _selectedArticle != null
                                      ? Text(
                                          _selectedArticle!.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          '___',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: AppTheme.textSecondary.withOpacity(0.5),
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          
                          const SizedBox(width: 20),

                          // German word with TTS button
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentCard.nounDe,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              AnimatedScale(
                                onTap: () async {
                                  HapticFeedback.selectionClick();
                                  await TTSService.speak(currentCard.nounDe);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryIndigo.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.volume_up_rounded,
                                    color: AppTheme.primaryIndigo,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Draggable articles
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Choose from:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['der', 'die', 'das'].map((article) {
                          final isUsed = _selectedArticle == article;
                          
                          return Draggable<String>(
                            data: article,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: ArticleColors.getArticleColor(article),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    article.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.textSecondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.drag_indicator,
                                  color: AppTheme.textSecondary,
                                  size: 32,
                                ),
                              ),
                            ),
                            child: AnimatedOpacity(
                              duration: Animations.fast,
                              opacity: isUsed ? 0.3 : 1.0,
                              child: AnimatedScale(
                                scale: isUsed ? 0.9 : 1.0,
                                duration: Animations.fast,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: ArticleColors.getArticleColor(article),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ArticleColors.getArticleColor(article).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      article.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
      // Result overlay
      bottomSheet: _showResult
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: AnimatedSlide(
                offset: const Offset(0, 1),
                show: _showResult,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isCorrect 
                        ? AppTheme.accentGreen.withOpacity(0.1)
                        : AppTheme.dieColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.close,
                        color: _isCorrect ? AppTheme.accentGreen : AppTheme.dieColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isCorrect ? 'Correct!' : 'Incorrect!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isCorrect 
                              ? AppTheme.accentGreen
                              : AppTheme.dieColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}