import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/onboarding_service.dart';
import '../widgets/modern_components.dart';
import '../widgets/animations.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    // Reset and replay animation on page change
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _completeOnboarding() async {
    HapticFeedback.mediumImpact();
    await OnboardingService.setOnboardingCompleted();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    // Check pages length from context
    final context = this.context;
    final l10n = AppLocalizations.of(context)!;
    final pagesLength = 4; // We have 4 onboarding pages

    if (_currentPage < pagesLength - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<OnboardingPage> pages = [
      OnboardingPage(
        icon: Icons.translate,
        title: l10n.onboardingPage1Title,
        description: l10n.onboardingPage1Description,
        gradient: AppTheme.primaryGradient,
      ),
      OnboardingPage(
        icon: Icons.quiz,
        title: l10n.onboardingPage2Title,
        description: l10n.onboardingPage2Description,
        gradient: AppTheme.successGradient,
      ),
      OnboardingPage(
        icon: Icons.volume_up,
        title: l10n.onboardingPage3Title,
        description: l10n.onboardingPage3Description,
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
        ),
      ),
      OnboardingPage(
        icon: Icons.analytics,
        title: l10n.onboardingPage4Title,
        description: l10n.onboardingPage4Description,
        gradient: const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
        ),
      ),
    ];

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
            // Skip button
            if (_currentPage < pages.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomAnimatedScale(
                    onTap: _skipOnboarding,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n.onboardingSkip,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryIndigo,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 70),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => _buildPageIndicator(index, pages),
                ),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: pages[_currentPage].gradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryIndigo.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CustomAnimatedScale(
                  onTap: _nextPage,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage < pages.length - 1
                              ? l10n.onboardingNext
                              : l10n.onboardingGetStarted,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (_currentPage < pages.length - 1) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with animations
          FadeTransition(
            opacity: _animationController,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: AnimatedPulse(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: page.gradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryIndigo.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Icon(
                    page.icon,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Title with animation
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.2, 1.0),
              ),
              child: Text(
                page.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Description with animation
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.4, 1.0),
              ),
              child: Text(
                page.description,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index, List<OnboardingPage> pages) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        gradient: isActive ? pages[_currentPage].gradient : null,
        color: isActive ? null : AppTheme.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive ? [
          BoxShadow(
            color: AppTheme.primaryIndigo.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
