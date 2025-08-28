import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DragDropDemo extends StatefulWidget {
  const DragDropDemo({super.key});

  @override
  State<DragDropDemo> createState() => _DragDropDemoState();
}

class _DragDropDemoState extends State<DragDropDemo>
    with TickerProviderStateMixin {
  String? _selectedArticle;
  bool _isAnimating = false;
  bool _isImageColored = false;
  bool _showConfetti = false;

  // Animation controllers
  late AnimationController _imageAnimationController;
  late AnimationController _shakeAnimationController;
  late AnimationController _chipAnimationController;

  // Animation values
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _chipBounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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

    // Start chip animation
    _chipAnimationController.forward();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _shakeAnimationController.dispose();
    _chipAnimationController.dispose();
    super.dispose();
  }

  void _handleArticleDrop(String droppedArticle) {
    if (_isAnimating) return;
    
    // For demo purposes, let's say "der" is correct
    final isCorrect = droppedArticle.toLowerCase() == 'der';
    
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
    setState(() {
      _isImageColored = true;
      _showConfetti = true;
    });
    
    _imageAnimationController.forward();
    
    // Auto-reset after animation
    await Future.delayed(const Duration(milliseconds: 1500));
    _resetDemo();
  }

  void _handleIncorrectAnswer() async {
    _shakeAnimationController.forward();
    
    // Show correct answer briefly
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _selectedArticle = 'der'; // Show correct answer
    });
    
    // Auto-reset after showing correct answer
    await Future.delayed(const Duration(milliseconds: 1200));
    _resetDemo();
  }

  void _resetDemo() {
    setState(() {
      _selectedArticle = null;
      _isAnimating = false;
      _isImageColored = false;
      _showConfetti = false;
    });
    
    // Reset animations
    _imageAnimationController.reset();
    _shakeAnimationController.reset();
    _chipAnimationController.reset();
    
    // Start chip animation for new question
    _chipAnimationController.forward();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag & Drop Demo'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Demo instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      '🎯 Demo Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Drag "der" to see the correct answer animation\n'
                      '• Drag "die" or "das" to see the incorrect answer animation\n'
                      '• The image starts grayscale and becomes colored on correct answers',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
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
                          child: Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _isImageColored ? '🎉 Colored!' : '📷 Grayscale',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                  const Text(
                    'Haus',
                    style: TextStyle(
                      fontSize: 24,
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
    );
  }
}
