import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/subscription_service.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';

/// Beautiful paywall screen for premium subscription
///
/// Features:
/// - 7-day free trial offer
/// - Premium benefits showcase
/// - Subscription package selection
/// - Restore purchases option
/// - Terms and privacy links
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isLoading = false;
  List<Package>? _packages;
  Package? _selectedPackage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    try {
      final subscriptionService = await SubscriptionService.getInstance();
      final packages = await subscriptionService.getAvailablePackages();

      if (mounted) {
        setState(() {
          _packages = packages;
          // Select the first package by default (usually monthly)
          if (packages.isNotEmpty) {
            _selectedPackage = packages.first;
          }
        });
      }
    } catch (e) {
      // RevenueCat not configured - that's okay, we'll show demo mode
      if (mounted) {
        setState(() {
          _packages = [];
        });
      }
    }
  }

  Future<void> _purchasePackage() async {
    if (_selectedPackage == null) {
      _showDemoModeDialog();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final subscriptionService = await SubscriptionService.getInstance();
      final success = await subscriptionService.purchasePackage(_selectedPackage!);

      if (!mounted) return;

      if (success) {
        // Show success and return to previous screen
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome to Premium!'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Purchase was cancelled or failed. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final subscriptionService = await SubscriptionService.getInstance();
      final restored = await subscriptionService.restorePurchases();

      if (!mounted) return;

      if (restored) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchases restored successfully!'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'No previous purchases found.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to restore purchases: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDemoModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Demo Mode'),
        content: Text(
          'RevenueCat is not configured yet. To enable real subscriptions:\n\n'
          '1. Create account at revenuecat.com\n'
          '2. Set up your app and products\n'
          '3. Add API key to SubscriptionService\n\n'
          'For testing, you can use the demo mode button below.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final subscriptionService = await SubscriptionService.getInstance();
              await subscriptionService.startTrial();
              if (mounted) {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Demo trial activated!'),
                    backgroundColor: AppTheme.accentGreen,
                  ),
                );
              }
            },
            child: Text('Activate Demo Trial'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Premium Icon
                    _buildPremiumIcon(),

                    const SizedBox(height: 24),

                    // Trial Offer
                    _buildTrialOffer(),

                    const SizedBox(height: 32),

                    // Benefits List
                    _buildBenefitsList(),

                    const SizedBox(height: 32),

                    // Subscription Packages
                    if (_packages != null && _packages!.isNotEmpty)
                      _buildPackageSelection(),

                    const SizedBox(height: 24),

                    // Error Message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // CTA Button
                    _buildCTAButton(),

                    const SizedBox(height: 16),

                    // Restore Purchases
                    _buildRestoreButton(),

                    const SizedBox(height: 24),

                    // Footer Links
                    _buildFooterLinks(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildPremiumIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: AppTheme.brandGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.brandRed.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Icon(
        Icons.workspace_premium,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTrialOffer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryIndigo,
            AppTheme.secondaryPurple,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryIndigo.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Start Your Free Trial',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '7 days free, then \$4.99/month',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Cancel anytime',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      {
        'icon': Icons.lock_open,
        'title': 'Unlock All Topics',
        'description': '6 premium topics with 160+ vocabulary cards',
      },
      {
        'icon': Icons.psychology,
        'title': 'Smart Learning',
        'description': 'AI-powered spaced repetition system',
      },
      {
        'icon': Icons.trending_up,
        'title': 'Track Progress',
        'description': 'Detailed statistics and learning insights',
      },
      {
        'icon': Icons.devices,
        'title': 'Sync Everywhere',
        'description': 'Access your progress on all devices',
      },
      {
        'icon': Icons.support,
        'title': 'Premium Support',
        'description': 'Priority customer support',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Benefits',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...benefits.map((benefit) => _buildBenefitItem(
          icon: benefit['icon'] as IconData,
          title: benefit['title'] as String,
          description: benefit['description'] as String,
        )),
      ],
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.brandGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildPackageSelection() {
    return Column(
      children: _packages!.map((package) {
        final isSelected = package == _selectedPackage;
        final product = package.storeProduct;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPackage = package;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryIndigo.withValues(alpha: 0.1)
                  : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryIndigo
                    : AppTheme.textSecondary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? AppTheme.primaryIndigo : AppTheme.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (product.description.isNotEmpty)
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  product.priceString,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCTAButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _purchasePackage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.brandRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Start Free Trial',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildRestoreButton() {
    return TextButton(
      onPressed: _isLoading ? null : _restorePurchases,
      child: Text(
        'Restore Purchases',
        style: TextStyle(
          fontSize: 16,
          color: AppTheme.primaryIndigo,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            // TODO: Open terms of service
          },
          child: Text(
            'Terms',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Text(
          ' • ',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        TextButton(
          onPressed: () {
            // TODO: Open privacy policy
          },
          child: Text(
            'Privacy',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
