import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../features/topics/view/topics_screen.dart';
import '../widgets/animations.dart';
import 'statistics_screen.dart';
import 'account_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late List<AnimationController> _tabAnimationControllers;
  late List<Animation<double>> _tabAnimations;

  final List<NavigationTab> _tabs = [
    NavigationTab(
      icon: Icons.school_outlined,
      activeIcon: Icons.school,
      label: 'Topics',
      page: const TopicsScreen(),
    ),
    NavigationTab(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Statistics',
      page: const StatisticsScreen(),
    ),
    NavigationTab(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Account',
      page: const AccountScreen(),
    ),
    NavigationTab(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
      page: const SettingsScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabAnimationControllers = List.generate(
      _tabs.length,
      (index) => AnimationController(
        duration: Animations.medium,
        vsync: this,
      ),
    );
    _tabAnimations = _tabAnimationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start with first tab active
    _tabAnimationControllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _tabAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    HapticFeedback.lightImpact();

    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: Animations.pageTransition,
      curve: Curves.easeInOut,
    );

    // Animate tab icons
    for (int i = 0; i < _tabAnimationControllers.length; i++) {
      if (i == index) {
        _tabAnimationControllers[i].forward();
      } else {
        _tabAnimationControllers[i].reverse();
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Animate tab icons
    for (int i = 0; i < _tabAnimationControllers.length; i++) {
      if (i == index) {
        _tabAnimationControllers[i].forward();
      } else {
        _tabAnimationControllers[i].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _tabs.map((tab) => tab.page).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final isActive = _currentIndex == index;

                return Expanded(
                  child: _ModernTabButton(
                    tab: tab,
                    isActive: isActive,
                    animation: _tabAnimations[index],
                    onTap: () => _onTabTapped(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget page;

  const NavigationTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.page,
  });
}

class _ModernTabButton extends StatelessWidget {
  final NavigationTab tab;
  final bool isActive;
  final Animation<double> animation;
  final VoidCallback onTap;

  const _ModernTabButton({
    required this.tab,
    required this.isActive,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 0.95 : 1.0,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle for active state
                    if (isActive)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.2),
                              Theme.of(context).primaryColor.withOpacity(0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    // Icon
                    Icon(
                      isActive ? tab.activeIcon : tab.icon,
                      size: 24,
                      color: isActive
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: Animations.fast,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
              ),
              child: Text(tab.label),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom page route with modern transitions
class ModernPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final RouteSettings? settings;

  ModernPageRoute({
    required this.page,
    this.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: Animations.pageTransition,
        );
}
