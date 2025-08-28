import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../topics/data/topics_repository.dart';
import '../topics/models/card_item.dart';
import '../topics/models/topic.dart';
import '../../services/audio/tts_service.dart';

class LearnScreen extends ConsumerStatefulWidget {
  final String topicId;

  const LearnScreen({
    super.key,
    required this.topicId,
  });

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  late PageController _pageController;
  late Future<List<CardItem>> _cardsFuture;
  late Future<Topic?> _topicFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _cardsFuture = _loadCards();
    _topicFuture = _loadTopic();
  }

  Future<List<CardItem>> _loadCards() async {
    final repository = TopicsRepository();
    final cards = await repository.getCardsByTopic(widget.topicId);
    print('Loaded ${cards.length} cards for topic ${widget.topicId}');
    return cards;
  }

  Future<Topic?> _loadTopic() async {
    final repository = TopicsRepository();
    final topic = await repository.getTopicById(widget.topicId);
    print('Loaded topic: ${topic?.titleRu} for topicId ${widget.topicId}');
    return topic;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Color _getArticleColor(Article article) {
    switch (article) {
      case Article.der:
        return Colors.blue;
      case Article.die:
        return Colors.red;
      case Article.das:
        return Colors.green;
    }
  }

  Future<void> _playAudio(CardItem card) async {
    final fullText = '${card.getArticleText()} ${card.nounDe}';
    await TTSService.speak(fullText);
  }

  @override
  Widget build(BuildContext context) {
    print('LearnScreen build called for topicId: ${widget.topicId}');
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Topic?>(
          future: _topicFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final topic = snapshot.data!;
              final locale = context.locale.languageCode;
              final title = locale == 'uk' ? topic.titleUk : topic.titleRu;
              return Text(title);
            }
            return Text('learn.title'.tr());
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/topic/${widget.topicId}'),
        ),
        actions: [
          FutureBuilder<List<CardItem>>(
            future: _cardsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final totalCards = snapshot.data!.length;
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Text(
                      '${_currentIndex + 1}/$totalCards',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
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
                  Icon(Icons.error, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading cards',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            );
          }

          final cards = snapshot.data!;
          if (cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No cards found for this topic',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return _buildCard(card);
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(CardItem card) {
    final locale = context.locale.languageCode;
    final translation = card.getTranslation(locale);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    card.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Failed to load image: ${card.imageAsset}');
                      print('Error: $error');
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image not found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Path: ${card.imageAsset}',
                              style: TextStyle(
                                color: Colors.grey[500],
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
            
            // Content section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // German word with article
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          card.getArticleText(),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: _getArticleColor(card.article),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            card.nounDe,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    // Phonetic hint (if available)
                    if (card.phonetic.isNotEmpty)
                      Text(
                        card.phonetic,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    
                    // Russian translation
                    Text(
                      translation,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    // Audio button
                    IconButton(
                      onPressed: () => _playAudio(card),
                      icon: const Icon(Icons.volume_up),
                      iconSize: 32,
                      color: Theme.of(context).primaryColor,
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