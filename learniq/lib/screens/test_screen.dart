import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/card_item.dart';
import '../services/data_service.dart';

class TestScreen extends StatefulWidget {
  final String topicId;

  const TestScreen({super.key, required this.topicId});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Future<List<CardItem>> _cardsFuture;
  List<CardItem> _quizCards = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _isQuizComplete = false;
  List<String> _mistakes = [];
  List<CardItem> _mistakeCards = [];
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
      setState(() {
        _quizCards = cards..shuffle();
        _isLoading = false;
      });
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
        _mistakeCards.add(currentCard);
      }
    });

    // Auto-advance after showing result
    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quizCards.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedArticle = null;
        _showResult = false;
        _isCorrect = false;
        _showConfetti = false;
      });
    } else {
      setState(() {
        _isQuizComplete = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _isQuizComplete = false;
      _mistakes.clear();
      _mistakeCards.clear();
      _selectedArticle = null;
      _showResult = false;
      _isCorrect = false;
      _isMistakesOnlyMode = false;
      _showConfetti = false;
      _quizCards.shuffle();
    });
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
    switch (article.toLowerCase()) {
      case 'der':
        return const Color(0xFF2196F3); // Blue
      case 'die':
        return const Color(0xFFE91E63); // Pink
      case 'das':
        return const Color(0xFF4CAF50); // Green
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_quizCards.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text('Test'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF333333),
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'No cards available for this topic.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ),
      );
    }

    if (_isQuizComplete) {
      final accuracy = (_correctAnswers / _quizCards.length * 100).round();
      final hasMistakes = _mistakes.isNotEmpty;
      
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text(_isMistakesOnlyMode ? 'Review Complete' : 'Test Complete'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF333333),
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: accuracy >= 80 
                              ? const Color(0xFF4CAF50).withOpacity(0.1)
                              : const Color(0xFFFF9800).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          accuracy >= 80 ? Icons.check_circle : Icons.emoji_events,
                          size: 50,
                          color: accuracy >= 80 
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFFF9800),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Title
                      Text(
                        _isMistakesOnlyMode ? 'Review Complete!' : 'Test Complete!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Score
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$_correctAnswers / ${_quizCards.length}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Accuracy: $accuracy%',
                              style: TextStyle(
                                fontSize: 18,
                                color: accuracy >= 80 
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFFF9800),
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
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _retryMistakesOnly,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Practice Mistakes (${_mistakes.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2196F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Color(0xFF2196F3), width: 2),
                          ),
                        ),
                        child: const Text(
                          'Go Home',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (_mistakes.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mistakes to Review:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
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
                                    const Icon(
                                      Icons.close,
                                      color: Color(0xFFE91E63),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _mistakes[index],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF666666),
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
      );
    }

    final currentCard = _quizCards[_currentQuestionIndex];
    final grayImagePath = _getGrayImagePath(currentCard.imageAsset);
    final colorfulImagePath = currentCard.imageAsset;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Test'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentQuestionIndex + 1}/${_quizCards.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2196F3),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Progress bar
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _quizCards.length,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Image
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        _showResult && _isCorrect ? colorfulImagePath : grayImagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF5F5F5),
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Color(0xFFCCCCCC),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Drag and drop area
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Drag the correct article:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Drop target
                        DragTarget<String>(
                          onAccept: (article) => _onArticleDropped(article),
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _selectedArticle != null 
                                    ? _getArticleColor(_selectedArticle!)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: candidateData.isNotEmpty 
                                      ? const Color(0xFF2196F3)
                                      : const Color(0xFFE0E0E0),
                                  width: candidateData.isNotEmpty ? 3 : 2,
                                ),
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
                                    : const Text(
                                        '___',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFFCCCCCC),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // German word
                        Text(
                          currentCard.nounDe,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Draggable articles
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Text(
                      'Choose from:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
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
                                color: _getArticleColor(article),
                                borderRadius: BorderRadius.circular(16),
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
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.drag_indicator,
                                color: Color(0xFFCCCCCC),
                                size: 32,
                              ),
                            ),
                          ),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isUsed ? 0.3 : 1.0,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _getArticleColor(article),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getArticleColor(article).withOpacity(0.3),
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
                        );
                      }).toList(),
                    ),
                    
                    if (_showResult) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: _isCorrect 
                              ? const Color(0xFF4CAF50).withOpacity(0.1)
                              : const Color(0xFFE91E63).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _isCorrect ? '✓ Correct!' : '✗ Incorrect!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _isCorrect 
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFE91E63),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
          ),
          
          // Confetti overlay
          if (_showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: Lottie.asset(
                  'assets/animations/confetti.json',
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              ),
            ),
        ],
      ),
    );
  }
}