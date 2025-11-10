import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../services/data_service.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/modern_components.dart';
import '../widgets/animations.dart';
import '../core/theme/app_theme.dart';
import 'topic_detail_screen.dart';
import '../l10n/app_localizations.dart';

enum TopicFilter { all, free, premium }

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late Future<List<Topic>> _topicsFuture;
  String _searchQuery = '';
  TopicFilter _selectedFilter = TopicFilter.all;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _topicsFuture = DataService.loadTopics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Topic> _filterTopics(BuildContext context, List<Topic> topics) {
    final locale = Localizations.localeOf(context).languageCode;
    var filtered = topics;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((topic) {
        return topic.getTitle(locale).toLowerCase().contains(_searchQuery.toLowerCase()) ||
            topic.titleRu.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply free/premium filter
    if (_selectedFilter == TopicFilter.free) {
      filtered = filtered.where((topic) => topic.isFree).toList();
    } else if (_selectedFilter == TopicFilter.premium) {
      filtered = filtered.where((topic) => !topic.isFree).toList();
    }

    return filtered;
  }

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
          child: FutureBuilder<List<Topic>>(
            future: _topicsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    _buildHeader(l10n),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: 5,
                        itemBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: SkeletonTopicCard(),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Column(
                  children: [
                    _buildHeader(l10n),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: ModernErrorWidget(
                            title: l10n.topicsFailedToLoad,
                            message: l10n.topicsError(snapshot.error.toString()),
                            onRetry: () {
                              setState(() {
                                _topicsFuture = DataService.loadTopics();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              final allTopics = snapshot.data!;
              final filteredTopics = _filterTopics(context, allTopics);

              // Hide filter chips - not useful with current topic distribution
              final showFilters = false;

              return Column(
                children: [
                  _buildHeader(l10n),
                  if (showFilters) _buildFilterChips(l10n),
                  Expanded(
                    child: filteredTopics.isEmpty
                        ? _buildEmptyState(l10n)
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            itemCount: filteredTopics.length,
                            itemBuilder: (context, index) {
                              final topic = filteredTopics[index];
                              return StaggeredAnimationItem(
                                index: index,
                                child: _buildTopicCard(topic, l10n),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Learniq Logo with brand gradient background
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: AppTheme.brandGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.brandRed.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/Learniq_logo_short.png',
                fit: BoxFit.cover,
              ),
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
                  l10n.topicsSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: l10n.topicsSearchHint,
            hintStyle: TextStyle(color: AppTheme.textSecondary),
            prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: AppTheme.textSecondary),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildFilterChip(
            label: l10n.topicsAll,
            isSelected: _selectedFilter == TopicFilter.all,
            onTap: () {
              setState(() {
                _selectedFilter = TopicFilter.all;
              });
            },
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: l10n.topicsFree,
            isSelected: _selectedFilter == TopicFilter.free,
            onTap: () {
              setState(() {
                _selectedFilter = TopicFilter.free;
              });
            },
            icon: Icons.check_circle,
            color: AppTheme.accentGreen,
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: l10n.topicsPremium,
            isSelected: _selectedFilter == TopicFilter.premium,
            onTap: () {
              setState(() {
                _selectedFilter = TopicFilter.premium;
              });
            },
            icon: Icons.workspace_premium,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    Color? color,
  }) {
    return CustomAnimatedScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppTheme.primaryIndigo).withValues(alpha: 0.1)
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? AppTheme.primaryIndigo).withValues(alpha: 0.3)
                : AppTheme.textSecondary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? (color ?? AppTheme.primaryIndigo)
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? (color ?? AppTheme.primaryIndigo)
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(Topic topic, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).languageCode;
    return CustomAnimatedScale(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicDetailScreen(topic: topic),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            topic.getTitle(locale),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: topic.isFree
                                ? AppTheme.accentGreen.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                topic.isFree ? Icons.check_circle : Icons.lock,
                                size: 14,
                                color: topic.isFree ? AppTheme.accentGreen : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                topic.isFree ? l10n.topicsFree : l10n.topicsPremium,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: topic.isFree ? AppTheme.accentGreen : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.style,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.topicsCardCount(topic.cardCount),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.topicsNoTopicsFound,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.topicsAdjustFilters,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ModernButton(
              text: l10n.topicsClearFilters,
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                  _selectedFilter = TopicFilter.all;
                });
              },
              icon: Icons.clear_all,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}
