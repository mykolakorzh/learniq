import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/card_item.dart';
import '../services/data_service.dart';

class TestScreen extends StatefulWidget {
  final String topicId;

  const TestScreen({super.key, required this.topicId});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AnimationController _shakeAnimationController;
  late AnimationController _chipAnimationController;
  
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _chipBounceAnimation;
  
  late Future<List<CardItem>> _cardsFuture;
  List<CardItem> _cards = [];
  int _currentIndex = 0;
  String? _selectedArticle;
  bool _isAnimating = false;
  bool _isImageColored = false;

  @override
  void initState() {
    super.initState();
    
    _imageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _chipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _imageScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeAnimationController,
      curve: Curves.elasticIn,
    ));
    
    _chipBounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _chipAnimationController,
      curve: Curves.bounceOut,
    ));
    
    _cardsFuture = DataService.loadCardsForTopic(widget.topicId);
    _cardsFuture.then((cards) {
      setState(() {
        _cards = cards;
      });
    });
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _shakeAnimationController.dispose();
    _chipAnimationController.dispose();
    super.dispose();
  }

  void _handleArticleDrop(String article) {
    if (_isAnimating || _cards.isEmpty) return;
    
    setState(() {
      _selectedArticle = article;
      _isAnimating = true;
    });
    
    HapticFeedback.mediumImpact();
    
    final currentCard = _cards[_currentIndex];
    if (article.toUpperCase() == currentCard.article.toUpperCase()) {
      _handleCorrectAnswer();
    } else {
      _handleIncorrectAnswer();
    }
  }

  void _handleCorrectAnswer() {
    _imageAnimationController.forward();
    
    setState(() {
      _isImageColored = true;
    });
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      _advanceToNextQuestion();
    });
  }

  void _handleIncorrectAnswer() {
    _shakeAnimationController.forward();
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _selectedArticle = _cards[_currentIndex].article.toUpperCase();
      });
      
      Future.delayed(const Duration(milliseconds: 1000), () {
        _advanceToNextQuestion();
      });
    });
  }

  void _advanceToNextQuestion() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedArticle = null;
        _isAnimating = false;
        _isImageColored = false;
      });
      
      _imageAnimationController.reset();
      _shakeAnimationController.reset();
    } else {
      // Test completed
      setState(() {
        _selectedArticle = null;
        _isAnimating = false;
        _isImageColored = false;
      });
    }
  }

  Color _getArticleColor(String article) {
    switch (article.toUpperCase()) {
      case 'DER':
        return const Color(0xFF1976D2);
      case 'DIE':
        return const Color(0xFFE53935);
      case 'DAS':
        return const Color(0xFF43A047);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Mode'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<CardItem>>(
        future: _cardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _cardsFuture = DataService.loadCardsForTopic(widget.topicId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final cards = snapshot.data!;
          
          if (cards.isEmpty) {
            return const Center(
              child: Text('No cards available for this topic.'),
            );
          }

          // Test completed
          if (_currentIndex >= cards.length) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.celebration, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    'Test Completed!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You completed all ${cards.length} questions!',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                        _selectedArticle = null;
                        _isAnimating = false;
                        _isImageColored = false;
                      });
                    },
                    child: const Text('Start Over'),
                  ),
                ],
              ),
            );
          }

          final currentCard = cards[_currentIndex];
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / cards.length,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_currentIndex + 1} of ${cards.length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Grayscale Image
                Expanded(
                  flex: 2,
                  child: AnimatedBuilder(
                    animation: _imageScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _imageScaleAnimation.value,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.shade100,
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
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                      color: Colors.grey,
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
                
                // German Word + Drop Zone
                Expanded(
                  flex: 1,
                  child: AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _shakeAnimation.value * 10 * (_selectedArticle == currentCard.article.toUpperCase() ? 0 : 1),
                          0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentCard.nounDe,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DragTarget<String>(
                              onWillAcceptWithDetails: (details) => true,
                              onAcceptWithDetails: (details) {
                                _handleArticleDrop(details.data);
                              },
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: _selectedArticle != null
                                        ? _getArticleColor(_selectedArticle!)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _selectedArticle != null
                                          ? _getArticleColor(_selectedArticle!)
                                          : Colors.grey.shade300,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _selectedArticle ?? 'Drop article here',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _selectedArticle != null
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Draggable Article Chips
                Expanded(
                  flex: 1,
                  child: AnimatedBuilder(
                    animation: _chipBounceAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _chipBounceAnimation.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['DER', 'DIE', 'DAS'].map((article) {
                            return Draggable<String>(
                              data: article,
                              feedback: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 80,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: _getArticleColor(article),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      article,
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
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    article,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () => _handleArticleDrop(article),
                                child: Container(
                                  width: 80,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: _getArticleColor(article),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      article,
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
          );
        },
      ),
    );
  }
}
