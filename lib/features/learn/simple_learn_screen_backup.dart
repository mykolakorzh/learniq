import 'package:flutter/material.dart';
import '../../../shared/models/card_item.dart';
import '../../../shared/services/data_service.dart';
import '../../../services/audio/tts_service.dart';

class SimpleLearnScreen extends StatefulWidget {
  const SimpleLearnScreen({super.key, required this.topicId});
  
  final String topicId;

  @override
  State<SimpleLearnScreen> createState() => _SimpleLearnScreenState();
}

class _SimpleLearnScreenState extends State<SimpleLearnScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn'),
        actions: [
          FutureBuilder<List<CardItem>>(
            future: DataService.loadCardsForTopic(widget.topicId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final totalCards = snapshot.data!.length;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      '${_currentIndex + 1} / $totalCards',
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
        future: DataService.loadCardsForTopic(widget.topicId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  const Text('Failed to load cards'),
                ],
              ),
            );
          }
          
          final cards = snapshot.data ?? [];
          
          if (cards.isEmpty) {
            return const Center(
              child: Text('No cards found for this topic'),
            );
          }
          
          return PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _showTranslation = false; // Reset translation when swiping
              });
            },
            itemCount: cards.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _CardView(
                card: cards[index],
                showTranslation: _showTranslation,
                onTap: () {
                  setState(() {
                    _showTranslation = !_showTranslation;
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _CardView extends StatefulWidget {
  const _CardView({
    required this.card,
    required this.showTranslation,
    required this.onTap,
  });
  
  final CardItem card;
  final bool showTranslation;
  final VoidCallback onTap;

  @override
  State<_CardView> createState() => _CardViewState();
}

class _CardViewState extends State<_CardView> {
  bool _isPressed = false;

  Color get _articleColor {
    switch (widget.card.article) {
      case Article.der:
        return Colors.blue;
      case Article.die:
        return Colors.red;
      case Article.das:
        return Colors.green;
    }
  }

  void _speakGerman() {
    final fullText = '${widget.card.getArticleText()} ${widget.card.nounDe}';
    TTSService.speak(fullText);
  }

  void _speakTranslation() {
    TTSService.setLanguage('ru-RU'); // Set to Russian for translation
    TTSService.speak(widget.card.translationRu);
    // Reset back to German for next German word
    TTSService.setLanguage('de-DE');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: _isPressed ? 2 : 8,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image section
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.card.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // German word with article
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            widget.card.getArticleText(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _articleColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              widget.card.nounDe,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () => _speakGerman(),
                            icon: const Icon(Icons.volume_up),
                            iconSize: 24,
                            color: Colors.blue,
                            tooltip: 'Pronounce German word',
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Translation (shown on tap)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: widget.showTranslation
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.card.translationRu,
                                      key: const ValueKey('translation'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey.shade700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    onPressed: () => _speakTranslation(),
                                    icon: const Icon(Icons.volume_up),
                                    iconSize: 20,
                                    color: Colors.green,
                                    tooltip: 'Pronounce translation',
                                  ),
                                ],
                              )
                            : Text(
                                'Tap to see translation',
                                key: const ValueKey('hint'),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
