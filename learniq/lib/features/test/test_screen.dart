import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../topics/controller/topics_controller.dart';
import '../topics/controller/progress_controller.dart';
import '../topics/models/card_item.dart';
import '../topics/models/topic.dart';

class TestScreen extends ConsumerStatefulWidget {
  final String topicId;

  const TestScreen({
    super.key,
    required this.topicId,
  });

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen>
    with TickerProviderStateMixin {
  // Removed unused field
  late Future<Topic?> _topicFuture;
  List<CardItem> _quizCards = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _isQuizComplete = false;
  List<String> _mistakes = [];
  bool _isLoading = true;

  // Animation controllers
  late AnimationController _imageAnimationController;
  late AnimationController _shakeAnimationController;
  late AnimationController _confettiController;
  late AnimationController _chipAnimationController;

  // Animation values
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _chipBounceAnimation;

  // State variables
  String? _selectedArticle;
  bool _isAnimating = false;
  bool _showConfetti = false;
  bool _isImageColored = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _imageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _chipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _imageScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeAnimationController,
      curve: Curves.elasticIn,
    ));

    _chipBounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _chipAnimationController,
      curve: Curves.bounceOut,
    ));
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _shakeAnimationController.dispose();
    _confettiController.dispose();
    _chipAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final cards = await ref.read(topicsRepositoryProvider).getCardsByTopic(widget.topicId);
      final topic = await ref.read(topicsRepositoryProvider).getTopicById(widget.topicId);
      
      // Shuffle cards for random quiz order
      final shuffledCards = List<CardItem>.from(cards)..shuffle();
      // Take first 10 cards for the quiz
      _quizCards = shuffledCards.take(10).toList();
      
      setState(() {
        _topicFuture = Future.value(topic);
        _isLoading = false;
      });
      
      // Start chip animation
      _chipAnimationController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading quiz: $e')),
        );
      }
    }
  }

  void _handleArticleDrop(String droppedArticle) {
    if (_isAnimating) return;
    
    final currentCard = _quizCards[_currentQuestionIndex];
    final isCorrect = currentCard.article.name.toLowerCase() == droppedArticle.toLowerCase();
    
    setState(() {
      _selectedArticle = droppedArticle;
      _isAnimating = true;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    if (isCorrect) {
      _handleCorrectAnswer();
    } else {
      _handleIncorrectAnswer();
    }
  }

  void _handleCorrectAnswer() async {
    _correctAnswers++;
    
    // Start image color animation
    setState(() {
      _isImageColored = true;
      _showConfetti = true;
    });
    
    _imageAnimationController.forward();
    _confettiController.forward();
    
    // Auto-advance after animation
    await Future.delayed(const Duration(milliseconds: 700));
    _advanceToNextQuestion();
  }

  void _handleIncorrectAnswer() async {
    _mistakes.add(_quizCards[_currentQuestionIndex].id);
    
    // Shake animation
    _shakeAnimationController.forward();
    
    // Show correct answer briefly
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _selectedArticle = _quizCards[_currentQuestionIndex].article.name;
    });
    
    // Auto-advance after showing correct answer
    await Future.delayed(const Duration(milliseconds: 1200));
    _advanceToNextQuestion();
  }

  void _advanceToNextQuestion() {
    if (_currentQuestionIndex < _quizCards.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedArticle = null;
        _isAnimating = false;
        _isImageColored = false;
        _showConfetti = false;
      });
      
      // Reset animations
      _imageAnimationController.reset();
      _shakeAnimationController.reset();
      _confettiController.reset();
      _chipAnimationController.reset();
      
      // Start chip animation for new question
      _chipAnimationController.forward();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    final accuracy = _correctAnswers / _quizCards.length;
    
    // Save progress
    ref.read(progressControllerProvider.notifier).setLastAccuracy(widget.topicId, accuracy);
    ref.read(progressControllerProvider.notifier).setMistakes(widget.topicId, _mistakes);
    
    setState(() {
      _isQuizComplete = true;
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _mistakes = [];
      _isQuizComplete = false;
      _selectedArticle = null;
      _isAnimating = false;
      _isImageColored = false;
      _showConfetti = false;
    });
    
    // Reset animations
    _imageAnimationController.reset();
    _shakeAnimationController.reset();
    _confettiController.reset();
    _chipAnimationController.reset();
    
    _loadData();
  }

  Color _getArticleColor(String article) {
    switch (article.toLowerCase()) {
      case 'der':
        return const Color(0xFF1976D2); // Blue
      case 'die':
        return const Color(0xFFE53935); // Red
      case 'das':
        return const Color(0xFF43A047); // Green
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('test.title'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/topic/${widget.topicId}'),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_quizCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('test.title'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/topic/${widget.topicId}'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No cards available for this topic',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Topic?>(
          future: _topicFuture,
          builder: (context, snapshot) {
            final topicTitle = snapshot.data?.getTitle(context.locale.languageCode) ?? 'Test';
            return Text('$topicTitle - Test');
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/topic/${widget.topicId}'),
        ),
      ),
      body: _isQuizComplete ? _buildResultsScreen() : _buildDragDropQuizScreen(),
    );
  }

  Widget _buildDragDropQuizScreen() {
    final currentCard = _quizCards[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _quizCards.length;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                '${_currentQuestionIndex + 1}/${_quizCards.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              
              // Grayscale Image
              Expanded(
                flex: 3,
                child: AnimatedBuilder(
                  animation: _imageScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _imageScaleAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                                                         BoxShadow(
                               color: Colors.black.withValues(alpha: 0.1),
                               blurRadius: 8,
                               offset: const Offset(0, 4),
                             ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ColorFiltered(
                            colorFilter: _isImageColored
                                ? const ColorFilter.matrix([
                                    1, 0, 0, 0, 0,
                                    0, 1, 0, 0, 0,
                                    0, 0, 1, 0, 0,
                                    0, 0, 0, 1, 0,
                                  ])
                                : const ColorFilter.matrix([
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0.2126, 0.7152, 0.0722, 0, 0,
                                    0, 0, 0, 1, 0,
                                  ]),
                            child: Image.asset(
                              currentCard.imageAsset,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // German Noun + Drop Zone
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // German Noun
                    Text(
                      currentCard.nounDe,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Drop Zone
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            _shakeAnimation.value * 10 * (_shakeAnimation.value > 0.5 ? -1 : 1),
                            0,
                          ),
                          child: Container(
                            height: 80,
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedArticle != null
                                    ? _getArticleColor(_selectedArticle!)
                                    : Colors.grey[400]!,
                                width: _selectedArticle != null ? 3 : 2,
                                style: _selectedArticle != null ? BorderStyle.solid : BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              color: _selectedArticle != null
                                  ? _getArticleColor(_selectedArticle!).withValues(alpha: 0.1)
                                  : Colors.transparent,
                            ),
                                                         child: DragTarget<String>(
                               onWillAcceptWithDetails: (details) => _selectedArticle == null && !_isAnimating,
                               onAcceptWithDetails: (details) => _handleArticleDrop(details.data),
                              builder: (context, candidateData, rejectedData) {
                                return Center(
                                  child: _selectedArticle != null
                                      ? Text(
                                          _selectedArticle!.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: _getArticleColor(_selectedArticle!),
                                          ),
                                        )
                                      : Text(
                                          'Drop article here',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Draggable Article Chips
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _chipBounceAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_chipBounceAnimation.value * 0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['der', 'die', 'das'].map((article) {
                          return Draggable<String>(
                            data: article,
                            feedback: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getArticleColor(article),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    article.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(
                              width: 80,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  article.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (_selectedArticle == null && !_isAnimating) {
                                  _handleArticleDrop(article);
                                }
                              },
                              child: Container(
                                width: 80,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getArticleColor(article),
                                  borderRadius: BorderRadius.circular(25),
                                                                     boxShadow: [
                                     BoxShadow(
                                       color: _getArticleColor(article).withValues(alpha: 0.3),
                                       blurRadius: 8,
                                       offset: const Offset(0, 4),
                                     ),
                                   ],
                                ),
                                child: Center(
                                  child: Text(
                                    article.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Confetti overlay
        if (_showConfetti)
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/confetti.json',
              controller: _confettiController,
              onLoaded: (composition) {
                _confettiController.duration = composition.duration;
              },
            ),
          ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    final accuracy = _correctAnswers / _quizCards.length;
    final percentage = (accuracy * 100).round();
    final isLearned = ref.watch(progressControllerProvider.notifier).isLearned(widget.topicId);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Result icon
          Icon(
            isLearned ? Icons.celebration : Icons.emoji_events,
            size: 80,
            color: isLearned ? Colors.green : Colors.orange,
          ),
          
          const SizedBox(height: 24),
          
          // Score
          Text(
            '$percentage%',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLearned ? Colors.green : Colors.orange,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '$_correctAnswers out of ${_quizCards.length} correct',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          
          const SizedBox(height: 24),
          
          // Progress status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    isLearned ? 'Topic Mastered! 🎉' : 'Keep practicing! 💪',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLearned ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLearned 
                      ? 'You\'ve learned this topic well!'
                      : 'You need ${((0.9 - accuracy) * _quizCards.length).round()} more correct answers to master this topic.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _restartQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/topic/${widget.topicId}'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Back to Topics'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 