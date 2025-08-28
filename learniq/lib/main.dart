import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(const LearnIQApp());
}

class LearnIQApp extends StatelessWidget {
  const LearnIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learniq',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TopicsScreen(),
    );
  }
}

// Topic Model
class Topic {
  final String id;
  final String titleRu;
  final String titleUk;
  final bool isFree;
  final int cardCount;
  final String iconAsset;
  final int order;

  Topic({
    required this.id,
    required this.titleRu,
    required this.titleUk,
    required this.isFree,
    required this.cardCount,
    required this.iconAsset,
    required this.order,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id']?.toString() ?? '',
      titleRu: json['title_ru']?.toString() ?? '',
      titleUk: json['title_uk']?.toString() ?? '',
      isFree: json['is_free'] as bool? ?? false,
      cardCount: json['card_count'] as int? ?? 0,
      iconAsset: json['icon_asset']?.toString() ?? '',
      order: json['order'] as int? ?? 0,
    );
  }

  String get title => titleRu.isNotEmpty ? titleRu : 'Unknown Topic';
}

// Card Model
class CardItem {
  final String id;
  final String topicId;
  final String nounDe;
  final String article;
  final String phonetic;
  final String translationRu;
  final String translationUk;
  final String imageAsset;

  CardItem({
    required this.id,
    required this.topicId,
    required this.nounDe,
    required this.article,
    required this.phonetic,
    required this.translationRu,
    required this.translationUk,
    required this.imageAsset,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id']?.toString() ?? '',
      topicId: json['topic_id']?.toString() ?? '',
      nounDe: json['noun_de']?.toString() ?? '',
      article: json['article']?.toString() ?? '',
      phonetic: json['phonetic']?.toString() ?? '',
      translationRu: json['translation_ru']?.toString() ?? '',
      translationUk: json['translation_uk']?.toString() ?? '',
      imageAsset: json['image_asset']?.toString() ?? '',
    );
  }

  String get translation => translationRu.isNotEmpty ? translationRu : 'No translation';
}

// Data Service
class DataService {
  static Future<List<Topic>> loadTopics() async {
    try {
      final String response = await rootBundle.loadString('assets/data/topics.json');
      final List<dynamic> jsonList = json.decode(response);
      return jsonList.map((json) => Topic.fromJson(json)).toList();
    } catch (e) {
      print('Error loading topics: $e');
      return [];
    }
  }

  static Future<List<CardItem>> loadCards() async {
    try {
      final String response = await rootBundle.loadString('assets/data/cards.json');
      final List<dynamic> jsonList = json.decode(response);
      return jsonList.map((json) => CardItem.fromJson(json)).toList();
    } catch (e) {
      print('Error loading cards: $e');
      return [];
    }
  }

  static Future<List<CardItem>> loadCardsForTopic(String topicId) async {
    try {
      final List<CardItem> allCards = await loadCards();
      return allCards.where((card) => card.topicId == topicId).toList();
    } catch (e) {
      print('Error loading cards for topic $topicId: $e');
      return [];
    }
  }
}

// Topics Screen
class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late Future<List<Topic>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = DataService.loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learniq'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Topic>>(
        future: _topicsFuture,
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
                        _topicsFuture = DataService.loadTopics();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final topics = snapshot.data!;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.folder,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ),
                  title: Text(
                    topic.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${topic.cardCount} cards',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: topic.isFree
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.lock, color: Colors.orange),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicDetailScreen(topic: topic),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Topic Detail Screen
class TopicDetailScreen extends StatelessWidget {
  final Topic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Topic Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.folder,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${topic.cardCount} cards available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Learn Mode Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LearnScreen(topicId: topic.id),
                  ),
                );
              },
              icon: const Icon(Icons.school, size: 24),
              label: const Text(
                'Learn Mode',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test Mode Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestScreen(topicId: topic.id),
                  ),
                );
              },
              icon: const Icon(Icons.quiz, size: 24),
              label: const Text(
                'Test Mode',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const Spacer(),
            
            // Mode Descriptions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mode Descriptions:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.school, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Learn Mode: Study vocabulary with images and translations',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.quiz, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Test Mode: Practice with drag-and-drop article selection',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Learn Screen
class LearnScreen extends StatefulWidget {
  final String topicId;

  const LearnScreen({super.key, required this.topicId});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late Future<List<CardItem>> _cardsFuture;
  PageController? _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _cardsFuture = DataService.loadCardsForTopic(widget.topicId);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Mode'),
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

          final cards = snapshot.data ?? [];
          
          if (cards.isEmpty) {
            return const Center(
              child: Text('No cards available for this topic.'),
            );
          }

          if (_currentIndex >= cards.length) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    'Congratulations!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'ve completed all ${cards.length} cards!',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                        _pageController?.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    child: const Text('Start Over'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
              
              // Swipeable cards
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final currentCard = cards[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Image
                              Expanded(
                                flex: 2,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
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
                              
                              const SizedBox(height: 24),
                              
                              // German word with article
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _getArticleColor(currentCard.article),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${currentCard.article.toUpperCase()} ${currentCard.nounDe}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Translation
                              Text(
                                currentCard.translation,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Swipe hint
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.swipe_left, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Swipe to navigate',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.swipe_right, color: Colors.grey.shade600, size: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getArticleColor(String article) {
    switch (article.toLowerCase()) {
      case 'der':
        return const Color(0xFF1976D2);
      case 'die':
        return const Color(0xFFE53935);
      case 'das':
        return const Color(0xFF43A047);
      default:
        return Colors.grey;
    }
  }
}

// Test Screen
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